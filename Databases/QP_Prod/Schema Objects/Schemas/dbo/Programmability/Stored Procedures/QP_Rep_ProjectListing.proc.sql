--========================================================


CREATE PROCEDURE [dbo].[QP_Rep_ProjectListing]  
 @Associate VARCHAR(50),  
 @Status VARCHAR(30)  
   
AS  

-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
DECLARE @ProcedureBegin DATETIME  
SET @ProcedureBegin=GETDATE()  
  
INSERT INTO DashboardLog (Report, Associate, Status, ProcedureBegin) SELECT 'Project Listing',@Associate, @Status, @ProcedureBegin  
  
DECLARE @MAXLoad TABLE (Study_id INT, datLoaded DATETIME)  
INSERT INTO @MAXLoad (Study_id, datLoaded)  
SELECT Study_id, MAX(datLoad_dt)  
FROM Data_Set  
GROUP BY Study_id  
  
DECLARE @MAXSample TABLE (Survey_id INT, datSample DATETIME)  
INSERT INTO @MAXSample (Survey_id, datSample)  
SELECT Survey_id, MAX(datSampleCreate_dt)  
FROM SampleSet  
GROUP BY Survey_id  
  
CREATE TABLE #Survey (Client_id INT, strClient_nm VARCHAR(42), Study_id INT, strStudy_nm CHAR(10),  
 Survey_id INT, ContractNumber VARCHAR(9), strSurvey_nm VARCHAR(10), AD VARCHAR(20), datSurvey_end_dt DATETIME,  
 Status VARCHAR(10), strMailFreq CHAR(9), LastFileLoad DATETIME, LastSample DATETIME,  
 SurveyType varchar(100))  
INSERT INTO #Survey (Client_id, strClient_nm, Study_id, strStudy_nm, Survey_id, ContractNumber, strSurvey_nm, ad, datSurvey_end_dt, strMailFreq,SurveyType)  
SELECT DISTINCT c.Client_id, strClient_nm, s.Study_id, strStudy_nm, Survey_id, isnull(Contract, 'Missing') as ContractNumber, strSurvey_nm, strntlogin_nm, datSurvey_end_dt, strmailfreq, SurveyType_dsc  
FROM Survey_def sd, Study s, Client c, employee e, surveytype st  
WHERE s.Study_id=sd.Study_id  
AND s.Client_id=c.Client_id  
AND s.ademployee_id=e.employee_id  
AND sd.surveytype_id=st.surveytype_id  
ORDER BY c.Client_id, Survey_id  
  
UPDATE t  
SET LastFileLoad=datLoaded  
FROM #Survey t, @MAXLoad m  
WHERE t.Study_id=m.Study_id  
  
UPDATE t  
SET LastSample=datSample  
FROM #Survey t, @MAXSample m  
WHERE t.Survey_id=m.Survey_id  
  
UPDATE #Survey SET Status='Active'   
WHERE datSurvey_end_dt>GETDATE()  
  
UPDATE #Survey SET Status='Completed'  
WHERE Status IS NULL  
  
IF @Status='Active'   
  BEGIN  
 SELECT Client_id,strClient_nm,Study_id,strStudy_nm,Survey_id,strSurvey_nm,ContractNumber, ad,   
               datSurvey_end_dt,strMailFreq,Status,LastFileLoad,LastSample,SurveyType  
        FROM #Survey   
 WHERE Status='Active'  
 ORDER BY strClient_nm, strStudy_nm, strSurvey_nm  
  END  
  
ELSE  
  BEGIN  
 SELECT Client_id,strClient_nm,Study_id,strStudy_nm,Survey_id,strSurvey_nm,ContractNumber, ad,   
               datSurvey_end_dt,strMailFreq,Status,LastFileLoad,LastSample,SurveyType  
        FROM #Survey   
 ORDER BY strClient_nm, strStudy_nm, strSurvey_nm  
  END  
  
UPDATE DashboardLog   
SET ProcedureEnd=GETDATE()  
WHERE Report='Project Listing'  
AND Associate=@Associate  
AND Status=@Status  
AND ProcedureBegin=@ProcedureBegin  
AND ProcedureEnd IS NULL  
  
DROP TABLE #Survey  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


