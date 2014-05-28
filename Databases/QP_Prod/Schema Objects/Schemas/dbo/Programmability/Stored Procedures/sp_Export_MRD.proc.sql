CREATE PROCEDURE sp_Export_MRD 
   @survey_id int,
   @start_dt char(10),
   @end_dt char(10)
AS

declare @study_id int, @sqlstr varchar(8000)
set @study_id = (select study_id from survey_def where survey_id = @survey_id)

--set @sqlstr='Survey_id='+convert(varchar,@Survey_id)+', start_dt='+convert(varchar,@Start_dt)+', end_dt='+convert(varchar,@end_dt)

--exec master.dbo.xp_sendmail @recipients='bdohmen',@subject='sp_Export_MRD',
--	@message=@sqlstr

set @sqlstr = 'select * from s' + ltrim(rtrim(convert(varchar(10),@study_id))) + '.big_view ' +
                     'where populationpop_id in ( ' +
                        'select pop_id from selectedsample ' +
                        'where strunitselecttype = "D" ' +
                        'and study_id = ' + ltrim(rtrim(convert(varchar(10),@study_id))) + ')'
exec(@sqlstr)


/*
declare @study_id int, @table_id int
declare @sqlstr varchar(8000), @table_list varchar(100)
set @study_id = (select study_id from survey_def where survey_id = @survey_id)

declare table_ids cursor for
   select table_id from metatable where study_id = @study_id
open table_ids
fetch next from table_ids into @table_id
while @@fetch_status = 0
begin
   set @table_list = @table_list + ', ' + (select rtrim(strTable_nm) from metatable where table_id = @table_id)
   fetch next from table_ids into @table_id
end
close table_ids
deallocate table_ids

set @sqlstr = 'declare field_ids cursor for select distinct field_id from metastructure where table_id in (' + @table_list + ')'
exec (@sqlstr)

open field_ids
fetch next from field_ids into @field_id
while @@fetch_status = 0
begin
   set @table_id = (select top 1 table_id from metastructure where field_id = @field_id
   set @field_list = @field_list + ', ' + (select rtrim(strtable_nm) from metatable where table_id = @table_id) + '.' 
   set @field_list = @field_list + (select rtrim(strfield_nm from metafield where field_id = @field_id)

*/


