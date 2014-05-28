CREATE proc sp_sys_PCLGenLimboSurveys
as
select c.strclient_nm, mm.survey_id, st.SurveyType_dsc, ms.strmailingstep_nm, sm.datgenerated, count(*) total
from sentmailing sm inner join MAILINGMETHODOLOGY mm
 on sm.METHODOLOGY_ID = mm.METHODOLOGY_ID
inner join scheduledmailing schm
 on sm.sentmail_id = schm.sentmail_id
inner join survey_def sd
 on mm.survey_id = sd.survey_id
inner join study s
 on sd.study_id = s.study_id
inner join client c
 on s.client_id = c.client_id
inner join mailingstep ms
 on schm.mailingstep_id = ms.mailingstep_id
inner join surveytype st
 on sd.surveytype_id = st.surveytype_id
where sm.DATGENERATED between getdate()-30 and getdate()-1
and sm.datBundled is null
group by c.strclient_nm, mm.survey_id, st.SurveyType_dsc, ms.strmailingstep_nm, sm.datgenerated


