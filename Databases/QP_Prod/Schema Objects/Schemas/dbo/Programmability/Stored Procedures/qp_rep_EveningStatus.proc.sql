CREATE PROCEDURE qp_rep_EveningStatus  
 @Associate varchar(50)  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
DECLARE @intresult INTEGER  
DECLARE @strresult VARCHAR(10)  
DECLARE @endtime DATETIME  
SET @endtime = GETDATE() + 1  
  
UPDATE ScheduledMailing   
SET datGenerate = DATEADD(DAY,-1,datGenerate)   
WHERE datGenerate BETWEEN GETDATE() AND DATEADD(DAY,1,GETDATE())  
  
PRINT 'This report was created:  ' + CONVERT(VARCHAR(19),GETDATE())  
PRINT ''  
  
PRINT DB_NAME() + ' is available.'  
PRINT ''  
  
CREATE TABLE #queue  
(ident INT identity(1,1),  
 Client_id VARCHAR(6),  
 strClient_Nm VARCHAR(50),  
 Study_id VARCHAR(6),  
 strStudy_nm VARCHAR(10),  
 Survey_id VARCHAR(6),  
 strSurvey_nm VARCHAR(50),  
 strMailingStep_nm VARCHAR(50),  
 SurveyType VARCHAR(50),  
 Total INT,  
 bitFormGenRelease BIT)  
  
INSERT INTO #queue(Client_id, strClient_nm, Study_id, strStudy_nm, Survey_id, strSurvey_nm, strMailingStep_nm, SurveyType, Total, bitFormGenRelease)  
SELECT c.Client_id, strClient_nm, s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, strMailingStep_nm, LEFT(SurveyType_dsc,15), COUNT(*), CONVERT(VARCHAR,bitFormGenRelease)  
FROM   Client C (NOLOCK), Study S (NOLOCK), Survey_def SD (NOLOCK), SamplePop SP (NOLOCK), ScheduledMailing SM (NOLOCK), MailingStep MS (NOLOCK), SurveyType st(NOLOCK)  
WHERE  SP.SamplePop_id = SM.SamplePop_id   
   AND SM.SentMail_id IS NULL   
   AND SM.datGenerate <= GETDATE()  
   AND MS.MailingStep_id = SM.MailingStep_id   
   AND MS.Survey_id = SD.Survey_id   
   AND SD.Study_id = S.Study_id  
   AND S.Client_id = C.Client_id  
   AND SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError  
      WHERE ScheduledMailing_id IS NOT NULL)  
   AND sd.SurveyType_id=st.SurveyType_id  
GROUP BY c.Client_id, strClient_nm, s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, strMailingStep_nm, SurveyType_dsc, bitFormGenRelease  
ORDER BY strClient_nm, strStudy_nm, strSurvey_nm, strMailingStep_nm  
  
--INSERTING THE TOTALS  
INSERT INTO #queue(Client_id, strClient_nm, Study_id, strStudy_nm, Survey_id, strSurvey_nm, strMailingStep_nm,SurveyType, Total, bitFormGenRelease)  
SELECT '','','','','','','','          SUM =',SUM(total),1 FROM #queue WHERE bitFormGenRelease = 1   
  
INSERT INTO #queue(Client_id, strClient_nm, Study_id, strStudy_nm, Survey_id, strSurvey_nm, strMailingStep_nm,SurveyType, Total, bitFormGenRelease)  
SELECT '','','','','','','','          SUM =',SUM(total),0 FROM #queue WHERE bitFormGenRelease = 0  
  
PRINT 'Surveys that will print.'  
SELECT Client_id, strClient_nm, Study_id, strStudy_nm, Survey_id, strSurvey_nm, strMailingStep_nm, SurveyType, Total  
FROM #queue  
WHERE bitFormGenRelease = 1  
ORDER BY ident  
  
PRINT ''  
PRINT 'Surveys that will NOT print because they are not released to FormGen.'  
SELECT Client_id, strClient_nm, Study_id, strStudy_nm, Survey_id, strSurvey_nm, strMailingStep_nm, SurveyType, Total  
FROM #Queue  
WHERE bitFormGenRelease = 0  
ORDER BY ident  
  
PRINT ''  
SET @intresult = (  
 SELECT COUNT(*)  
 FROM PCLNeeded (NOLOCK)  
 WHERE bitdone = 0  
)  
PRINT 'There are already ' + RTRIM(LTRIM(STR(@intresult))) + ' Surveys to be PCLGenerated tonight.'  
  
PRINT 'Generation Parameters:'  
SELECT strParam_nm, numParam_Value   
FROM QualPro_Params  (NOLOCK)  
WHERE strParam_nm LIKE '%time%'   
ORDER BY strParam_nm  
  
SELECT strParam_nm, numParam_Value   
FROM QualPro_Params  (NOLOCK)  
WHERE strParam_nm LIKE '%pause%'   
ORDER BY strParam_nm  
  
DROP TABLE #queue  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


