CREATE PROCEDURE QP_Rep_RollbackLithoRange @Associate VARCHAR(42), @Client VARCHAR(42), @Study VARCHAR(42), @Survey VARCHAR(42), @RollbackDate DATETIME
AS

DECLARE @rb INT, @survey_id INT

-- Get the survey_id
SELECT @survey_id = survey_Id FROM ClientStudySurvey_View WHERE strClient_nm = @Client AND strStudy_nm = @Study And strSurvey_nm = @survey

-- Get rollback id from log
SELECT @rb = rollback_id FROM Generation_Rollbacks (NOLOCK) WHERE datRollback_Start BETWEEN @rollbackdate AND DATEADD(dd,1,@rollbackdate) AND survey_id = @survey_id

-- Get LithoRange for rollback id
SELECT css.strClient_nm, css.strStudy_nm, css.strSurvey_Nm, ms.strMailingStep_nm, GR.DatRollback_Start RollbackDate, MIN(STRLITHOCODE) + ' - ' + max(STRLITHOCODE) LithoRange,
MAX(CONVERT(INT,STRLITHOCODE))  - MIN(CONVERT(INT,STRLITHOCODE)) +1 AS RollbackCnt
FROM Generation_Rollbacks gr (NOLOCK), ROLLBACK_SENTMAILING rsm (NOLOCK), Rollback_ScheduledMailing rsc (NOLOCK), mailingstep ms (NOLOCK), clientstudysurvey_view css 
WHERE gr.rollback_id = rsm.rollback_id AND rsm.sentmail_id = rsc.sentmail_id and rsc.mailingstep_id = ms.mailingstep_id 
AND gr.survey_id = css.survey_id AND gr.rollback_id = @rb 
AND gr.rollback_id >= 34 /*(Effetive date of report capability relative to all rollbacks)*/
GROUP BY css.strClient_nm, css.strStudy_nm, css.strSurvey_Nm, ms.strMailingStep_nm, GR.DatRollback_Start


