/*
	RTP-3590 Report Records TOCLd During Generation.sql

	Lanny Boswell

	ALTER PROCEDURE [dbo].[sp_sys_MorningStatus]

*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_sys_MorningStatus] AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
DECLARE @starttime DATETIME      
DECLARE @endtime DATETIME      
DECLARE @formgened INT, @PCLGened INT      
select @starttime = (CONVERT(VARCHAR(10),GETDATE()-1,120)) + ' 6:00'      
select @endtime = (CONVERT(VARCHAR(10),GETDATE(),120)) + ' 6:00'      
      
set @formgened = (SELECT COUNT(*)       
 FROM SentMailing (NOLOCK)      
 WHERE datGenerated BETWEEN @starttime AND @endtime)      
      
SET @PCLGened = (SELECT COUNT(DISTINCT SM.SentMail_id)      
 FROM PCLGenLog PCL(NOLOCK), SentMailing SM(NOLOCK), Survey_def SD(NOLOCK)      
 WHERE PCL.SentMail_id = SM.SentMail_id      
  AND PCL.datLogged BETWEEN @starttime AND @endtime      
  AND PCL.Survey_id = SD.Survey_id)      
      
IF @formgened > (@PCLGened + 299)      
BEGIN      
PRINT '*************************************************************************************'      
PRINT '** WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING **'      
PRINT '*************************************************************************************'      
PRINT 'There may have been Surveys formgened but not PCLGened.'      
PRINT CONVERT(VARCHAR,@formgened) + ' Surveys went through formgen '      
PRINT 'and ' + CONVERT(VARCHAR,@PCLGened) + ' Surveys were PCLGened.'      
PRINT ''      
END      
      
PRINT '*************************************************************************************'      
PRINT 'Number of Questionnaires FormGen''ed by Batch'      
SELECT datGenerated, COUNT(*) AS Total_Questionnaires      
 FROM SentMailing (NOLOCK)      
 WHERE datGenerated BETWEEN @starttime AND @endtime      
 GROUP BY datGenerated      
 ORDER BY datGenerated      
 COMPUTE SUM(COUNT(*))      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of Questionnaires FormGen''ed & PCLGen''ed by Survey'      
SELECT DISTINCT CONVERT(VARCHAR,SM.datGenerated ,101) AS 'Form Gen Date', PCL.Survey_id,     
      SD.strSurvey_nm, LEFT(SurveyType_dsc,15) SurveyType, COUNT(DISTINCT SM.SentMail_id)      
 FROM PCLGenLog PCL(NOLOCK), SentMailing SM(NOLOCK), Survey_def SD(NOLOCK), SurveyType st (NOLOCK)      
 WHERE PCL.SentMail_id = SM.SentMail_id      
  AND PCL.datLogged BETWEEN @starttime AND @endtime      
  AND PCL.Survey_id = SD.Survey_id      
  AND SM.SentMail_id>20000000      
  AND sd.SurveyType_id=st.Surveytype_id    
 GROUP BY CONVERT(VARCHAR,SM.datGenerated ,101), PCL.Survey_id, SD.strSurvey_nm, LEFT(SurveyType_dsc,15)     
 ORDER BY PCL.Survey_id      
 COMPUTE SUM(COUNT(DISTINCT SM.SentMail_id))      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'FormGen Errors'      
SELECT mm.Survey_id, sd.strSurvey_nm, LEFT(SurveyType_dsc,15) SurveyType,     
       CONVERT(VARCHAR,fge.datGenerated,101) AS 'Date Generated', fget.FGErrorType_dsc, COUNT(*) AS 'Total'      
 FROM MailingMethodology mm(NOLOCK), Survey_def sd(NOLOCK), formgenerror fge(NOLOCK),     
      formgenerrortype fget(NOLOCK), ScheduledMailing schm(NOLOCK), SurveyType st(NOLOCK)      
 WHERE mm.Methodology_id = schm.Methodology_id      
 AND mm.Survey_id = sd.Survey_id      
 AND fge.ScheduledMailing_id = schm.ScheduledMailing_id      
 AND fge.FGErrorType_id = fget.FGErrorType_id      
 AND fge.datGenerated BETWEEN @starttime AND @endtime      
 AND schm.Scheduledmailing_id>20000000    
 AND sd.SurveyType_id=st.SurveyType_id      
 group by mm.Survey_id, sd.strSurvey_nm, LEFT(SurveyType_dsc,15),     
          CONVERT(VARCHAR,fge.datGenerated,101), fget.FGErrorType_dsc      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of Questionnaires LEFT to FormGen'      
SELECT COUNT(*) AS Total_Questionnaires      
FROM   Survey_def SD(NOLOCK), SamplePop SP(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK)    
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
FROM PCLNeeded(NOLOCK)      
WHERE bitDone = 0      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of Questionnaires in PCLNeeded with bitDone = 1'      
SELECT COUNT(*) AS Total_Questionnaires      
FROM PCLNeeded(NOLOCK)      
WHERE bitDone = 1      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of Questionnaires PCLGen''ed per Batch'      
SELECT PR.PCLGenRun_id, Start_dt, End_dt, COUNT(*) AS Total_Questionnaires      
 FROM PCLGenLog PL(NOLOCK), PCLGenRun PR(NOLOCK)      
 WHERE datLogged BETWEEN @starttime AND @endtime      
  AND SentMail_id IS NOT NULL      
  AND PL.PCLGenRun_id = PR.PCLGenRun_id      
  AND SentMail_id>20000000      
 GROUP BY PR.PCLGenRun_id, Start_dt, End_dt      
 ORDER BY Start_dt      
 COMPUTE SUM(COUNT(*))      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of Questionnaires PCLGen''ed per Survey'      
SELECT pgl.Survey_id, sd.strSurvey_nm, LEFT(SurveyType_dsc,15) SurveyType, COUNT(*) AS Total_Questionnaires      
 FROM PCLGenLog pgl(NOLOCK), Survey_def sd(NOLOCK), SurveyType st(NOLOCK)    
 WHERE pgl.Survey_id = sd.Survey_id      
  AND datLogged BETWEEN @starttime AND @endtime      
--  AND SentMail_id IS NOT NULL      
  AND SentMail_id>20000000      
  AND sd.SurveyType_id=st.SurveyType_id      
 GROUP BY pgl.Survey_id, sd.strSurvey_nm, LEFT(SurveyType_dsc,15)    
 ORDER BY pgl.Survey_id      
 COMPUTE SUM(COUNT(*))      
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of Batches PCLGen''ed'      
SELECT Computer_nm, COUNT(*) AS Total_Batches      
 FROM PCLGenRun(NOLOCK)      
 WHERE Start_dt BETWEEN @starttime AND @endtime      
 GROUP BY Computer_nm    
 ORDER BY Computer_nm        
PRINT ''      
PRINT '*************************************************************************************'      
PRINT 'Number of samples TOCL''d During Generation'      
select COUNT(*) AS Tocl_During_Generation
from DispositionLog dl WITH (NOLOCK)
inner join Disposition d WITH (NOLOCK)
	on d.Disposition_id = dl.Disposition_id
where dl.datLogged between @starttime and @endtime
	and d.strDispositionLabel = 'TOCL During Generation'
--PRINT ''      
--PRINT '*************************************************************************************'      
--PRINT 'Jobs'      
--SELECT LEFT(name,40) AS 'Job Name',       
-- LEFT(Step_Name,20) AS 'Step Name',       
-- LEFT(Message, 20) AS 'Message',       
-- CONVERT(DATETIME,      
--  SUBSTRING( CONVERT( CHAR(8),Run_Date ),5,2 ) + '/' +       
--  RIGHT( CONVERT( CHAR(8),Run_Date ),2 ) + '/' +       
--  LEFT( CONVERT( CHAR(8),Run_Date ),4) + ' ' +       
--  LEFT( CONVERT( CHAR(6),RIGHT( REPLICATE('0',6-LEN(RTRIM(run_time))) + RTRIM(run_time),6 ) ),2 ) + ':' +      
--  SUBSTRING( CONVERT( CHAR(6),RIGHT( REPLICATE('0',6-LEN(RTRIM(run_time))) + RTRIM(run_time),6 ) ),3,2 ) + ':' +       
--  RIGHT(CONVERT( CHAR(6),RIGHT( REPLICATE('0',6-LEN(RTRIM(run_time))) + RTRIM(run_time),6 ) ),2 ) ,101 )      
--  AS 'Start Time'      
--FROM msdb.dbo.sysJobs j, msdb.dbo.sysJobHistory jh      
--WHERE j.job_id = jh.job_id      
--AND CONVERT(DATETIME,      
-- SUBSTRING( CONVERT( CHAR(8),Run_Date ),5,2 ) + '/' +       
-- RIGHT( CONVERT( CHAR(8),Run_Date ),2 ) + '/' +       
-- LEFT( CONVERT( CHAR(8),Run_Date ),4) , 101)      
-- BETWEEN @starttime AND @endtime    
    
GO


