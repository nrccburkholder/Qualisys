CREATE procedure sp_DBA_RebuildIndex1  
as  
  
declare @table_name varchar(255), @sqlstr varchar(255)  
declare table_cursor cursor for  
   select distinct db_name() + '.' + ltrim(rtrim(schema_name(so.schema_Id))) + '.' + ltrim(rtrim(so.name))     
   from sys.objects so
   where so.type = 'U'
   and so.name like 'unikeys'  
   order by db_name() + '.' + ltrim(rtrim(schema_name(so.schema_Id))) + '.' + ltrim(rtrim(so.name))     
  
  
open table_cursor  
fetch next from table_cursor into @table_name  
  
while @@fetch_status = 0  
begin  
   print getdate()  
   print @table_name  
   set @sqlstr = 'dbcc dbreindex(''' + @table_name + ''') with no_infomsgs'  
   exec (@sqlstr)  
   print getdate()  
   fetch next from table_cursor into @table_name  
end  
  
close table_cursor  
deallocate table_cursor


