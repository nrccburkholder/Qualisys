/****** Object:  Stored Procedure dbo.sp_Samp_FetchSampleUnit    Script Date: 9/28/99 2:57:14 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_FetchSampleUnit 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_FetchSampleUnit 
 @intSurvey_id INT 
AS
 SELECT SampleUnit_id, CriteriaStmt_id
  FROM dbo.SampleUnit SU, dbo.SamplePlan SP
  WHERE SP.Survey_id = @intSurvey_id
   AND SP.SamplePlan_id = SU.SamplePlan_id


