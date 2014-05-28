create procedure SP_DBM_UniKeys_CleanUp @number int
as

declare @sql varchar(2000)

create table #ss (sampleset_id int, study_id int)

set @sql = ' insert into #ss select top ' + convert(varchar,@number) + ' sampleset_id, sd.study_id ' + char(10) +
	' from sampleset ss, survey_def sd, study s ' + char(10) +
	' where ss.survey_id = sd.survey_id ' + char(10) +
	' and ss.tiunikeysdeled is null ' + char(10) +
	' and ss.datlastmailed is not null ' + char(10) +
	' and sd.study_id = s.study_id ' + char(10) +
	' and s.datarchived is null ' + char(10) +
	' order by sampleset_id ' 

exec (@sql)

declare @study_id int, @sampleset_id int, @strsql varchar(2000)

create table #sp (sampleset_id int, pop_id int)

while (select count(*) from #ss) > 0
begin --Loop 1

begin transaction

truncate table #sp

set @sampleset_id = (select top 1 sampleset_id from #ss)
print 'the current sampleset_id = '+convert(varchar,@sampleset_id)
set @study_id = (select study_id from #ss where sampleset_id = @sampleset_id)
print 'the current study_id = '+convert(varchar,@study_id)
print @sampleset_id

insert into #sp
select sampleset_id, pop_id
from samplepop 
where sampleset_id = @sampleset_id

print '@strsql string execution'

set @strsql = 'delete u ' + char(10) +
	' from s' + convert(varchar,@study_id) + '.unikeys u left outer join #sp s ' + char(10) +
	' on u.sampleset_id = s.sampleset_id ' + char(10) +
	' and u.pop_id = s.pop_id ' + char(10) +
	' where s.pop_id is null ' + char(10) +
	' and u.sampleset_id = ' + convert(varchar,@sampleset_id) 

exec (@strsql)

update sampleset set tiunikeysdeled = 1 where sampleset_id = @sampleset_id

if @@error <> 0
begin --Loop 2
  rollback transaction
  goto finished
end --Loop 2

delete #ss where sampleset_id = @sampleset_id

if @@error <> 0
begin --Loop 2
  rollback transaction
  goto finished
end --Loop 2

commit transaction

finished:

end --Loop 1

drop table #ss
drop table #sp


