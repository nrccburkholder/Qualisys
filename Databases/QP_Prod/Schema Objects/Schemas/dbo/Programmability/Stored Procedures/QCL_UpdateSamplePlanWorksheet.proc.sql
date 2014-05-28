/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It updates the sample
plan worksheet table after we have finished the sampling algorithm.

Created:  02/27/2006 by DC

Modified:
*/  

CREATE PROCEDURE [dbo].[QCL_UpdateSamplePlanWorksheet]
 @SampleSet_id int,
 @SampleUnit_id int,
 @DQCount int,
 @DirectSampleCount int,
 @IndirectSampleCount int,
 @UniverseCount int,
 @MinEncDate datetime = null,
 @MaxEncDate datetime = null,
 @BadPhoneCount int,
 @BadAddressCount int,
 @HcahpsDirectSampledCount int
AS

UPDATE SamplePlanWorkSheet
SET intSampledNow = @DirectSampleCount,
	intIndirectSampledNow=@IndirectSampleCount, 
	intDQ = @DQCount, 
	intAvailableUniverse = @UniverseCount - @DQCount, 
	intUniversecount=coalesce(intUniversecount,0) + @UniverseCount,
	intshortfall=intoutgoneedednow-@DirectSampleCount,
	minEnc_dt=@MinEncDate,
	maxEnc_dt=@MaxEncDate,
	BadPhoneCount=@BadPhoneCount,
	BadAddressCount=@BadAddressCount,
	HcahpsDirectSampledCount=@HcahpsDirectSampledCount
WHERE SampleUnit_id = @SampleUnit_id
AND SampleSet_id = @SampleSet_id


