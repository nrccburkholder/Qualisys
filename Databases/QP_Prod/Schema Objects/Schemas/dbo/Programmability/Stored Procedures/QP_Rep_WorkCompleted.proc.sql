﻿--============================================================

CREATE PROCEDURE QP_Rep_WorkCompleted  
 @Associate VARCHAR(20),  
 @FirstDay DATETIME,  
 @LastDay DATETIME,  
 @Client VARCHAR(50) = '_ALL',  
 @Study VARCHAR(50) = '_ALL',  
 @Survey VARCHAR(50) = '_ALL'  
  
AS  

-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  IF @FirstDay = @LastDay  
 BEGIN  
  SET @FirstDay = DATEADD(DAY, -45, @FirstDay)  
 END  
  
 SELECT @LastDay=DATEADD(DAY,1,@LastDay)  
  
IF @Client = '_ALL'  
BEGIN  
  
 SELECT isnull(sd.contract, 'Missing') as [Contract Number], t.*  
 FROM TeamStatus_WorkCompleted t (NOLOCK), Study_Employee se (NOLOCK), Employee e (NOLOCK), survey_def sd (NOLOCK)
 WHERE e.strNTLogin_nm = @Associate  
 AND e.Employee_id = se.Employee_id  
 AND se.Study_id = t.Studyid  
 AND t.SurveyID = sd.survey_ID
 AND CONVERT(DATETIME,t.SampleDate) BETWEEN @FirstDay AND @LastDay  
 ORDER BY 2,3,5,7,14,dummy_step  
 GOTO FINISH  
  
END  
  
ELSE IF @Study = '_ALL'  
BEGIN  
  
 SELECT isnull(sd.contract, 'Missing') as [Contract Number], t.*  
 FROM TeamStatus_WorkCompleted t (NOLOCK), survey_def sd (NOLOCK),  
  (SELECT DISTINCT Study_id   
   FROM ClientStudySurvey_View   
   WHERE strClient_nm = @Client) a  
 WHERE a.Study_id = t.StudyID  
	AND t.SurveyID = sd.survey_ID
	AND CONVERT(DATETIME,t.SampleDate) BETWEEN @FirstDay AND @LastDay  
 ORDER BY 2,3,5,7,14,dummy_step  
 GOTO FINISH  
  
END  
  
ELSE IF @Survey = '_ALL'  
BEGIN  
  
 SELECT isnull(sd.contract, 'Missing') as [Contract Number], t.*  
 FROM TeamStatus_WorkCompleted t (NOLOCK), survey_def sd (NOLOCK),
  (SELECT DISTINCT Survey_id   
   FROM ClientStudySurvey_View   
   WHERE strClient_nm = @Client  
   AND strStudy_nm = @Study) a  
 WHERE a.Survey_id = t.SurveyID  
 AND t.SurveyID = sd.survey_ID
 AND CONVERT(DATETIME,t.SampleDate) BETWEEN @FirstDay AND @LastDay  
 ORDER BY 2,3,5,7,14,dummy_step  
 GOTO FINISH  
  
END  
  
ELSE   
BEGIN  
  
 SELECT isnull(sd.contract, 'Missing') as [Contract Number], t.*  
 FROM TeamStatus_WorkCompleted t (NOLOCK), survey_def sd  (NOLOCK),
  (SELECT DISTINCT Survey_id  
   FROM ClientStudySurvey_View   
   WHERE strClient_nm = @Client  
   AND strStudy_nm = @Study  
   AND strSurvey_nm = @Survey) a  
 WHERE a.Survey_id = t.SurveyID  
 AND t.SurveyID = sd.survey_ID
 AND CONVERT(DATETIME,t.SampleDate) BETWEEN @FirstDay AND @LastDay  
 ORDER BY 2,3,5,7,14,dummy_step  
 GOTO FINISH  
  
END  
  
FINISH:  
UPDATE DashBoardLog  
SET ProcedureEnd = GETDATE()  
WHERE report = 'Work Completed'  
AND Associate = @Associate  
AND StartDate = @FirstDay  
AND EndDate = @LastDay  
AND ProcedureEnd IS NULL  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


