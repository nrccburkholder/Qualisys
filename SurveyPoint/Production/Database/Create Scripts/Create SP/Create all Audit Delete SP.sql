   
CREATE procedure Audit_CreateBatchEntry (@StartorEnd as varchar(5) = 'Start')    
as    
Begin    
     
 if upper(@StartorEnd) = 'START'    
  begin    
   Insert into Audit_DeleteBatch (BatchStartTime) select GetDate()    
  end    
 else    
  begin    
   Update Audit_DeleteBatch set BatchEndTime = GetDate() where Audit_DeleteBatchID = (Select Max(Audit_DeleteBatchID) from Audit_DeleteBatch)    
  end     
    
end

go

/*    
MWB 1/8/08    
This functions is designed to capture the space used by a the current database at a point in time to put that value in an audit table.    
The @BeforeOrAfter is used in Auditing to tell which time we ran it, before the weekly delete or after the delete.    
1 represents before and 2 represents after.    
*/    
CREATE procedure Audit_CaptureSpaceUsed (@BeforeOrAfter smallint = 1)    
as    
Begin    
    
    
declare @dbname sysname      
declare @dbsize dec(15,0)      
declare @logsize dec(15)      
declare @bytesperpage dec(15,0)      
declare @pagesperMB  dec(15,0)      
Declare @BatchID int    
  
select @BatchID = max(Audit_DeleteBatchID) from Audit_DeleteBatch   
  
 select @dbsize = sum(convert(dec(15),size))      
  from dbo.sysfiles      
  where (status & 64 = 0)      
      
 select @logsize = sum(convert(dec(15),size))      
  from dbo.sysfiles      
  where (status & 64 <> 0)      
      
 select @bytesperpage = low      
  from master.dbo.spt_values      
  where number = 1      
   and type = 'E'      
 select @pagesperMB = 1048576 / @bytesperpage      
    
Insert into Audit_SpaceUsed (Audit_DeleteBatchID, BeforeAfter, DatabaseName, DatabaseSize , LogSize, UnAllocatedSpace)    
 select  @BatchID, @BeforeOrAfter, db_name(),      
   ltrim(str((@dbsize) / @pagesperMB,15,2)),      
   ltrim(str((@logsize) / @pagesperMB,15,2)),      
  'unallocated space' =      
   ltrim(str((@dbsize -      
    (select sum(convert(dec(15),reserved))      
     from sysindexes      
      where indid in (0, 1, 255)      
    )) / @pagesperMB,15,2))      
    
    
end 

go

  
create Procedure Audit_MeasureQueryTime   
as  
  
