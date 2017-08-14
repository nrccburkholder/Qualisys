/*
	RTP-3590 Report Records TOCLd During Generation.sql

	Lanny Boswell

	ALTER PROCEDURE [dbo].[sp_sys_MorningStatus1]

*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_sys_MorningStatus1] AS  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
DECLARE @starttime DATETIME  
DECLARE @endtime DATETIME  
SELECT @starttime=(CONVERT(VARCHAR(10),GETDATE()-1,120)) + ' 6:00'  
SELECT @endtime=(CONVERT(VARCHAR(10),GETDATE(),120)) + ' 6:00'  
  
PRINT '*************************************************************************************'  
PRINT 'Questionnaires not FormGen''ed'  
SELECT strClient_nm AS Client, strSurvey_nm AS Survey, sd.Survey_id AS Survey_ID,   
       strMailingStep_nm AS MailingStep, LEFT(SurveyType_dsc,15) SurveyType, COUNT(*) total  
INTO #notfgend  
 FROM ScheduledMailing schm, MailingStep ms, Survey_def sd, Study s, Client c, SurveyType st  
 WHERE CONVERT(VARCHAR(10),datGenerate,120) <= DATEADD(d,-1,GETDATE())  
  AND schm.MailingStep_id = ms.MailingStep_id  
  AND ms.Survey_id = sd.Survey_id  
  AND schm.SentMail_id is null  
  AND bitFormGenRelease = 1  
  AND sd.Study_id = s.Study_id  
  AND s.Client_id = c.Client_id  
  AND schm.ScheduledMailing_id not in (SELECT ScheduledMailing_id FROM FormGenError)  
  AND sd.SurveyType_id=st.SurveyType_id  
 GROUP BY strClient_nm, strSurvey_nm, sd.Survey_id, strMailingStep_nm, LEFT(SurveyType_dsc,15)   
 ORDER BY strClient_nm, strSurvey_nm, sd.Survey_id, strMailingStep_nm  
   
PRINT ''  
PRINT '*************************************************************************************'  
PRINT 'Number of Questionnaires in PCLNeeded per Survey'  
PRINT ''  
SELECT strClient_nm AS Client, c.Client_id, strStudy_nm AS Study, s.Study_id,   
       strSurvey_nm AS Survey, sd.Survey_id, LEFT(SurveyType_dsc,15) SurveyType, COUNT(*) AS cnt  
FROM PCLNeeded p, Survey_def sd, Study s, Client c, SurveyType st  
WHERE p.Survey_id = sd.Survey_id  
AND sd.Study_id = s.Study_id  
AND s.Client_id = c.Client_id  
AND sd.SurveyType_id=st.SurveyType_id  
GROUP BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, LEFT(SurveyType_dsc,15)  
ORDER BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id  
PRINT '*************************************************************************************'  
PRINT 'FormGen Errors'  
SELECT mm.Survey_id, sd.strSurvey_nm, LEFT(SurveyType_dsc,15) SurveyType,   
       CONVERT(VARCHAR,fge.datGenerated,101) AS 'Date Generated', fget.FGErrorType_dsc, COUNT(*) AS 'Total'  
 FROM Mailingmethodology mm, Survey_def sd, FormGenError fge, FormGenErrortype fget,   
      ScheduledMailing schm, SurveyType st  
 WHERE mm.methodology_id = schm.methodology_id  
 AND mm.Survey_id = sd.Survey_id  
 AND fge.ScheduledMailing_id = schm.ScheduledMailing_id  
 AND fge.FGErrorType_id = fget.FGErrorType_id  
 AND fge.datGenerated BETWEEN @starttime AND @endtime  
 AND sd.SurveyType_id=st.SurveyType_id  
 GROUP BY mm.Survey_id, sd.strSurvey_nm, LEFT(SurveyType_dsc,15),   
          CONVERT(VARCHAR,fge.datGenerated,101) , fget.FGErrorType_dsc  
PRINT ''  
PRINT '*************************************************************************************'  
PRINT 'Number of Questionnaires Left to FormGen'  
SELECT COUNT(*) AS Total_Questionnaires  
FROM   Survey_def SD, SamplePop SP, ScheduledMailing SM, MailingMethodology MM  
WHERE  SP.SamplePop_id = SM.SamplePop_id   
 AND SM.SentMail_id IS NULL   
 AND SM.datGenerate <= @endtime   
 AND SD.bitFormGenRelease = 1   
 AND MM.Methodology_id = SM.Methodology_id   
 AND MM.Survey_id = SD.Survey_id   
 AND SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError  
      WHERE ScheduledMailing_id IS NOT NULL)  
PRINT ''  
PRINT '*************************************************************************************'  
PRINT 'Number of Questionnaires in PCLNeeded with bitDone = 0'  
SELECT COUNT(*) AS Total_Questionnaires  
FROM PCLNeeded  
WHERE bitDone = 0  
PRINT ''  
PRINT '*************************************************************************************'  
PRINT 'Number of Questionnaires in PCLNeeded with bitDone = 1'  
SELECT COUNT(*) AS Total_Questionnaires  
FROM PCLNeeded  
WHERE bitDone = 1  
PRINT ''  
PRINT '*************************************************************************************'  
PRINT 'Number of Questionnaires PCLGen''ed per Survey'  
CREATE TABLE #Generated   
(Ident INT identity(1,1),  
 Client VARCHAR(60),  
 Client_id VARCHAR(6),  
 Study VARCHAR(10),   
 Study_id VARCHAR(6),  
 Survey VARCHAR(42),  
 Survey_id VARCHAR(6),  
 StrMailingStep VARCHAR(42),  
 SurveyType VARCHAR(25),  
 Total_Questionnaires INT)  
  
INSERT INTO #Generated(Client, Client_id, Study, Study_id, Survey, Survey_id, strMailingStep,   
                       SurveyType, Total_Questionnaires)  
SELECT strClient_nm, c.Client_id, strStudy_nm, s.Study_id, sd.strSurvey_nm, pgl.Survey_id,   
       strMailingStep_nm, LEFT(SurveyType_dsc,15), COUNT(*)  
 FROM PCLGenLog pgl, Survey_def sd, Study s, Client c, ScheduledMailing schm,   
      MailingStep ms, SurveyType st  
 WHERE pgl.Survey_id = sd.Survey_id  
  AND datLogged BETWEEN @starttime  AND @endtime   
  AND pgl.SentMail_id IS NOT NULL  
  AND sd.Study_id = s.Study_id  
  AND s.Client_id = c.Client_id  
  AND pgl.SentMail_id = schm.SentMail_id  
  AND schm.MailingStep_id = ms.MailingStep_id  
  AND sd.SurveyType_id=st.SurveyType_id  
  AND schm.SentMail_id>20000000    
 GROUP BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, sd.strSurvey_nm, pgl.Survey_id,   
          strMailingStep_nm, LEFT(SurveyType_dsc,15)  
 ORDER BY strClient_nm, c.Client_id, strStudy_nm, s.Study_id, sd.strSurvey_nm, pgl.Survey_id,   
          strMailingStep_nm  
  
INSERT INTO #Generated(Client, Client_id, Study, Study_id, Survey, Survey_id, strMailingStep,   
                       SurveyType, Total_Questionnaires)  
SELECT '', '', '', '', '', '', '', '          SUM =', Sum(Total_Questionnaires) FROM #Generated  
  
SELECT Client, Client_id, Study, Study_id, Survey, Survey_id, strMailingStep, SurveyType,   
       Total_Questionnaires  
 FROM #Generated  
ORDER BY Ident  
PRINT ''  
  
GO

