CREATE PROCEDURE sp_temp_checkbigview 
@study_id char(3)
AS

SET NOCOUNT ON

declare @column varchar(80)

print 'Verifying Study ' + @study_id

select sc.name as mycolumn, space(1) as verified
into #sysview
from syscolumns sc, sysobjects so, sysusers su
where sc.id = so.id
and so.name = 'Big_View'
and so.uid = su.uid
and su.name = 'S'+@study_id

declare columns_cursor cursor for
   select rtrim(mt.strtable_nm) + rtrim(mf.strfield_nm) as column_name
   from metatable mt, metastructure ms, metafield mf
   where mt.study_id = convert(int,@study_id)
   and mt.table_id = ms.table_id
   and ms.field_id = mf.field_id

open columns_cursor
fetch next from columns_cursor into @column

while @@fetch_status =0
begin
   update #sysview set verified = 'Y' where mycolumn = @column
   if @@rowcount = 0
      print 'SysColumns does not contain ' + @column
   fetch next from columns_cursor into @column
end

close columns_cursor
deallocate columns_cursor

if (select count(*) from #sysview where verified is null) > 0 
begin
   print 'MetaData does not contain:'
   select * from #sysview where verified is null
end

drop table #sysview

SET NOCOUNT OFF


