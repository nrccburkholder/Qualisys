/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It updates the samplesetUnitTarget    
table with target information, and also updates the SPW.    
    
Created:  02/24/2006 by DC    
    
Modified:    
 --MWB Prop Sampling Sprint 9/24/08 -- added case logic (function call: GetHCAHPSEstResponseRate)     
 --b/c HCAHPS unit will now have an numInitResponseRate of 0 (causes division by 0 error below)    
    
 --DRM 09/27/2011 - Added checks for positive pop_id values, i.e filter out seeded mailing data.
*/      
CREATE PROCEDURE [dbo].[QCL_CalcTargets]    
 @SampleSet_id INT,    
 @Period_id INT,     
 @SamplesInPeriod INT,    
 @SamplesRun INT,    
 @Survey_id INT,    
 @samplingMethod int    
AS    
Begin    
    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
 SET NOCOUNT ON    
 DECLARE @SamplesLeft int    
 SET @SamplesLeft=@SamplesInPeriod-@SamplesRun    
 DECLARE @Mailed TABLE (sampleunit_id int, samplepop_id int, sampleencounterdate datetime,    
       FirstMailing datetime)    
 DECLARE @MailedBeyond42Days TABLE (sampleunit_id int, intsampled int)    
    
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
    
   /* Getting the other sampleSet_id than the one we are processing */    
   INSERT INTO #SampleSet_Period    
    SELECT SampleSet_id     
    FROM dbo.PeriodDates S    
    WHERE S.perioddef_id = @Period_id and    
    datsamplecreate_dt is not null    
    
   IF @SamplesLeft < 1 SELECT @SamplesLeft = 1     
    
  --MWB Prop Sampling Sprint 9/24/08 -- added case logic (function call: GetHCAHPSEstResponseRate)     
  --b/c HCAHPS unit will now have an numInitResponseRate of 0 (causes division by 0 error below)    
   INSERT INTO #SampleUnit_Temp    
    SELECT SampleUnit_id, @SamplesLeft, intTargetReturn, numResponseRate, case when (numInitResponseRate = 0 and su.bitHCAHPS = 1) then dbo.GetHCAHPSEstResponseRate(su.sampleunit_ID) else numInitResponseRate end    
     FROM dbo.SamplePlan SP, dbo.SampleUnit SU    
     WHERE SP.SamplePlan_id = SU.SamplePlan_id    
   AND SP.Survey_id = @Survey_id    
    
    
   INSERT INTO #SampleUnit_Sample(SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate,    
     NumSampled_Period, ReturnEstimate, ReturnsNeeded_Period, NumToSend_Period,     
     NumToSend_SampleSet)    
    SELECT  SampleUnit_id, SamplesLeft,     
     TargetReturn_Period, ISNULL(ResponseRate,0), InitResponseRate, 0, 0, 0, 0, 0    
     FROM  #SampleUnit_Temp    
    
   INSERT INTO #SampleUnit_Count    
    SELECT SS.SampleUnit_id, COUNT(Pop_id)    
     FROM dbo.SelectedSample SS, #SampleSet_Period SSP    
     WHERE SS.SampleSet_id = SSP.SampleSet_id    
   AND SS.strUnitSelectType = 'D'
   AND ss.pop_id > 0			--DRM 9/27/2011    
     GROUP BY SS.SampleUnit_id    
    
  --Adjust counts for HCAHPS mailings > 42 days from the encounter date    
  IF EXISTS (Select top 1 1 FROM SURVEY_DEF WHERE SURVEYTYPE_ID=2 and SURVEY_ID=@Survey_id)    
   BEGIN    
    insert into @Mailed (sampleunit_id, samplepop_id, sampleencounterdate, FirstMailing)    
    select ss.sampleunit_id, sp.samplepop_id, sampleencounterdate, min(datmailed) as FirstMailing    
    from perioddates pd (nolock), selectedsample ss (nolock), sampleunit su (nolock),     
      samplepop sp (nolock), sentmailing sm (nolock), questionform qf (nolock)     
    where perioddef_id=@Period_id    
     and pd.sampleset_id=ss.sampleset_id    
     and ss.sampleunit_id=su.sampleunit_id    
     and su.bithcahps=1    
     and ss.study_id=sp.study_id    
     and ss.sampleset_id=sp.sampleset_id    
     and ss.pop_id=sp.pop_id    
     and sp.samplepop_id=qf.samplepop_id    
     and sm.sentmail_id=qf.sentmail_id    
     and sp.pop_id > 0			--DRM 9/27/2011
    group by ss.sampleunit_id, sp.samplepop_id, sampleencounterdate    
    
    INSERT INTO @MailedBeyond42Days (sampleunit_id, intsampled)    
    select sampleunit_id, count(*) as intsampled    
    from @Mailed    
    where datediff(d,sampleencounterdate,FirstMailing)>42    
    group by sampleunit_id    
   END    
    
  --This query will remove the late Mailed individuals for HCAHPS if they exist, or update nothing    
  --if it's not HCAHPS    
  UPDATE #SampleUnit_Count    
  SET PopCounter=PopCounter-intSampled    
  FROM #SampleUnit_Count sc, @MailedBeyond42Days bd    
  WHERE sc.sampleunit_id=bd.sampleunit_id    
    
   UPDATE #SampleUnit_Sample    
    SET NumSampled_Period = PopCounter    
    FROM #SampleUnit_Count SUC    
    WHERE SUC.SampleUnit_id = #SampleUnit_Sample.SampleUnit_id    
    
 IF @samplingMethod=1     
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
    SELECT @SampleSet_id, SampleUnit_id, NumToSend_SampleSet    
     FROM #SampleUnit_Sample    
      
  --This query will add back in the late Mailed individuals for HCAHPS if they exist, or update nothing    
  --if it's not HCAHPS.  We do this so the SPW will reflect the total outgo, including those who mailed late.    
  UPDATE #SampleUnit_Count    
  SET PopCounter=PopCounter+intSampled    
  FROM #SampleUnit_Count sc, @MailedBeyond42Days bd    
  WHERE sc.sampleunit_id=bd.sampleunit_id    
    
  --Updates to SamplePlanWorkSheet table    
  UPDATE spw    
  SET spw.numHistoricResponseRate = ResponseRate, intAnticipatedTPPOReturns = ReturnEstimate,    
   intAdditionalReturnsNeeded = ReturnsNeeded_Period, intSamplesLeftInPeriod = SamplesLeft - 1,    
   numAdditionalPeriodOutgoNeeded = NumToSend_Period, intOutgoNeededNow = NumToSend_SampleSet,    
   intSamplesAlreadyPulled=@SamplesRun + 1, inttotalpriorperiodoutgo=NumSampled_Period    
  FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t    
  WHERE spw.SampleSet_id = @SampleSet_id    
  AND spw.SampleUnit_id = t.SampleUnit_id    
 END    
 Else IF @samplingMethod=2    
 Begin    
   UPDATE #SampleUnit_Sample    
    SET ReturnsNeeded_Period = TargetReturn_Period - NumSampled_Period    
    
   UPDATE #SampleUnit_Sample     
    SET NumToSend_SampleSet=ROUND(ReturnsNeeded_Period*1.0/SamplesLeft,0)    
     FROM dbo.SamplePlan SP, dbo.SampleUnit SU    
     WHERE SP.SamplePlan_id = SU.SamplePlan_id    
   AND SP.Survey_id = @Survey_id     
   AND su.sampleunit_id=#SampleUnit_Sample.sampleunit_id    
    
  INSERT INTO SampleSetUnitTarget    
    SELECT @SampleSet_id, SampleUnit_id, NumToSend_SampleSet    
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
  WHERE spw.SampleSet_id = @SampleSet_id    
  AND spw.SampleUnit_id = t.SampleUnit_id    
 END    
 ELSE    
 BEGIN    
  --CENSUS    
   UPDATE #SampleUnit_Sample    
    SET NumToSend_SampleSet = 999999    
      
  INSERT INTO SampleSetUnitTarget    
    SELECT @SampleSet_id, SampleUnit_id, NumToSend_SampleSet    
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
  WHERE spw.SampleSet_id = @SampleSet_id    
  AND spw.SampleUnit_id = t.SampleUnit_id    
    
 END    
    
    
  DROP TABLE #SampleUnit_Count    
  DROP TABLE #SampleSet_Period    
  DROP TABLE #SampleUnit_Temp    
  DROP TABLE #SampleUnit_Sample    
    
    
       
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
 SET NOCOUNT OFF    
END


