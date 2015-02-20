IF (ObjectProperty(Object_Id('dbo.QCL_SelectClientsStudiesAndSurveysByUser'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_SelectClientsStudiesAndSurveysByUser
GO

/*
Business Purpose:

This procedure is used to support the Qualisys Class Library.  It returns three
datasets.  The first is a list of all client names an employee has rights to.  The second
selects all of the study names and client_ids the employee has rights to.  The third selects
all of the survey names and study_ids the employee has rights to.


Created:  11/03/2005 by Joe Camp

Modified:
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection
02/16/2006 by DC - Added bitValidated_flg to survey selection. Added ADEmployee_id to Study.
02/23/2006 by DC - Added samplePlanId to survey selection
02/24/2006 by DC - Added INTRESPONSE_RECALC_PERIOD to survey selection
02/28/2006 by Brian Dohmen - Added Additional columns to survey selection
03/01/2006 by Brian Dohmen - Changed to left join to sampleplan table
03/17/2006 by Joe Camp - Changed to add ShowAllClients option
03/27/2006 by DC - Added strHouseholdingType to survey selection
09/26/2006 by Brian Mao - Add SampleEncounterTable_ID and SampleEncounterField_ID to survey selection
*/
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
  ADEmployee_id int
)

--Populate the temp table with the studies they have rights to.
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id)
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc,s.ADEmployee_id
FROM Employee e, Study_Employee se, Study s
WHERE e.strNTLogin_nm=@UserName
AND e.Employee_id=se.Employee_id
AND se.Study_id=s.Study_id
AND s.datArchived IS NULL

CREATE INDEX tmpIndex ON #EmpStudy (Client_id)

--First recordset.  List of clients they have rights to.
IF @ShowAllClients = 1
BEGIN
	SELECT c.Client_id, c.strClient_nm
	FROM Client c
	ORDER BY c.strClient_nm
END
ELSE
BEGIN
	SELECT c.Client_id, c.strClient_nm
	FROM #EmpStudy t, Client c
	WHERE t.Client_id=c.Client_id
	GROUP BY c.Client_id, c.strClient_nm
	ORDER BY c.strClient_nm
END

--Second recordset.  List of studies they have rights to
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id
FROM #EmpStudy
ORDER BY strStudy_nm

--Third recordset.  List of surveys they have rights to
SELECT s.Survey_id,
       s.strSurvey_nm,
       s.strSurvey_dsc,
       s.Study_id, 
       s.strCutoffResponse_cd,
       s.CutoffTable_id,
       s.CutoffField_id,    
       s.SampleEncounterTable_ID,
       s.SampleEncounterField_ID,
       s.bitValidated_flg,
       s.datValidated,
       s.bitFormGenRelease, 
       ISNULL(sp.SamplePlan_id,0) SamplePlan_id,
       s.INTRESPONSE_RECALC_PERIOD,  
       s.intResurvey_Period,
       s.datSurvey_Start_dt,
       s.datSurvey_End_dt,
       s.SamplingAlgorithmID,   
       s.bitEnforceSkip,
       s.strClientFacingName,
       s.SurveyType_id,
       s.SurveyTypeDef_id,
       s.datHCAHPSReportable,
       s.ReSurveyMethod_id,
       s.strHouseholdingType  
  FROM #EmpStudy t
       JOIN Survey_def s
         ON t.Study_id=s.Study_id
       LEFT JOIN SamplePlan sp
         ON s.Survey_id=sp.Survey_id
ORDER BY s.strSurvey_nm

--Cleanup temp table
DROP TABLE #EmpStudy

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
