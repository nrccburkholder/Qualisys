CREATE PROCEDURE SP_Extract_BigViewCheck @SampleSet_id INT
AS

SELECT SampleUnit_id, intSampledNow+intIndirectSampledNow Sampled
FROM SamplePlanWorkSheet 
WHERE SampleSet_id=@SampleSet_id


