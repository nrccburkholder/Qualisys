/****** Object:  Stored Procedure dbo.sp_Samp_CalcOutgo    Script Date: 9/28/99 2:57:11 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_CalcOutgo
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - 3/2/2000 - Dave Gilsdorf
  return results as a row in a recordset instead of an output parameter
***********************************************************************************************************************************/
CREATE     PROCEDURE sp_Samp_CalcOutgo
 @intSampleUnit_id int,
 @intSampleSet_id int
AS
	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_CalcOutgo '+ convert(varchar,@intsampleunit_id), getdate())


 SELECT (SELECT intTarget 
  FROM dbo.samplesetunittarget 
  WHERE SampleSet_id = @intSampleSet_id
   AND SampleUnit_id = @intSampleUnit_id)
 -  
 (SELECT COUNT(*)
  FROM dbo.SelectedSample
  WHERE SampleSet_id = @intSampleSet_id
   AND SampleUnit_id = @intSampleUnit_id
   AND strUnitSelectType  = 'D') as intOutgo


