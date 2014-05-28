/****** Object:  Stored Procedure dbo.sp_Samp_AddSampleSet    Script Date: 9/28/99 2:57:10 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_AddSampleSet 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - 2/4/2000 - Dave Gilsdorf
  Added strSampleSurvey_nm to dbo.SampleSet
v2.0.2 - 2/29/2000 - Dave Gilsdorf
  Changed so output is a result set, not an output parameter
v2.0.3 - 7/7/2003 - Brian Dohmen
  Changed to use scope_identity() instead of @@identity(for production).  Also populate SamplePlanWorkSheet table.
***********************************************************************************************************************************/
CREATE  PROCEDURE sp_Samp_AddSampleSet 
 @intSurvey_id INT,
 @intEmployee_id INT,
 @intDateRange_Table_id INT = NULL,
 @intDateRange_Field_id INT = NULL,
 @vcDateRange_FromDate VARCHAR(24) = NULL,
 @vcDateRange_ToDate VARCHAR(24) = NULL,
 @tiOverSample_flag TINYINT = 0,
 @tiNewPeriod_flag TINYINT = 0
--, @intSampleSet_id INT OUTPUT
AS
 DECLARE @intSamplePlan_id INT, @intSampleSet_id int
 DECLARE @strSurvey_nm VARCHAR(10), @bitdynamic bit
 SELECT @strSurvey_nm = strSurvey_nm,
		@bitdynamic=bitdynamic 
  FROM Survey_def 
  WHERE Survey_id = @intSurvey_id
 SELECT @intSamplePlan_id = SamplePlan_id 
  FROM dbo.SamplePlan
  WHERE Survey_id = @intSurvey_id
 INSERT INTO dbo.SampleSet
  (SamplePlan_id, Survey_id, Employee_id, datSampleCreate_dt, 
   intDateRange_Table_id, intDateRange_Field_id, datDateRange_FromDate, 
   datDateRange_ToDate, tiOverSample_flag, tiNewPeriod_flag, strSampleSurvey_nm,
	bitdynamic)
 VALUES
  (@intSamplePlan_id, @intSurvey_id, @intEmployee_id, GETDATE(), 
   @intDateRange_Table_id, @intDateRange_Field_id, @vcDateRange_FromDate, 
   @vcDateRange_ToDate, @tiOverSample_flag, @tiNewPeriod_flag, @strSurvey_nm,
   @bitdynamic)
                                                                                                                                                                        
-- SELECT @@IDENTITY as intSampleSet_id
 SELECT @intSampleSet_id = @@IDENTITY 
-- SELECT @intSampleSet_id = SCOPE_IDENTITY()

--Insert into SamplePlanWorkSheet table
INSERT INTO SamplePlanWorkSheet (SampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intPeriodReturnTarget, 
	numDefaultResponseRate, intSamplesInPeriod)
SELECT @intSampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intTargetReturn, 
	numInitResponseRate, intSamplesInPeriod
FROM SampleUnit su, SamplePlan sp, Survey_def sd
WHERE sp.Survey_id = @intSurvey_id
AND sp.SamplePlan_id = su.SamplePlan_id
AND sp.Survey_id = sd.Survey_id

SELECT @intSampleSet_id AS intSampleSet_id


