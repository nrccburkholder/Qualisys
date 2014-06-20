﻿CREATE PROCEDURE [dbo].[QCL_SelectSampleUnitsBySurveyId]
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM,
 su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit
FROM SampleUnit su, SamplePlan sp
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = @SurveyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

