CREATE proc Get_DrNPI as

create table tmp_drnpi (
	study varchar(10),
	drnpi varchar(40)
)

declare @study varchar(10)

declare cStudies cursor for
select distinct table_schema 
from INFORMATION_SCHEMA.COLUMNS 
where COLUMN_NAME = 'DrNPI' 
and TABLE_NAME = 'Encounter'

open cStudies
fetch next from cStudies into @study


while @@fetch_status = 0
begin
	print 'working on study ' + @study
	exec ('insert into tmp_drnpi select ''' + @study + ''', drnpi from ' + @study + '.encounter where drnpi is not null')
	fetch next from cStudies into @study
end

close cStudies
deallocate cStudies

select distinct drnpi from tmp_drnpi
--1405122
drop table tmp_drnpi


