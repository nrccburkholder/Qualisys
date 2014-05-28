CREATE PROCEDURE [dbo].[SP_dbm_block]       
 @time int      
AS      
      
declare @date datetime, @mindate datetime      
set @date = getdate()      
select @mindate = min(dat) from block      
    
    
      
insert into block (spid, blocked, dat)       
select spid, blocked, @date      
from master.dbo.sysprocesses      
where blocked > 0      
      
select spid into #new       
from block where dat = @date      
      
update block set currentdate = @date      
      
create table #spid (spid int, hostname varchar(42), command varchar(600))      
      
insert into #spid (spid)       
select distinct spid       
from block       
where datediff(mi,dat,currentdate) >= @time      
      
update ts set ts.hostname = sp.hostname--, ts.command = sp.command      
from #spid ts, master.dbo.sysprocesses sp      
where ts.spid = sp.spid      
      
delete block where spid not in (select spid from #new)    
      
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
declare @vsubject nvarchar(255)
exec qp_prod.dbo.sp_getemailsubject 'Blocked Users',@country, @environment, 'Qualisys', @osubject=@vsubject output

if  (select count(*) from block where datediff(mi,dat,@date) > @time) > 0      
 -- exec master.dbo.xp_sendmail @recipients = 'IT-DBATeam@nationalresearch.com;msphone@nrcpicker.com',  --4024731136@atsbeep.com    
 --@subject = 'Blocked Users'--,      
-- @dbuse = 'QP_Prod',      
-- @query = 'select * from block',      
-- @width = 160,      
-- @attach_results = 'true'      
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',  
@recipients='itsoftwareengineeringlincoln@nationalresearch.com',  
@subject=@vsubject,  
@body='Blocked Users',  
@body_format='Text',  
@importance='High'  
  
  DELETE FROM block WHERE DATEDIFF(mi,dat,@date) > @time      
      
DROP TABLE #spid      
DROP TABLE #new


