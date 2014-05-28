CREATE proc sp_dba_checkDQ
	@study_id int,
	@key_field varchar(50),
	@key_value varchar(50)
as

declare @criteria varchar(200)
declare @sql varchar(1000)


declare cCriteria cursor
for select strcriteriastring
from CRITERIASTMT 
where study_id = @study_id
and strcriteriastmt_nm like 'dq%'

create table tmp_criteria (criteria varchar(200))

print @key_field + ' = ' + @key_value

open cCriteria
fetch next from cCriteria into @criteria

while @@fetch_status = 0
begin
	set @sql = 'insert into tmp_crieria select strcriteriastring
		from s' + cast(@study_id as varchar) + '.big_view 
		where ' + @key_field + ' = ' + @key_value

	fetch next from cCriteria into @criteria
end

close cCriteria
deallocate cCriteria

select * from tmp_criteria

drop table tmp_criteria


