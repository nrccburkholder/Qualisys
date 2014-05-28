CREATE proc Get_NPI as

create table tmp_npi (
	study varchar(10),
	npi varchar(40)
)

declare @study varchar(10)

declare cStudies cursor for
select distinct table_schema 
from INFORMATION_SCHEMA.COLUMNS 
where COLUMN_NAME = 'npi' 
and TABLE_NAME = 'Encounter'

open cStudies
fetch next from cStudies into @study


while @@fetch_status = 0
begin
	print 'working on study ' + @study
	exec ('insert into tmp_npi select ''' + @study + ''', npi from ' + @study + '.encounter where npi is not null and npi <> ''999999999''')
	fetch next from cStudies into @study
end

close cStudies
deallocate cStudies

select distinct npi from tmp_npi
drop table tmp_npi


