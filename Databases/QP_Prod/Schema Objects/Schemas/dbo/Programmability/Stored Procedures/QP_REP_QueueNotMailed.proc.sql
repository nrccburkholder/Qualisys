CREATE PROCEDURE [dbo].[QP_REP_QueueNotMailed] @associate VARCHAR(50)
AS

SELECT c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.survey_id,  sm.datBundled, pc.strPaperConfig_nm, sm.PaperConfig_id, COUNT(DISTINCT Sentmail_id) NotMailedCount
FROM NPSentMailing sm (NOLOCK), MailingMethodology mm (NOLOCK), Client c (NOLOCK), Study s (NOLOCK), Survey_Def sd (NOLOCK), PaperConfig pc (NOLOCK)
WHERE sm.methodology_id = mm.methodology_id and mm.survey_id = sd.survey_id and sd.study_id = s.study_id and s.client_id = c.client_id AND sm.PaperConfig_id = pc.PaperConfig_id 
AND datMailed = '4000-01-01 00:00:00.000' AND mm.bitActiveMethodology=1
GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.survey_id,  sm.datBundled, pc.strPaperConfig_nm, sm.PaperConfig_id


