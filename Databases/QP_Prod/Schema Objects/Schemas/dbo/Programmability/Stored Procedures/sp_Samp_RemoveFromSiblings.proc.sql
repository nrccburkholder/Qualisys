/****** Object:  Stored Procedure dbo.sp_Samp_RemoveFromSiblings    Script Date: 9/28/99 2:57:17 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_RemoveFromSiblings
Part of:  Sampling Tool
Purpose:  Those people who have been sampled directly into the source sample unit (@intSampleUnit_id)
  are removed from eligibility from the sibling sample units of the sample unit universe.
Input:  @intSampleUnit_id: Sample Unit ID of the source sample unit.
 
Output:  Records in #SampleUnit_Universe with an 8 in the Removed_Rule column.
Creation Date: 09/14/1999
Author(s): DA 
Revision: First build - 09/14/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_RemoveFromSiblings 
 @intSampleUnit_id int
AS
 /*Create the #SiblingUnit table*/
 CREATE TABLE #SiblingUnit
  (SampleUnit_id int)
 /*Identify all Sibling Sample Units into the #SiblingUnit Table*/
 INSERT INTO #SiblingUnit
 SELECT SU2.SampleUnit_id
  FROM dbo.SampleUnit SU1, dbo.SampleUnit SU2
  WHERE SU1.ParentSampleUnit_id = SU2.ParentSampleUnit_id
   AND SU1.SampleUnit_id = @intSampleUnit_id 
   AND SU2.SampleUnit_id <> @intSampleUnit_id 
 /*Remove the people who have been sampled into the source sample unit from the sample unit's sibling units*/
 UPDATE SUU_Target
  SET SUU_Target.Removed_Rule = 8
  FROM #Sampleunit_Universe SUU_Target, #Sampleunit_Universe SUU_Source, #SiblingUnit SU
    WHERE SUU_Target.SampleUnit_id = SU.SampleUnit_id
     AND SUU_Source.SampleUnit_id = @intSampleUnit_id
     AND SUU_Target.Pop_id = SUU_Source.Pop_id 
     AND SUU_Target.strUnitSelectType = 'N'
     AND SUU_Target.Removed_Rule = 0
     AND SUU_Source.strUnitSelectType = 'D'
 
 DROP TABLE #SiblingUnit


