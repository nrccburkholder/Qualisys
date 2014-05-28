CREATE procedure QP_Rep_SampleSetPeriod 
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50)
AS
--select @Associate='Dgilsdorf', @Client='Cleveland Clinic Health System', @Study='CCF', @Survey='6957CCF'

set transaction isolation level read uncommitted

Declare @intSurvey_id int, @intSamplePlan_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

create table #Sampleset (sampleset_id int, strAssociate varchar(50), strWhat varchar(15), datDate datetime, datFrom datetime, datTo datetime)

insert into #sampleset (sampleset_id, strAssociate, strWhat, datDate, datFrom, datTo)
select sampleset_id, rtrim(strEmployee_first_nm) + ' ' + rtrim(strEmployee_last_nm), case when tiOversample_flag=1 then 'Oversample' else 'Sample' end, datSampleCreate_dt, datDateRange_FromDate, datDateRange_ToDate
from sampleset ss, employee e
where ss.employee_id=e.employee_id
and survey_id=@intSurvey_id

insert into #sampleset (sampleset_id, strAssociate, strWhat, datDate)
select Period_id, rtrim(strEmployee_first_nm) + ' ' + rtrim(strEmployee_last_nm), 'New Period', datPeriodDate
from period p, employee e
where p.employee_id=e.employee_id
and survey_id=@intSurvey_id


select datDate as [Date], strWhat as [Step], strAssociate as [Associate], datFrom as [Sampled From], datTo as [Sampled To] 
from #sampleset 
order by datDate desc

drop table #sampleset


