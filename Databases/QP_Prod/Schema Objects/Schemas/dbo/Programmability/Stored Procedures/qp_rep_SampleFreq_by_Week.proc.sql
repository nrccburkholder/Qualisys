CREATE procedure qp_rep_SampleFreq_by_Week
@StartDate datetime, @EndDate datetime
as
set transaction isolation level read uncommitted
create table #jcamp_SampleReportWeek (AccountDirector varchar(20), Week int, Samples int)

insert into #jcamp_samplereportweek (AccountDirector,Week,Samples)
select 'Overall',datepart(week,datsamplecreate_dt) as Week, count(*) as 'Samples'
from sampleset
where datsamplecreate_dt between @StartDate and @EndDate
group by datepart(week,datsamplecreate_dt)
order by datepart(week,datsamplecreate_dt)

insert into #jcamp_samplereportweek (AccountDirector,Week,Samples)
select stremployee_first_nm + ' ' + stremployee_last_nm as 'Account Director', datepart(week,datsamplecreate_dt) as Week, count(*) as 'Samples'
from sampleset ss, survey_def sd, study s, employee e
where datsamplecreate_dt between @StartDate and @EndDate
and ss.survey_id = sd.survey_id
and sd.study_id = s.study_id
and s.ADEMPLOYEE_ID = e.employee_id
group by stremployee_first_nm + ' ' + stremployee_last_nm, datepart(week,datsamplecreate_dt)
order by stremployee_first_nm + ' ' + stremployee_last_nm, datepart(week,datsamplecreate_dt)

select * from #jcamp_samplereportweek

drop table #jcamp_samplereportweek

set transaction isolation level read committed


