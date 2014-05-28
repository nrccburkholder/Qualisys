CREATE proc myspLock
as
begin
create table #lock (spid int, [dbid] int, [objID] int, IndID int, [type] varchar(10), [resource] varchar(25), Mode varchar(10), [status] varchar(10))
insert into #lock
exec sp_lock


select su.name SchemaName, so.name ObjectName, si.name IndexName, l.* 
from #lock l, sysobjects so, sysusers su, sysindexes si
where	l.objid = so.id and 
		so.uid = su.uid and
		so.id = si.id and
		l.objid = si.id and
		l.indID = si.indID
order by l.type

end


