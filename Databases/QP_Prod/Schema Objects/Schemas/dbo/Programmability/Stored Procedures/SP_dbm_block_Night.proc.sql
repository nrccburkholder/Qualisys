CREATE PROCEDURE [dbo].[SP_dbm_block_Night]             
 @time int, @indebug tinyint = 0            
AS            
            
declare @date datetime, @mindate datetime            
set @date = getdate()            
select @mindate = min(dat) from block            
          
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
declare @vsubject nvarchar(255)
         
            
insert into block (spid, blocked, dat)             
select spid, blocked, @date            
from master.dbo.sysprocesses            
where blocked > 0            
      
if @indebug = 1 select 'Raw Block Table' [Raw Block Table], * from block      
            
select spid into #new             
from block where dat = @date            
      
if @indebug = 1 select '#new 1' [#new 1], * from #new      
            
update block set currentdate = @date            
            
create table #spid (spid int, hostname varchar(42), command varchar(600))            
            
insert into #spid (spid)             
select distinct spid             
from block             
where datediff(mi,dat,currentdate) >= @time            
      
            
update ts set ts.hostname = sp.hostname--, ts.command = sp.command            
from #spid ts, master.dbo.sysprocesses sp            
where ts.spid = sp.spid            
      
if @indebug = 1 select '#spid 1' [#spid 1], * from #spid      
              
delete block where spid not in (select spid from #new)          
      
if @indebug = 1 select 'block after #new delete' [block after #new delete], * from block      
      
            
if  (select count(*) from block where datediff(mi,dat,@date) > @time) > 0            
BEGIN      
 if @indebug = 1 print 'Blocks Found'      
      
 --first send e-mails notifying of blocks.  If during the day this is all we will do            
exec qp_prod.dbo.sp_getemailsubject 'Blocked Users',@country, @environment, 'Qualisys', @osubject=@vsubject output
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',        
 @recipients='itsoftwareengineeringlincoln@nationalresearch.com',        
 @subject=@vsubject,        
 @body='Blocked Users',        
 @body_format='Text',        
 @importance='High'        
        
 if @indebug = 1 print 'Current Time is: ' + cast(CAST(getdate() as time) as varchar(50))      
      
 if CAST(getdate() as time) > '22:00:00' or CAST(getdate() as time) <  '7:00:00'      
 BEGIN      
       
  if @indebug = 1 print 'Time is in Night range.  Checking for PCLGen Blocks'      
       
  declare @spid int, @dbccSQL varchar(8000), @errBody varchar(500), @errBody2 varchar(6000), @errBodyMsg varchar(8000), @SQLQry varchar(1000)      
  create table #tmpSQL (EventType varchar(50), parameters varchar(50),mySQL varchar(8000))      
       
  while (select COUNT(*) from #new) > 0      
  BEGIN      
   select top 1 @spid = spid from #new      
         
   --create sql to run      
   select @dbccSQL = 'dbcc inputbuffer (' + cast(@spid as varchar(4)) +')'      
         
   --insert results into table      
   insert into #tmpSQL      
   exec (@dbccSQL)      
      
   if @indebug = 1 select '#tmpSQL - show DBCC results' [#tmpSQL - show DBCC results], * from #tmpSQL      
      
         
   if exists (      
    select 'x'       
    from #tmpSQL       
    where mySQL like '%SELECT "SENTMAIL_ID" ,"INTSHEET_NUM" ,"PAPERSIZE_ID" ,"INTPA" ,"INTPB" ,"INTPC" ,"INTPD" ,"PCLSTREAM" ,"BITCOVER"  FROM "dbo"."PCLOUTPUT2"%' or                 
      mySQL like '%NRCPCLGen%'       
      )      
   BEGIN      
          
    select @errBody = 'Blocked Users killed spid ' + cast(@spid as varchar(4)) + ' because it fit the criteria of a blocking pclgen machine'      
    select top 1 @errBody2 = mysql from #tmpSQL       
    Select @errBodyMsg = @errBody + char(13) + @errBody2      
    select @SQLQry = 'Select * from master..sysprocesses where spid = ' + cast(@spid as varchar(4))       
          
    --send e-mail notifying spid has been killed      
	exec qp_prod.dbo.sp_getemailsubject 'Blocked Users - Night Processing Killed spid',@country, @environment, 'Qualisys', @osubject=@vsubject output
	EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',        
    @recipients='itsoftwareengineeringlincoln@nationalresearch.com',        
    @subject=@vsubject,        
    @body=@errBodyMsg,      
    @body_format='Text',        
    @importance='High',        
    @execute_query_database = 'qp_prod',      
    @attach_query_result_as_file = 1,      
    @Query=@SQLQry      
          
    --kill the blocking spid      
    select @dbccSQL = 'Kill ' + cast(@spid as varchar(4))       
    exec (@dbccSQL)      
          
   END      
   ELSE      
   BEGIN      
    --debug code only.  Should only be left in until we catch the offending blocks.      
    select @errBody = 'Blocked Users did not kill spid ' + cast(@spid as varchar(4)) + ' because it did not fit the criteria of a blocking pclgen machine'      
    select top 1 @errBody2 = mysql from #tmpSQL       
    Select @errBodyMsg = @errBody + char(13) + @errBody2      
    select @SQLQry = 'Select * from master..sysprocesses where spid = ' + cast(@spid as varchar(4))       
          
    --send e-mail notifying spid has been killed      
	exec qp_prod.dbo.sp_getemailsubject 'Blocked Users - DID NOT KILL BLOCKED SPID',@country, @environment, 'Qualisys', @osubject=@vsubject output
	EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',        
    @recipients='itsoftwareengineeringlincoln@nationalresearch.com',        
    @subject=@vsubject,        
    @body=@errBodyMsg,      
    @body_format='Text',        
    @importance='High',        
    @execute_query_database = 'qp_prod',      
    @attach_query_result_as_file = 1,      
    @Query=@SQLQry      
      
   END      
        
  Delete from #new where spid = @spid      
  END      
 END      
 ELSE      
 BEGIN      
  if @indebug = 1 print 'not in night time range.  No check was performed.'      
 END      
END       
       
        
        
  DELETE FROM block WHERE DATEDIFF(mi,dat,@date) > @time            
            
DROP TABLE #spid            
DROP TABLE #new


