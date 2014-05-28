--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/***********************************************************************************************************************************
SP Name: sp_Samp_CalcTargetsV2
Part of:  Sampling Tool
Purpose:  Calculate the targets for each sample units of the sample plan for a specific sampleset.
Input:  SampleSet_id of sampleset being processed
 
Output:  SampleSet Targets for each SampleUnit
Creation Date: 02/02/2004
Author(s): DC 
Revision: First build - 02/02/2004
5/5/2006 - BGD: If the responserate is 0 then set it equal to the initial responserate

***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_CalcTargetsV2
 @intSampleSet_id INT,
 @intPeriod_id INT
AS
 DECLARE @SamplesInPeriod INT
 DECLARE @SamplesRun INT
 DECLARE @SamplesLeft INT
 DECLARE @intSurvey_id INT
 DECLARE @samplingMethod varchar(30)


	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_CalcTargets', getdate())

 SELECT @samplingMethod=strsamplingMethod_nm
 FROM dbo.PeriodDef p, dbo.samplingmethod s
 WHERE p.perioddef_id=@intPeriod_id and
		p.samplingmethod_id=s.samplingmethod_id


	
 SELECT @intSurvey_id = Survey_id
  FROM dbo.SampleSet
  WHERE SampleSet_id = @intSampleSet_id
	
/* Added to try and figure out how we are sending out too much */
/*INSERT INTO Track_ResponseRate
SELECT @intSurvey_id, @intSampleSet_id, SampleUnit_id, numInitResponseRate, NumResponseRate
FROM SamplePlan SP, SampleUnit SU
WHERE SP.Survey_id = @intSurvey_id
AND SP.SamplePlan_id = SU.SamplePlan_id*/

 /* Creating temp tables for calculation of targets */
 /* The following table will retain the number of eligible record per sample unit */
 CREATE TABLE #SampleUnit_Count
  (SampleUnit_id INT, 
  PopCounter INT)
 /* The following table will retain the sample_sets within this period*/
 CREATE TABLE #SampleSet_Period
  (SampleSet_id INT)
 /* The following table will retain the number of Samples left, target returns and response rates for each sample_units */
 CREATE TABLE #SampleUnit_Temp
  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period real, 
  ResponseRate real,
  InitResponseRate INT)
 /* The following table will retain the different numbers used to compute targets for each sample_units */
 CREATE TABLE #SampleUnit_Sample
  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period INT, 
  ResponseRate real, 
  InitResponseRate real,
  NumSampled_Period INT, 
  ReturnEstimate INT, 
  ReturnsNeeded_Period INT, 
  NumToSend_Period FLOAT, 
  NumToSend_SampleSet INT)

 SELECT @SamplesInPeriod = intExpectedSamples
  FROM dbo.perioddef
  WHERE perioddef_id = @intPeriod_id


	 /* Getting the other sampleSet_id than the one we are processing */
	 INSERT INTO #SampleSet_Period
	  SELECT SampleSet_id 
	  FROM dbo.PeriodDates S
	  WHERE S.perioddef_id = @intPeriod_id and
			datsamplecreate_dt is not null
	
	 SELECT @SamplesRun = COUNT(*)
	  FROM #SampleSet_Period

	 SELECT @SamplesLeft = @SamplesInPeriod - @SamplesRun
	 IF @SamplesLeft < 1 
	  SELECT @SamplesLeft = 1 
	 INSERT INTO #SampleUnit_Temp
	  SELECT SampleUnit_id, @SamplesLeft, intTargetReturn, numResponseRate, numInitResponseRate
	   FROM dbo.SamplePlan SP, dbo.SampleUnit SU
	   WHERE SP.SamplePlan_id = SU.SamplePlan_id
	    AND SP.Survey_id = @intSurvey_id
	 INSERT INTO #SampleUnit_Sample(SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate,
	   NumSampled_Period, ReturnEstimate, ReturnsNeeded_Period, NumToSend_Period, 
	   NumToSend_SampleSet)
	  SELECT  SampleUnit_id, SamplesLeft, 
	   TargetReturn_Period, ISNULL(ResponseRate,0), InitResponseRate, 0, 0, 0, 0, 0
	   FROM  #SampleUnit_Temp

         --Begin modification 5/5/2006 BGD
          UPDATE #SampleUnit_Sample SET ResponseRate=InitResponseRate 
            WHERE ResponseRate=0
         --End modification 5/5/2006 BGD

	 INSERT INTO #SampleUnit_Count
	  SELECT SS.SampleUnit_id, COUNT(Pop_id)
	   FROM dbo.SelectedSample SS, #SampleSet_Period SSP
	   WHERE SS.SampleSet_id = SSP.SampleSet_id
	    AND SS.strUnitSelectType = 'D'
	   GROUP BY SS.SampleUnit_id
	 UPDATE #SampleUnit_Sample
	  SET NumSampled_Period = PopCounter
	  FROM #SampleUnit_Count SUC
	  WHERE SUC.SampleUnit_id = #SampleUnit_Sample.SampleUnit_id

