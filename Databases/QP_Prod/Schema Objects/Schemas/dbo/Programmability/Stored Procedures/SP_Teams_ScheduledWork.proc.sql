CREATE PROCEDURE SP_Teams_ScheduledWork
AS
TRUNCATE TABLE teamstatus_scheduledwork

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

INSERT INTO teamstatus_scheduledwork
SELECT c.strClient_nm AS Client, s.strStudy_nm AS Study, SD.Study_id AS StudyID, sd.strsurvey_nm AS Survey, SD.Survey_id AS SurveyID, SP.SampleSet_id AS SampleSet, 
ms.strmailingstep_nm AS MailingStep, MM.strMethodology_nm AS Methodology, sm.datgenerate AS Dategenerate, count(*) AS Cnt
 FROM   Survey_def SD(NOLOCK), SamplePop SP(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK), mailingstep ms(NOLOCK), study s(NOLOCK), client c(NOLOCK)
 WHERE  sd.study_id=s.study_id AND
        s.client_id=c.client_id AND 
        SP.SamplePop_id = SM.SamplePop_id AND
        SM.SentMail_id IS NULL AND
        SM.datGenerate <= DATEADD(DAY,28,GETDATE()) AND
        SD.bitFormGenRelease = 1 AND
        MM.Methodology_id = SM.Methodology_id AND
        MM.Survey_id = SD.Survey_id and
        sm.mailingstep_id=ms.mailingstep_id
 GROUP BY c.strClient_nm, s.strStudy_nm, sd.strsurvey_nm, SD.Study_id, SD.Survey_id, SP.SampleSet_id, ms.strmailingstep_nm, MM.strMethodology_nm, sm.datgenerate
 ORDER BY sm.datgenerate


