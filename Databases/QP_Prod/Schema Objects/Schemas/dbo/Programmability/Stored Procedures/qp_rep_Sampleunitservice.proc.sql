CREATE PROCEDURE [dbo].[qp_rep_Sampleunitservice]
@LastXMonths INT = 36  
AS  
  
-- Created 4/20/05 : SJS  
-- Testing variables  
/**/--DECLARE @LastXMonths INT    
/**/--SELECT @LastXMonths  = 1  
  
SELECT DISTINCT sampleunit_id   
INTO #su  
FROM datamart.qp_comments.dbo.respratecount   
WHERE datsamplecreate_dt > DATEADD(mm,@LastXMonths*-1,GETDATE()) AND sampleunit_id <> 0  
  
SELECT strNTLogin_Nm AS AD, v.Client_id, v.strClient_nm, v.Study_id, v.strStudy_nm, v.Survey_id, v.strSurvey_nm, su.Sampleunit_id, su.strSampleunit_nm,    
CASE WHEN sus.sampleunit_id IS NOT NULL THEN 'Yes'    ELSE 'No' END AS Defined,  
CASE WHEN su.parentsampleunit_id IS NULL THEN 'Yes' ELSE 'No' END AS RootUnit  
FROM sampleunit su  
INNER JOIN  #su su2 ON su.sampleunit_id = su2.sampleunit_id  
LEFT JOIN (SELECT DISTINCT sampleunit_Id FROM sampleunitservice) sus ON su.sampleunit_id = sus.sampleunit_id  
INNER JOIN  sampleplan sp ON su.sampleplan_id = sp.sampleplan_id   
INNER JOIN  Web_ClientStudySurvey_View v ON sp.survey_id = v.survey_id   
AND v.client_id <> 443  
  
DROP TABLE #su


