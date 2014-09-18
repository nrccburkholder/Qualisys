USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]    Script Date: 8/18/2014 8:40:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]  
    @UserName VARCHAR(42),  
    @ShowAllClients BIT = 0  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
--Need a temp table to hold the ids the user has rights to  
CREATE TABLE #EmpStudy (  
    Client_id INT,  
    Study_id INT,  
    strStudy_nm VARCHAR(10),  
    strStudy_dsc VARCHAR(255),
    ADEmployee_id int,
    datCreate_dt datetime,
    bitCleanAddr bit,
    bitProperCase bit,
    Active bit
)  
  
--Populate the temp table with the studies they have rights to.  
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	        datCreate_dt, bitCleanAddr, bitProperCase, Active)  
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc, s.ADEmployee_id,
	   s.datCreate_dt, s.bitCleanAddr, s.bitProperCase, s.Active
FROM Employee e, Study_Employee se, Study s  
WHERE e.strNTLogin_nm = @UserName  
  AND e.Employee_id = se.Employee_id  
  AND se.Study_id = s.Study_id  
  AND s.datArchived IS NULL  
  
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)  
  
--First recordset.  List of clients they have rights to.  
IF @ShowAllClients = 1  
BEGIN  
    SELECT c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID  
    FROM Client c  
    ORDER BY c.strClient_nm  
END  
ELSE  
BEGIN  
    SELECT c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID  
    FROM #EmpStudy t, Client c  
    WHERE t.Client_id = c.Client_id  
    GROUP BY c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID
    ORDER BY c.strClient_nm  
END  
  
--Second recordset.  List of studies they have rights to  
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	   datCreate_dt, bitCleanAddr, bitProperCase, Active     
FROM #EmpStudy  
ORDER BY strStudy_nm  
  
--Third recordset.  List of surveys they have rights to  
SELECT s.Survey_id, s.strSurvey_nm, s.strSurvey_dsc, s.Study_id, s.strCutoffResponse_cd,
       s.CutoffTable_id, s.CutoffField_id, s.SampleEncounterTable_ID,
       s.SampleEncounterField_ID, s.bitValidated_flg, s.datValidated,  
       s.bitFormGenRelease, ISNULL(sp.SamplePlan_id,0) SamplePlan_id,  
       s.INTRESPONSE_RECALC_PERIOD, s.intResurvey_Period, s.datSurvey_Start_dt,  
       s.datSurvey_End_dt, s.SamplingAlgorithmID, s.bitEnforceSkip, s.strClientFacingName,  
       s.SurveyType_id, s.SurveyTypeDef_id, s.ReSurveyMethod_id, s.strHouseholdingType,
	   s.Contract, s.Active, s.ContractedLanguages, s.UseUSPSAddrChangeService
  FROM #EmpStudy t  
       JOIN Survey_def s  
         ON t.Study_id = s.Study_id  
       LEFT JOIN SamplePlan sp  
         ON s.Survey_id = sp.Survey_id  
ORDER BY s.strSurvey_nm  
  
--Cleanup temp table  
DROP TABLE #EmpStudy  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


GO


