CREATE procedure sp_DBA_RebuildIndex
as

declare @table_name varchar(255), @sqlstr varchar(255)
declare table_cursor cursor for
   select distinct db_name() + '.' + ltrim(rtrim(su.name)) + '.' + ltrim(rtrim(so.name)) 
   from sysobjects so, sysusers su, sysindexes si
   where so.uid = su.uid
   and so.type = 'U'
   and so.id = si.id
   and so.uid = 1
   and so.name not like 'old%'
   and so.name not like 'NRCNorms%'
   order by db_name() + '.' + ltrim(rtrim(su.name)) + '.' + ltrim(rtrim(so.name))

open table_cursor
fetch next from table_cursor into @table_name

while @@fetch_status = 0
begin
   print getdate()
   print @table_name
   set @sqlstr = "dbcc dbreindex('" + @table_name + "') with no_infomsgs"
   exec (@sqlstr)
   print getdate()
   fetch next from table_cursor into @table_name
end

close table_cursor
deallocate table_cursor


