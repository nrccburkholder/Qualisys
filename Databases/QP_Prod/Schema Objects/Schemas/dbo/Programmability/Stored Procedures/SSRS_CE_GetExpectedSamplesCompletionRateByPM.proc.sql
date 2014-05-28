--exec SSRS_CE_GetExpectedSamplesCompletionRateByPM '3/23/2008','3/29/2008'
CREATE procedure [dbo].[SSRS_CE_GetExpectedSamplesCompletionRateByPM] 
	@mindate datetime,
	@maxdate datetime
as

/* For Testing
/***/declare @mindate datetime,@maxdate datetime
/***/set @mindate='3/1/2008'
/***/set @maxdate='3/31/2008'
*/

--compensate for SQL thinking '2/29/2008' is '2/29/2008 00:00:00.000', since that's how it gets passed from SSRS
set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))

--create temp table for the samples
create table #samples
	(survey_id int,PeriodDefSampleNumber int,sampleset_id int,datscheduledsample_dt datetime, datsamplecreate_dt datetime
			primary key clustered (PeriodDefSampleNumber))
	create nonclustered index idx_clustered_surveyid on #samples (survey_id)

--insert into samples the samples applicable to the report
insert #samples (survey_id,PeriodDefSampleNumber,sampleset_id,datscheduledsample_dt,datsamplecreate_dt)
select	p.survey_id,
		convert(int,convert(varchar,pd.perioddef_id)+convert(varchar,pd.samplenumber)) [PeriodDefSampleNumber],
		pd.sampleset_id,pd.datScheduledSample_dt,pd.datSampleCreate_dt
from perioddef p (nolock)  
	left outer join perioddates pd (nolock)  
		on (p.perioddef_id=pd.perioddef_id)
where pd.datscheduledsample_dt between @mindate and @maxdate  


--compute the expected sample, conducted samples, and a percentage of those two measures
select	e.stremployee_first_nm+' '+e.stremployee_last_nm [PM],e.employee_id,
		sum(case when s.perioddefsamplenumber is not null then 1 else 0 end) [Expected],
		sum(case when s.sampleset_id is not null then 1 else 0 end) [Completed],
		convert(decimal,sum(case when s.sampleset_id is not null then 1 else 0 end))/
		convert(decimal,sum(case when s.perioddefsamplenumber is not null then 1 else 0 end)) [Pct Completed]	    
from #samples s
	inner join survey_def sd
		on (s.survey_id=sd.survey_id)
	inner join study st
		on (sd.study_id=st.study_id)
	inner join employee e
		on (st.ademployee_id=e.employee_id)
where e.employee_id not in (select employee_id from lu_ssrs_excludedemployees)
group by e.stremployee_first_nm+' '+e.stremployee_last_nm,e.employee_id
order by e.stremployee_first_nm+' '+e.stremployee_last_nm


--cleanup
drop table #samples