IF @samplingMethod='Specify Targets' 
BEGIN

	 /* Computing the rest of the SampleUnit targets */
	 UPDATE #SampleUnit_Sample
	  SET ReturnEstimate = ROUND(NumSampled_Period * (CONVERT(float,ResponseRate)/100), 0)
	 UPDATE #SampleUnit_Sample
	  SET ReturnsNeeded_Period = TargetReturn_Period - ReturnEstimate
	 UPDATE #SampleUnit_Sample
	  SET NumToSend_Period = CASE 
		WHEN ResponseRate = 0 THEN ReturnsNeeded_Period/(CONVERT(float, InitResponseRate)/100)
		WHEN ResponseRate is null THEN ReturnsNeeded_Period/(CONVERT(float, 100)/100)
	   ELSE ReturnsNeeded_Period/(CONVERT(float, ResponseRate)/100) 
	   END
	 UPDATE #SampleUnit_Sample
	  SET NumToSend_SampleSet = ROUND(NumToSend_Period/SamplesLeft, 0)

	INSERT INTO SampleSetUnitTarget
	  SELECT @intSampleSet_id, SampleUnit_id, NumToSend_SampleSet
	   FROM #SampleUnit_Sample
	
	--Updates to SamplePlanWorkSheet table
	UPDATE spw
	SET spw.numHistoricResponseRate = ResponseRate, intAnticipatedTPPOReturns = ReturnEstimate,
		intAdditionalReturnsNeeded = ReturnsNeeded_Period, intSamplesLeftInPeriod = SamplesLeft - 1,
		numAdditionalPeriodOutgoNeeded = NumToSend_Period, intOutgoNeededNow = NumToSend_SampleSet,
		intSamplesAlreadyPulled=@SamplesRun + 1, inttotalpriorperiodoutgo=NumSampled_Period
	FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t
	WHERE spw.SampleSet_id = @intSampleSet_id
	AND spw.SampleUnit_id = t.SampleUnit_id
END
Else IF @samplingMethod='Specify Outgo'
Begin
	 UPDATE #SampleUnit_Sample
	  SET ReturnsNeeded_Period = TargetReturn_Period - NumSampled_Period

	 UPDATE #SampleUnit_Sample 
	  SET NumToSend_SampleSet=ROUND(ReturnsNeeded_Period*1.0/SamplesLeft,0)
	   FROM dbo.SamplePlan SP, dbo.SampleUnit SU
	   WHERE SP.SamplePlan_id = SU.SamplePlan_id
	    AND SP.Survey_id = @intSurvey_id 
		AND su.sampleunit_id=#SampleUnit_Sample.sampleunit_id

	INSERT INTO SampleSetUnitTarget
	  SELECT @intSampleSet_id, SampleUnit_id, NumToSend_SampleSet
	   FROM #SampleUnit_Sample
	
	--Updates to SamplePlanWorkSheet table
	UPDATE spw
	SET spw.numHistoricResponseRate = ResponseRate, 
		intAdditionalReturnsNeeded = ReturnsNeeded_Period,
		intSamplesLeftInPeriod = SamplesLeft - 1,
		intOutgoNeededNow = NumToSend_SampleSet,
		intSamplesAlreadyPulled=@SamplesRun + 1, 
		inttotalpriorperiodoutgo=NumSampled_Period,
		numAdditionalPeriodOutgoNeeded = ReturnsNeeded_Period
	FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t
	WHERE spw.SampleSet_id = @intSampleSet_id
	AND spw.SampleUnit_id = t.SampleUnit_id
END
ELSE
BEGIN
	--CENSUS
	SELECT sampleunit_Id, count(*) as unitcount
	INTO #CensusCounts
	FROM #Sampleunit_universe
	WHERE Removed_Rule = 0
	GROUP by sampleunit_Id

	 UPDATE #SampleUnit_Sample
	  SET NumToSend_SampleSet = unitcount
	 FROM #SampleUnit_Sample sus, #CensusCounts c
	 WHERE sus.sampleunit_id=c.sampleUnit_id

	INSERT INTO SampleSetUnitTarget
	  SELECT @intSampleSet_id, SampleUnit_id, NumToSend_SampleSet
	   FROM #SampleUnit_Sample
	
	--Updates to SamplePlanWorkSheet table
	--SamplesLeft and Samples to Run need to be adjusted to account for this
	--Sample
	UPDATE spw
	SET spw.numHistoricResponseRate = ResponseRate, 
		intSamplesLeftInPeriod = SamplesLeft -1,
		intOutgoNeededNow = NumToSend_SampleSet,
		intSamplesAlreadyPulled=@SamplesRun + 1, 
		inttotalpriorperiodoutgo=NumSampled_Period
	FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t
	WHERE spw.SampleSet_id = @intSampleSet_id
	AND spw.SampleUnit_id = t.SampleUnit_id

END


 DROP TABLE #SampleUnit_Count
 DROP TABLE #SampleSet_Period
 DROP TABLE #SampleUnit_Temp
 DROP TABLE #SampleUnit_Sample


