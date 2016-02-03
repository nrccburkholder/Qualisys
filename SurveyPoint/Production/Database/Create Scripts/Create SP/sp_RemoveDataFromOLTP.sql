/*      
MWB 11/12/2007      
This procedure runs once a month and removes data from the four largest tables (and there corisponding journal tables)      
By default 18 months of previous journal entries are kept and only respondents that have had a journal entry in the last      
18 months are eligible for deletion.      
For all other EventLog records @EventLogMonthsToKeep is sent in to remove all system events with a date older than    
These defaults can be changed to shorten the time once the data is gone from the OLTP system it is gone.       
All data is still in the archive system (Samson as of now)      
      
NOTE: @NonRespEventIDsToKeep  and @EventLogMonthsToKeep must be a negative number       
   b/c I am using the dateAdd function to get a stopping point.        
   If you use a positve number it will never delete any records      
      
*/      
CREATE procedure sp_RemoveDataFromOLTP       
(      
@EventLogMonthsToKeep int = -18, @NonRespEventIDsToKeep int = -18    
)      
as      
      
Begin      
    
declare @RecCount int    
      
--first thing is to disable all triggers so our Deletes in the live tables are not carried over to the Archive system.      
--We only want to remove data from the OLTP system not the reporting seerer.      
exec sp_ChangeAllTriggerStatus 'Disable'      
print 'All triggers disabled'      
      
--now get list of respondentIDs that have not had an entry in the eventlog since the specified number of months      
select RespondentID, max(EventDate) as MaxEventDate      
into #Resp      
from eventlog      
group by RespondentID      
having max(EventDate) < dateadd(month,@EventLogMonthsToKeep,getdate())      
order by max(EventDate)      
set @RecCount = @@RowCount      
print 'Number of RespondentIDs found in Eventlog with a date older than ' + cast(dateadd(month,@EventLogMonthsToKeep,getdate()) as varchar(35)) + ' is ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'Number of Distinct RespondentIDs Found' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
    
    
--JOURNAL TABLES    
delete E     
from Respondentproperties_jn E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'RespondentProperties_jn Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'RespondentProperties_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
     
      
delete E     
from EventLog_jn E, #resp r      
where r.respondentID = e.respondentID    
set @RecCount = @@RowCount      
print 'EventLog_jn Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'EventLog_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
      
delete E     
from Responses_jn E, #resp r      
where r.respondentID = e.respondentID    
set @RecCount = @@RowCount      
print 'Responses_jn Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'Responses_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
      
delete E     
from respondents_jn E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'respondents_jn Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'respondents_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
      
delete E     
from RespondentRiskScores_jn E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'RespondentRiskScores_jn Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'RespondentRiskScores_jn' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
      
  
Backup Log QMS with truncate_only  
dbcc shrinkfile (13, 100)  
    
--TRANSACTIONAL LIVE TABLES --    
      
delete E     
from Respondentproperties E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'Respondentproperties Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'Respondentproperties' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
      
      
delete E     
from EventLog E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'EventLog Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'EventLog' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
      
delete E     
from Responses E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'Responses Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'Responses' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
    
delete E     
from RespondentRiskScores E, #resp r      
where r.respondentID = e.respondentID     
set @RecCount = @@RowCount     
print 'RespondentRiskScores Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'RespondentRiskScores' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
    
delete E     
from SeniorHealthScores E, #resp r      
where r.respondentID = e.respondentID     
set @RecCount = @@RowCount     
print 'SeniorHealthScores Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'SeniorHealthScores' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
    
delete E     
from TELEMATCHOUT E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'TELEMATCHOUT Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'TELEMATCHOUT' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
    
    
delete E     
from respondents E, #resp r      
where r.respondentID = e.respondentID      
set @RecCount = @@RowCount    
print 'respondents Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'respondents' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
  
Backup Log QMS with truncate_only  
dbcc shrinkfile (13, 100)  
      
    
delete E     
from EventLog E    
where RespondentID is null and (EventTypeID in (1,2,6) or eventTypeID is null) and EventDate < dateadd(month,-36,getdate())     
set @RecCount = @@RowCount    
print 'EventLog - Non Respondent Records Deleted: ' + cast(@RecCount as varchar(10))      
insert into Audit_MonthlyArchive (DeleteDate, Tablename, RowsDeleted,RespondentIDMonthsPast,NonRespondentEventLogPast)    
Select GetDate() as DeleteDate, 'EventLog - Non Respondent Records' as TableName, @RecCount as RowsDeleted,@EventLogMonthsToKeep as RespondentIDMonthsPast, @NonRespEventIDsToKeep as NonRespondentEventLogPast    
    
      
      
--Now after all deletes go ahead and set all triggers back on       
      
exec sp_ChangeAllTriggerStatus 'Enable'      
Print 'All Triggers Enabled'      
      
IF OBJECT_ID('tempdb..#Resp') IS NOT NULL       
 Drop table #Resp      
      
end 