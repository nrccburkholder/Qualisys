/************************************************************************************
	sp_WorkPerformed_WorkPerformedCurrent - This stored procedure will produce sampling 
			stats which are added to a recordset with numbers used to produce Work 
			Performed reports in reporting service.  This SP is called from the 
			SP named wp_WorkPerformedYTD on NRC32 in the Accounting Database.

	June 20 2005 DC  Initial Creation

*************************************************************************************/

CREATE Procedure sp_WorkPerformed_WorkPerformedCurrent

as
set transaction isolation level read uncommitted

select projectnumber, 
	ps.survey_id,
	ps.strSurvey_nm,
	mf.month, 
	ps.year,
	case mf.monthweek
		when 'W' then 'Weekly'
		when 'M' then 'Monthly'
		when 'B' then 'BiMonthly'
		when 'D' then 'Daily'
	end as mailFreq,
	intSampled,
	ProjectedSamples,
	coalesce(ActualSamples,0) as ActualSamples
from (select wc.surveyID as survey_id, 
			rtrim(strsurvey_nm)+' (' + rtrim(convert(varchar,sd.survey_ID))+')' as strsurvey_nm, 
			client, 
			year(sampledate) as year,
			month(sampledate) as month,
			wc.projectNumber, 
			sum(convert(int,Sampled)) as intSampled, 
			count(*) as ActualSamples
		from TeamStatus_WorkCompleted wc, survey_def sd
		where year(sampledate)>=year(getdate())-2 and
			dummy_step=1 and
			wc.surveyID=sd.survey_id
		group by wc.surveyID, 
			rtrim(strsurvey_nm)+' (' + rtrim(convert(varchar,sd.survey_ID))+')', 
			client,
			year(sampledate), 
			month(sampledate),
			wc.projectNumber) ps 
	LEFT JOIN
	--Get the most recent mailing freq for each survey for each month
	(select ps.survey_id, monthweek, ProjectedSamples, year, month
		from perioddef ps, 
			(select survey_id,
				year, 
				month, 
				max(pd.perioddef_id) as perioddef_id, 
				sum(case
						when samplenumber<=intexpectedsamples then 1
						else 0	
					end) as ProjectedSamples
				from perioddef p, (
						select perioddef_id, samplenumber, year(datscheduledSample_dt) as year,
							month(datscheduledSample_dt) as month
						from perioddates 
						where year(datscheduledSample_dt)>=year(getdate())-2) pd
				where p.perioddef_id=pd.perioddef_id 
				group by survey_id, year, month) m
		where ps.perioddef_id=m.perioddef_id) mf 
	on mf.survey_id=ps.survey_id and
		mf.month=ps.month and
		mf.year=ps.year
--where ActualSamples<>ProjectedSamples 
order by projectNumber, ps.survey_id


