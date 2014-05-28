Create Procedure sp_dba_WhoIsOn
as
Set nocount on

Create table #Connected
(SPID int,
 Status Varchar(140),
 Login varchar(40),
 HostName varchar(40),
 BlkBy varchar(110),
 DBName varchar(140),
 Command varchar(140),
 CPUTime int,
 DiskIO int,
 LastBatch varchar(40),
 ProgramName varchar(140),
 SPID2 int)

insert into #Connected
Execute sp_who2

select Login, HostName, LastBatch
from #Connected
--where HostName in ('dataimport02','dataimport03','dataimport04','dataimport05','dataimport06','dataimport07')

Drop table #Connected


