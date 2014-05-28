CREATE procedure QP_Rep_ExpiredSurveys
@Associate varchar(40), @Client varchar(40), @BeginDate datetime, @EndDate datetime
as

declare @client_id int

select @client_id = client_id
from client where strclient_nm = @client

select sd.survey_id
into #surveys
from survey_def sd, study s
where sd.study_id = s.study_id
and s.client_id = @Client_id

select s.survey_id, sm.strlithocode, qf.datunusedreturn
into #Expired
from #Surveys s, sentmailing sm (nolock), questionform qf (nolock) left outer join (select distinct questionform_id from qp_scan.dbo.bubblepos (nolock)) bp 
on qf.questionform_id = bp.questionform_id
where bp.questionform_id is null
and s.survey_id = qf.survey_id
and sm.sentmail_id = qf.sentmail_id
and qf.datunusedreturn >= @BeginDate
and qf.datunusedreturn < dateadd(day,1,@enddate)
and qf.unusedreturn_id = 2

drop table #surveys

select s.strstudy_nm as Study, s.Study_id, sd.strsurvey_nm as Survey, sd.Survey_id, strlithocode as Litho, convert(char(10),datUnusedReturn,120) as datUnusedReturn
from #expired e, survey_def sd, study s
where e.survey_id = sd.survey_id
and sd.study_id = s.study_id
order by s.strstudy_nm, sd.strsurvey_nm, datunusedreturn, strlithocode

drop table #expired


