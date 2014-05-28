CREATE proc [dbo].[Load2Live_Compare] 
	@datafile_id int, 
	@strtable_nm varchar(42), 
	@fields varchar(max)
as

declare @study_id int, @fieldlist varchar(max), @sql varchar(max)

/*			TESTING
declare @datafile_id int, @strtable_nm varchar(42), @fields varchar(max)
select @fields = 'mrn,lname,spud'
select @datafile_id = 268313
select @strtable_nm = 'population'
*/

--Get study_id and check that datafile_id exists.
select @study_id = p.study_id
from qloader.qp_load.dbo.package p inner join qloader.qp_load.dbo.datafile df
 on p.package_id = df.package_id
where df.datafile_id = @datafile_id

if @study_id is null
begin
	select 'Datafile_id not found.  Exiting proc...' [Error]
	return
end

--Make sure desired table exists and get match fields.
select strfield_nm into #match_fields from metadata_view where study_ID = @study_id and bitmatchfield_FLG = 1 and strtable_nm = @strtable_nm

if @@ROWCOUNT = 0 
begin
	select 'Your table does not exist for this study.  Exiting proc...' [Error]
	return
end

--List the match fields that were found.
select strfield_nm [Match field(s)] from #match_fields

--Return a count of the records found in the datafile.
select @sql = 'declare @recordsfound int select @recordsfound=count(*) from qloader.qp_load.s'+cast(@study_id as varchar)+'.'+@strtable_nm+'_load where datafile_id = '+cast(@datafile_id as varchar)+' select @recordsfound as [Records found in datafile]'
exec(@sql)

--Put update fields in a temp table, strips spaces, and add surrounding tick marks.
create table #fields (strfield_nm varchar(50))
select @fieldlist = REPLACE(@fields, ' ', '')
select @fieldlist = REPLACE(@fieldlist, ',', ''',''')
exec('insert into #fields select strfield_nm from metafield where strfield_nm in ('''+@fieldlist+''')')

--Make sure that at least some of the passed in update fields exist in the passed in study and table.
select distinct v.strfield_nm into #found_fields from METADATA_VIEW v inner join #fields f on v.strfield_nm = f.strfield_nm where v.study_id = @study_id and v.strtable_nm = @strtable_nm

if @@ROWCOUNT = 0 
begin
	select 'None of your fields were found in this study/table.  Exiting proc...' [Error]
	return
end

select strfield_nm [Fields found] from #found_fields

--Create comparison sql string.
select @sql = 'select el.datafile_id'
select @sql = @sql + ', el.'+strfield_nm+' [LOAD '+strfield_nm+'], e.'+strfield_nm+' [LIVE '+strfield_nm+'], case when el.'+strfield_nm+'=e.'+strfield_nm+' then '''' else ''DIFFERENCE FOUND!'' end ['+strfield_nm+' Discrepancies]' from #found_fields
select @sql = @sql + ' from qloader.qp_load.s'+cast(@study_id as varchar)+'.'+@strtable_nm+'_load el inner join s'+cast(@study_id as varchar)+'.'+@strtable_nm+' e on 1=1'
select @sql = @sql + ' and el.'+strfield_nm+' = e.'+strfield_nm from #match_fields
select @sql = @sql + ' where el.datafile_id = '+cast(@datafile_id as varchar)

--select @sql
exec(@sql) 

--Return number of records found in join.  If this is different than number of rows in datafile (from above), then there may be a problem.
select @@rowcount as [Records found in join]

drop table #fields
drop table #found_fields
drop table #match_fields


