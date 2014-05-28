CREATE PROCEDURE SP_DBA_Trinity_FieldCheck @fieldlist varchar(200)
AS
set nocount on
declare @strsql varchar(3000), @strfield varchar(42)

create table #field (field_id int, strfield_nm varchar(42), added bit)
create table #display (study_id int)


set @strsql = 'insert into #field ' +
	' select field_id, strfield_nm, 0 ' +
	' from metafield where field_id in (' + @fieldlist + ')'

exec (@strsql)

set @strsql = 'alter table #display add dummyfield bit'

while (select count(*) from #field where added = 0) > 0
begin

set @strfield = (select top 1 strfield_nm from #field where added = 0)

update #field set added = 1 where strfield_nm = @strfield

set @strsql = @strsql + ', ' + @strfield + ' varchar(20) '

end

exec (@strsql)

insert into #display (study_id)
select study_id from study where client_id = 253

while (select count(*) from #field) > 0
begin

set @strfield = (select top 1 strfield_nm from #field)

delete #field where strfield_nm = @strfield

set @strsql = 'update d ' +
	' set ' + @strfield + ' = strtable_nm ' +
	' from metadata_view m, #display d ' +
	' where m.study_id = d.study_id ' +
	' and m.strfield_nm = ''' + @strfield + ''''

exec (@strsql)

end

alter table #display drop column dummyfield

select * from #display order by 1

drop table #field
drop table #display


