CREATE procedure qp_rep_SampleFreq_by_Day
@StartDate datetime, @EndDate datetime
as
set transaction isolation level read uncommitted
create table #jcamp_SampleReportDay (AccountDirector varchar(20), Day varchar(10), Samples int)

insert into #jcamp_samplereportday (AccountDirector, Day, Samples)
select 'Overall', case datepart(weekday,datsamplecreate_dt) 
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thursday'
		when 6 then 'Friday'
		when 7 then 'Saturday'
	end
as Day, count(*) as 'Samples'
from sampleset
where datsamplecreate_dt between @StartDate and @EndDate
group by datepart(weekday,datsamplecreate_dt)
order by datepart(weekday,datsamplecreate_dt)

insert into #jcamp_samplereportday (AccountDirector,Day,Samples)
select stremployee_first_nm + ' ' + stremployee_last_nm as 'Account Director', case datepart(weekday,datsamplecreate_dt) 
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thursday'
		when 6 then 'Friday'
		when 7 then 'Saturday'
	end
as Day, count(*) as 'Samples'
from sampleset ss, survey_def sd, study s, employee e
where datsamplecreate_dt between @StartDate and @EndDate
and ss.survey_id = sd.survey_id
and sd.study_id = s.study_id
and s.ADEMPLOYEE_ID = e.employee_id
group by stremployee_first_nm + ' ' + stremployee_last_nm, datepart(weekday,datsamplecreate_dt)
order by stremployee_first_nm + ' ' + stremployee_last_nm, datepart(weekday,datsamplecreate_dt)

select * from #jcamp_samplereportday

drop table #jcamp_SampleReportDay 

set transaction isolation level read committed


