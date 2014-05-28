/*
Created 9/03/08 MWB
Purpose:  This proc updates the SampleSetUnitTarget table.
		It is used in Prop. sampling to update the real calculated target for the HCAHPS unit after it has
		been modified in sampling tool (by applying the proportional sampling percentage)

Modified 9/23/08 JJF - Added update for SamplePlanWorksheet table when using proportional sampling
*/
CREATE PROCEDURE [dbo].[QCL_UpdateSampleSetUnitTarget] 
    @SampleSet_ID int, 
    @SampleUnit_ID int, 
    @Target int,
    @UpdateSPW bit
AS

UPDATE SampleSetUnitTarget  
SET intTarget = @Target
WHERE SampleSet_ID = @SampleSet_ID 
  AND SampleUnit_ID = @SampleUnit_ID

IF (@UpdateSPW = 1)
BEGIN
    UPDATE SamplePlanWorksheet
    SET intPeriodReturnTarget = 0, 
        numDefaultResponseRate = 0, 
        numAdditionalPeriodOutgoNeeded = 0, 
        intOutGoNeededNow = @Target, 
        intShortFall = 0
    WHERE SampleSet_id = @SampleSet_id
      AND SampleUnit_id = @SampleUnit_id
END


