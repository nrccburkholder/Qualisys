CREATE PROCEDURE [dbo].[sp_ImpWiz_ReplaceQuotes_old] 
@study_id int

AS

declare @table_nm char(20), @field_nm char(20), @strsql varchar(8000)
declare @dq char(1), @sq char(1)
set @dq = '"'
set @sq = "'"

declare tables cursor for
   select strtable_nm, strfield_nm 
   from metatable mt, metastructure ms, metafield mf
   where mt.study_id = @study_id
   and mt.table_id = ms.table_id
   and ms.field_id = mf.field_id
   and mf.strfielddatatype = 'S'
   and ms.BITPOSTEDFIELD_FLG = 1

open tables
fetch next from tables into @table_nm, @field_nm
while @@fetch_status = 0
begin
   set @strsql = 'update s' + ltrim(rtrim(convert(char(5),@study_id))) + '.' +
      ltrim(rtrim(@table_nm)) + '_load set ' + ltrim(rtrim(@field_nm)) + ' = replace(' +
      ltrim(rtrim(@field_nm)) + ', "' + @sq + '", "`")'
   exec(@strsql)
   set @strsql = "update s" + ltrim(rtrim(convert(char(5),@study_id))) + "." +
      ltrim(rtrim(@table_nm)) + "_load set " + ltrim(rtrim(@field_nm)) + " = replace(" +
      ltrim(rtrim(@field_nm)) + ", '" + @dq + "', '`')"
   exec(@strsql)
   fetch next from tables into @table_nm, @field_nm
end

close tables
deallocate tables