begin  
  
 declare @StartDate datetime  
 declare @EndDate datetime  
 declare @TimeDiff int  
 declare @AuditBatchID int  
  
 select @AuditBatchID=max(Audit_DeleteBatchID) from Audit_DeleteBatch  
  
 select top 50 respondentID   
 into #tmpResp  
 from respondents   
 where surveyInstanceID = 4016  
 order by respondentID  
  
 set @StartDate = getDate()  
  
 select 'Respondent', Resps.*, 'RespProperties', RP.*, 'Responses', R.*, 'EventLog', EL.*  
 from respondents Resps, Respondentproperties RP, Responses R, EventLog EL  
 where Resps.RespondentID = RP.RespondentID and  
 Resps.RespondentID = EL.RespondentID and  
 Resps.RespondentID = R.RespondentID and  
 Resps.RespondentID in (select respondentID from #tmpResp)  
  
 set @EndDate = getDate()  
  
  
 SELECT @TimeDiff=cast(DATEDIFF(s, @StartDate, @EndDate) as int)  
  
 Insert into Audit_QueryTime (Audit_DeleteBatchID, StartDate, EndDate, DateDiffInSeconds)  
 select @AuditBatchID, @StartDate, @EndDate, @TimeDiff  
  
end  

go

/*                
MWB 11/12/2007                
This procedure runs once a weekl and removes data from the four largest tables (and there corisponding journal tables)                
By default 18 months of previous journal entries are kept and only respondents that have had a journal entry in the last                
18 months are eligible for deletion.                
For all other EventLog records @EventLogMonthsToKeep is sent in to remove all system events with a date older than              
These defaults can be changed to shorten the time once the data is gone from the OLTP system it is gone.                 
All data is still in the archive system (Samson as of now)                
                
NOTE: @NonRespEventIDsToKeep  and @EventLogMonthsToKeep must be a negative number                 
   b/c I am using the dateAdd function to get a stopping point.                  
   If you use a positve number it will never delete any records                
                
*/                
CREATE procedure Audit_DeleteOldDataFromLive                 
(                
@EventLogMonthsToKeep int = -18, @NonRespEventIDsToKeep int = -18              
)                
as                
                
Begin                
              
declare @RecCount int              
declare @BatchID int      
                
--first thing is to disable all triggers so our Deletes in the live tables are not carried over to the Archive system.                
--We only want to remove data from the OLTP system not the reporting seerer.                
exec sp_ChangeAllTriggerStatus 'Disable'                
print 'All triggers disabled'                
      
select @BatchID = max(Audit_DeleteBatchID) from Audit_DeleteBatch      
                
--now get list of respondentIDs that have not had an entry in the eventlog since the specified number of months                
select RespondentID, max(EventDate) as MaxEventDate                
into #Resp                
from eventlog                
group by RespondentID                
having max(EventDate) < dateadd(month,@EventLogMonthsToKeep,getdate())                
order by max(EventDate)                
set @RecCount = @@RowCount                
print 'Number of RespondentIDs found in Eventlog with a date older than ' + cast(dateadd(month,@EventLogMonthsToKeep,getdate()) as varchar(35)) + ' is ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'Number of Distinct RespondentIDs Found' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast          
  
    
              
              
--JOURNAL TABLES              
delete E               
from Respondentproperties_jn E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'RespondentProperties_jn Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'RespondentProperties_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
        
                
delete E               
from EventLog_jn E, #resp r                
where r.respondentID = e.respondentID              
set @RecCount = @@RowCount                
print 'EventLog_jn Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'EventLog_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
        
                
delete E               
from Responses_jn E, #resp r                
where r.respondentID = e.respondentID              
set @RecCount = @@RowCount                
print 'Responses_jn Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'Responses_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
                
        
delete E            
from respondents_jn E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'respondents_jn Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'respondents_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
        
                
delete E               
from RespondentRiskScores_jn E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'RespondentRiskScores_jn Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'RespondentRiskScores_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
        
            
Backup Log QMS with truncate_only            
dbcc shrinkfile (13, 100)            
              
--TRANSACTIONAL LIVE TABLES --              
                
delete E               
from Respondentproperties E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'Respondentproperties Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'Respondentproperties' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
                
                
delete E               
from EventLog E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'EventLog Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'EventLog' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
                
delete E               
from Responses E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'Responses Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'Responses' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
              
delete E               
from RespondentRiskScores E, #resp r                
where r.respondentID = e.respondentID               
set @RecCount = @@RowCount               
print 'RespondentRiskScores Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'RespondentRiskScores' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
              
delete E               
from SeniorHealthScores E, #resp r                
where r.respondentID = e.respondentID               
set @RecCount = @@RowCount               
print 'SeniorHealthScores Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'SeniorHealthScores' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
              
delete E               
from TELEMATCHOUT E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'TELEMATCHOUT Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'TELEMATCHOUT' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
              
              
delete E               
from respondents E, #resp r                
where r.respondentID = e.respondentID                
set @RecCount = @@RowCount              
print 'respondents Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'respondents' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
            
Backup Log QMS with truncate_only            
dbcc shrinkfile (13, 100)            
                
              
delete E               
from EventLog E              
where RespondentID is null and (EventTypeID in (1,2,6) or eventTypeID is null) and EventDate < dateadd(month,@NonRespEventIDsToKeep,getdate())               
set @RecCount = @@RowCount              
print 'EventLog - Non Respondent Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'EventLog - Non Respondent Records' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast              
        
delete E               
from EventLog_jn E              
where RespondentID is null and jn_DateTime < dateadd(month,@NonRespEventIDsToKeep,getdate())            
set @RecCount = @@RowCount              
print 'EventLog_jn - Non Respondent Records Deleted: ' + cast(@RecCount as varchar(10))                
insert into Audit_MonthlyArchive (Audit_DeleteBatchID, DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)              
Select @BatchID as Audit_DeleteBatchID, GetDate() as DeleteDate, 'EventLog_jn - Non Respondent Records' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast           
   
              
                
                
--Now after all deletes go ahead and set all triggers back on                 
                
exec sp_ChangeAllTriggerStatus 'Enable'                
Print 'All Triggers Enabled'                
                
IF OBJECT_ID('tempdb..#Resp') IS NOT NULL                 
 Drop table #Resp                
                
end 