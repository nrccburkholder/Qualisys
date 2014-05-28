create procedure SP_JCamp_SamplingReport
as

set nocount on

select sampleset_id
into #SampleSetsMailed
from mailingstep ms, sentmailing sm, samplepop sp, scheduledmailing schm
where sp.samplepop_id = schm.samplepop_id
and schm.sentmail_id = sm.sentmail_id
and datepart(year,sm.datmailed) = datepart(year,getdate())
and schm.mailingstep_id = ms.mailingstep_id
and ms.intsequence = 1
group by sampleset_id

create table #SampleReport (Start_dt datetime, AD varchar(25),Client varchar(40),Study varchar(10),Survey varchar(10),Frequency varchar(10),Samples int,YTD int,Expected int,Status int)
insert into #SampleReport (Start_dt,AD,Client,Study,Survey,Frequency,Samples,YTD)
select case when datepart(year,sd.datsurvey_start_dt)<datepart(year,getdate()) then '1/1/'+convert(varchar,datepart(year,getdate())) else sd.datsurvey_start_dt end as 'Start_dt',e.stremployee_first_nm + ' ' + stremployee_last_nm as 'AD', c.strclient_nm as Client, s.strstudy_nm as Study, sd.strsurvey_nm as Survey, strmailfreq as Frequency,-- datepart(week,getdate()) as 'Week #',
 case when sd.strmailfreq='Weekly' then (select count(*) from sampleset ss, #samplesetsmailed ssm
					where survey_id = sd.survey_id
					and datepart(week,datsamplecreate_dt) = datepart(week,getdate())
					and datepart(year,datsamplecreate_dt) = datepart(year,getdate())
					and ss.tioversample_flag = 0
					and ss.sampleset_id = ssm.sampleset_id)
      when sd.strmailfreq='Monthly' then (select count(*) from sampleset ss, #samplesetsmailed ssm
					 where survey_id = sd.survey_id
					 and datepart(month,datsamplecreate_dt) = datepart(month,getdate())
					 and datepart(year,datsamplecreate_dt) = datepart(year,getdate())
					 and ss.tioversample_flag = 0
					 and ss.sampleset_id = ssm.sampleset_id)
      when sd.strmailfreq='Quarterly' then (select count(*) from sampleset ss, #samplesetsmailed ssm
					   where survey_id = sd.survey_id
					   and datepart(quarter,datsamplecreate_dt) = datepart(quarter,getdate())
					   and datepart(year,datsamplecreate_dt) = datepart(year,getdate())
 					   and ss.tioversample_flag = 0
					   and ss.sampleset_id = ssm.sampleset_id)
      when sd.strmailfreq='Bi-Weekly' then (select count(*) from sampleset ss, #samplesetsmailed ssm
					   where survey_id = sd.survey_id
					   and datepart(month,datsamplecreate_dt) = datepart(month,getdate())
					   and datepart(year,datsamplecreate_dt) = datepart(year,getdate())
					   and ss.tioversample_flag = 0
					   and ss.sampleset_id = ssm.sampleset_id)
 end as 'Samples',
(select count(*) from sampleset ss, #samplesetsmailed ssm
where survey_id = sd.survey_id
and datepart(year,datsamplecreate_dt) = datepart(year,getdate())
and ss.sampleset_id = ssm.sampleset_id) as 'YTD'
from survey_def sd, study s, client c, employee e
where (sd.DATSURVEY_END_DT > getdate() or (select datediff(month,max(datperioddate),getdate()) from period where survey_id = sd.survey_id) < 6)
and strmailfreq <> 'Other'
and strmailfreq <> ''
and strmailfreq <> 'Once'
and sd.study_id = s.study_id
and s.client_id = c.client_id
and s.ADEMPLOYEE_ID = e.employee_id
order by e.stremployee_first_nm + ' ' + stremployee_last_nm, c.strclient_nm, s.strstudy_nm, sd.strsurvey_nm

update #SampleReport
set expected = case when frequency = 'Weekly' then datediff(week,start_dt,getdate())+1 
		    when frequency = 'Bi-Weekly' then (datediff(month,start_dt,getdate())+1)*2
		    when frequency = 'Monthly' then datediff(month,start_dt,getdate())+1
		    when frequency = 'Quarterly' then datediff(quarter,start_dt,getdate())+1
	       end
update #SampleReport set status = ytd-expected

print 'W-M-Q-Year'
print '------------'
print convert(varchar(2),datepart(week,getdate()))+'-'+convert(varchar(2),datepart(month,getdate()))+'-'+convert(varchar(1),datepart(quarter,getdate()))+'-'+convert(varchar(4),datepart(year,getdate()))
print ''
print 'Current Mailing Step'
print ''
select Frequency +'('+ convert(varchar(3),count(*))+')' as 'Survey Frequency', sum(case when samples > 0 then 1 else 0 end) as Sampled, sum(case when samples > 0 then 0 else 1 end) as 'Not Sampled'
from #SampleReport
group by Frequency
print ''
print 'YTD Status'
print ''
select Frequency +'('+ convert(varchar(3),count(*))+')' as 'Survey Frequency', sum(case when Status < 0 then 1 else 0 end) as 'Behind', sum(case when Status = 0 then 1 else 0 end) as 'On Time', sum(case when Status > 0 then 1 else 0 end) as 'Ahead'
from #SampleReport
group by frequency
print ''
print 'Current Mailing Step - by Survey'
print ''
select AD,Client,Study,Survey,Frequency,Samples,YTD,Expected,Status from #SampleReport


drop table #samplereport
drop table #samplesetsmailed

/*




*/


