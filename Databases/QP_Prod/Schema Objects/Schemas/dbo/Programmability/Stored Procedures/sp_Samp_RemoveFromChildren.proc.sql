/****** Object:  Stored Procedure dbo.sp_Samp_RemoveFromChildren    Script Date: 9/28/99 2:57:17 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_RemoveFromChildren
Part of:  Sampling Tool
Purpose:  Removes the people from child sample units that have been removed from the target sample
  unit (@intSampleUnit_id).
Input:  @intSampleUnit_id: Sample Unit ID of the source sample unit.
 
Output:  Records in #SampleUnit_Universe with an 8 in the Removed_Rule column.
Creation Date: 09/15/1999
Author(s): DA 
Revision: First build - 09/15/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_RemoveFromChildren
 @intSampleUnit_id int
AS
 /*Create the Child Units Table*/
 CREATE TABLE #ChildUnits
  (SampleUnit_id int)
 /*Get Children*/
 INSERT INTO #ChildUnits
 SELECT SampleUnit_id
  FROM dbo.SampleUnit 
   WHERE ParentSampleUnit_id = @intSampleUnit_id
 
 /*Remove them from the #SampleUnit_Universe*/
  UPDATE SUU_Target
   SET SUU_Target.Removed_Rule = 8
   FROM #Sampleunit_Universe SUU_Target, #Sampleunit_Universe SUU_Source, #ChildUnits CU
     WHERE SUU_Target.SampleUnit_id = CU.SampleUnit_id
      AND SUU_Source.SampleUnit_id = @intSampleUnit_id
      AND SUU_Target.Pop_id = SUU_Source.Pop_id 
      AND SUU_Target.Removed_Rule = 0
      AND SUU_Source.Removed_Rule = 8
 
 /*Clean up the temp table*/
 DROP TABLE #ChildUnits


