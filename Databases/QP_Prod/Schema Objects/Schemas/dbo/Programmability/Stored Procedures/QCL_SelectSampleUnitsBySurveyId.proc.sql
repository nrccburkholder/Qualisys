CREATE PROCEDURE [dbo].[QCL_SelectSampleUnitsBySurveyId]
@SurveyId INT
AS

/*
2014-0815 CAMELINCKX Re-enabling return of fields:
					 su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM
					 having to cast them as bit since the computed columns were made ints
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, 
/* 
 CAST(su.bitHCAHPS AS bit) AS bitHCAHPS,
 CAST(su.bitACOCAHPS AS bit) AS bitACOCAHPS,
 CAST(su.bitHHCAHPS AS bit) AS bitHHCAHPS,
 CAST(su.bitCHART AS bit) AS bitCHART,
 CAST(su.bitMNCM AS bit) AS bitMNCM,
*/ 
 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit
FROM SampleUnit su, SamplePlan sp
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = @SurveyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
