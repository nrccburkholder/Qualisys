---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
/****** Object:  Stored Procedure dbo.sp_Samp_CalcTargets    Script Date: 9/28/99 2:57:11 PM ******/  
/***********************************************************************************************************************************  
SP Name: sp_Samp_CalcTargets  
Part of:  Sampling Tool  
Purpose:  Calculate the targets for each sample units of the sample plan for a specific sampleset.  
Input:  SampleSet_id of sampleset being processed  
   
Output:  SampleSet Targets for each SampleUnit  
Creation Date: 09/08/1999  
Author(s): DA, RC   
Revision: First build - 09/08/1999  
10/26/1999 - DG: changed #SampleUnit_Sample.NumToSend_Period from INT to FLOAT.  This way, rounding error   
is only introduced when calculating NumToSend_SampleSet and not when also calculating NumToSend_Period  
v2.0.1 - Brian Dohmen - 7/7/2003  
   Update SamplePlanWorkSheet table  
09/27/2011 - DRM - Added check for positive pop_id values, i.e. need to filter out seed mailing rows.
***********************************************************************************************************************************/  
CREATE PROCEDURE sp_Samp_CalcTargets  
 @intSampleSet_id INT  
AS  
 DECLARE @SamplesInPeriod INT  
 DECLARE @SamplesRun INT  
 DECLARE @SamplesLeft INT  
 DECLARE @intSurvey_id INT  
 SELECT @intSurvey_id = Survey_id  
  FROM dbo.SampleSet  
  WHERE SampleSet_id = @intSampleSet_id  
  
 --insert into dc_temp_timer (sp, starttime)  
 --values ('sp_Samp_CalcTargets', getdate())  
/* Added to try and figure out how we are sending out too much */  
INSERT INTO Track_ResponseRate  
SELECT @intSurvey_id, @intSampleSet_id, SampleUnit_id, numInitResponseRate, NumResponseRate  
FROM SamplePlan SP, SampleUnit SU  
WHERE SP.Survey_id = @intSurvey_id  
AND SP.SamplePlan_id = SU.SamplePlan_id  
  
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
  TargetReturn_Period INT,   
  ResponseRate INT,  
  InitResponseRate INT)  
 /* The following table will retain the different numbers used to compute targets for each sample_units */  
 CREATE TABLE #SampleUnit_Sample  
  (SampleUnit_id INT,   
  SamplesLeft INT,   
  TargetReturn_Period INT,   
  ResponseRate INT,   
  InitResponseRate INT,  
  NumSampled_Period INT,   
  ReturnEstimate INT,   
  ReturnsNeeded_Period INT,   
  NumToSend_Period FLOAT,   
  NumToSend_SampleSet INT)  
 /* Getting the other sampleSet_id than the one we are processing */  
 INSERT INTO #SampleSet_Period  
  SELECT SampleSet_id   
  FROM dbo.SampleSet S  
  WHERE S.survey_id = @intSurvey_id  
   AND S.SampleSet_id <> @intSampleSet_id  
   AND S.datSampleCreate_dt >   
                (SELECT coalesce(max(datPeriodDate),'01 January 1900')   
      FROM dbo.Period C   
                 WHERE C.Survey_id = @intSurvey_id)  
 SELECT @SamplesInPeriod = intSamplesInPeriod  
  FROM dbo.Survey_def  
  WHERE Survey_id = @intSurvey_id  
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
 INSERT INTO #SampleUnit_Sample(SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate,   NumSampled_Period, ReturnEstimate, ReturnsNeeded_Period, NumToSend_Period,   
   NumToSend_SampleSet)  
  SELECT  SampleUnit_id, SamplesLeft,   
   TargetReturn_Period, ISNULL(ResponseRate,0), InitResponseRate, 0, 0, 0, 0, 0  
   FROM  #SampleUnit_Temp  
 INSERT INTO #SampleUnit_Count  
  SELECT SS.SampleUnit_id, COUNT(DISTINCT Pop_id)  
   FROM dbo.SelectedSample SS, #SampleSet_Period SSP  
   WHERE SS.SampleSet_id = SSP.SampleSet_id  
    AND SS.strUnitSelectType = 'D'
    AND SS.pop_id>0		--DRM 9/27/2011
   GROUP BY SS.SampleUnit_id  
 UPDATE #SampleUnit_Sample  
  SET NumSampled_Period = PopCounter  
  FROM #SampleUnit_Count SUC  
  WHERE SUC.SampleUnit_id = #SampleUnit_Sample.SampleUnit_id  
 /* Computing the rest of the SampleUnit targets */  
 UPDATE #SampleUnit_Sample  
  SET ReturnEstimate = ROUND(NumSampled_Period * (CONVERT(float,ResponseRate)/100), 0)  
 UPDATE #SampleUnit_Sample  
  SET ReturnsNeeded_Period = TargetReturn_Period - ReturnEstimate  
 UPDATE #SampleUnit_Sample  
  SET NumToSend_Period = CASE WHEN ResponseRate = 0   
   THEN ReturnsNeeded_Period/(CONVERT(float, InitResponseRate)/100)  
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
 intAdditionalReturnsNeeded = ReturnsNeeded_Period, intSamplesLeftInPeriod = SamplesLeft,  
 numAdditionalPeriodOutgoNeeded = NumToSend_Period, intOutgoNeededNow = NumToSend_SampleSet  
FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t  
WHERE spw.SampleSet_id = @intSampleSet_id  
AND spw.SampleUnit_id = t.SampleUnit_id  
  
 DROP TABLE #SampleUnit_Count  
 DROP TABLE #SampleSet_Period  
 DROP TABLE #SampleUnit_Temp  
 DROP TABLE #SampleUnit_Sample


