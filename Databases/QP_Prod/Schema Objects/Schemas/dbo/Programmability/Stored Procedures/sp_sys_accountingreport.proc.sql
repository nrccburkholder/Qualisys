create procedure sp_sys_accountingreport
as
declare @firstdate datetime, @lastdate datetime
set @firstdate = (dateadd(day,-1,getdate()))
set @lastdate = (getdate())

create table #status
(Project varchar(4), Returns int, Ignored int)

insert into #status
select left(strsurvey_nm,4), 
	count(*), 0
from questionform qf, survey_def sd
where qf.survey_id = sd.survey_id
and datreturned is not null
and dateadd(day,-1,datreturned) <= @lastdate
and datreturned >= @firstdate
group by left(strsurvey_nm,4)
order by left(strsurvey_nm,4)
--compute sum(count(*))

select left(strsurvey_nm,4) as project, 
	count(*) as ignored
into #status2
from questionform qf, survey_def sd
where qf.survey_id = sd.survey_id
and datreturned is null
and dateadd(day,-1,datunusedreturn) <= @lastdate
and datunusedreturn >= @firstdate
group by left(strsurvey_nm,4)
order by left(strsurvey_nm,4)

update s 
set s.ignored = s2.ignored
from #status s, #status2 s2
where s.project = s2.project

print 'This report is for the date of: ' + convert(varchar(10),@firstdate,120)
print ''

select * from #status
compute sum(returns)
compute sum(ignored)
drop table #status
drop table #status2


