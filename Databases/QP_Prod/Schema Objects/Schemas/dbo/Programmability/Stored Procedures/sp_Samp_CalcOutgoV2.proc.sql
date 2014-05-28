/****** Object:  Stored Procedure dbo.sp_Samp_CalcOutgo    Script Date: 9/28/99 2:57:11 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_CalcOutgoV2
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DC 
Revision: First build - 03/10/2004
**********************************************************************************************************************************/
CREATE      PROCEDURE sp_Samp_CalcOutgoV2
 @intSampleUnit_id int,
 @intSampleSet_id int
AS
	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_CalcOutgo '+ convert(varchar,@intsampleunit_id), getdate())

--We need to check and see if anyone has already been directly sampled for this unit.
--This can happen if the target is at a parent, because its children will be direct.
 SELECT (SELECT intTarget 
  FROM dbo.samplesetunittarget 
  WHERE SampleSet_id = @intSampleSet_id
   AND SampleUnit_id = @intSampleUnit_id)
 -  
 (SELECT COUNT(*)
  FROM #sampleunit_universe
  WHERE SampleUnit_id = @intSampleUnit_id
   AND strUnitSelectType  = 'D') as intOutgo


