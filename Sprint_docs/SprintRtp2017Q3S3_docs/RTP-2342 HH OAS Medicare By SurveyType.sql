/*
	RTP-2342 HH OAS Medicare By SurveyType.sql

	Chris Burkholder

	8/31/2017

	ALTER PROCEDURE [dbo].[QCL_CalcResponseRates]
	ALTER PROCEDURE [dbo].[QCL_CalcTargets]    
	ALTER function [dbo].[GetHCAHPSEstResponseRate] (@Sampleunit_ID int)
	ALTER  PROCEDURE [dbo].[QCL_SelectOutGoNeeded]  
*/
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_CalcResponseRates]    Script Date: 8/31/2017 11:49:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It will update the response
rate information in the sampleunit table.

Created:  02/24/2006 by DC

Modified:
03/15/2006 Brian Dohmen	  Made the datamart location a variable so it will work in Canada.
			  I also incorporated the HCAHPS 6 week cutoff
*/  
ALTER PROCEDURE [dbo].[QCL_CalcResponseRates]
 @Survey_id INT,
 @ResponseRate_Recalc_Period INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @sql VARCHAR(8000), @DataMart VARCHAR(50)

SELECT @DataMart=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'

 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period=intResponse_Recalc_Period
  FROM Survey_def
  WHERE Survey_id=@Survey_id

CREATE TABLE #SampleSets (SampleSet_id INT, datsamplecreate_dt datetime)
 /* Mark the Sample Sets that have completed the collection methodology */
 INSERT INTO #SampleSets
 SELECT SampleSet_id, datsamplecreate_dt
  FROM SampleSet
  WHERE datLastMailed IS NOT NULL
   AND DATEDIFF(DAY, datLastMailed, GETDATE())>@ResponseRate_Recalc_Period
   AND Survey_id=@Survey_id

CREATE TABLE #r (SampleUnit_id INT, intSampled INT, intReturned INT, bitHCAHPS BIT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)

SELECT @sql='insert into #rr 
			Exec '+@DataMart+'.qp_comments.dbo.QCL_SelectRespRateInfoBySurveyId ' + convert(varchar,@Survey_id) 
EXEC (@sql)

--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
INSERT INTO #r (SampleUnit_id, intSampled, intReturned, bitHCAHPS)
SELECT SampleUnit_id, SUM(intSampled), SUM(intReturned), 0
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id=ss.SampleSet_id
GROUP BY SampleUnit_id

--Identify HCAHPS units
UPDATE t
SET bitHCAHPS=1
FROM #r t, SampleUnit su
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.bitHCAHPS=1

IF @@ROWCOUNT>0
BEGIN

CREATE TABLE #Update (SampleUnit_id INT, intReturned INT)
CREATE TABLE #rrDays (sampleset_id INT, sampleunit_id INT, intreturned INT)

SELECT @sql='insert into #rrDays 
			Exec '+@DataMart+'.qp_comments.dbo.QCL_SelectHCAHPSRespRateByDaysInfoBySurveyId ' + convert(varchar,@Survey_id) 
EXEC (@sql)

 --Update the response rate for the HCAHPS unit(s)
INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(r2.intReturned) intReturned
       FROM #rr rrc, 
       #rrDays r2, 
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND r2.sampleset_id=ss.sampleset_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND tt.SampleUnit_id=r2.SampleUnit_id
  AND ss.datSampleCreate_dt>'4/10/6'
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id

 INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(rrc.intReturned) intReturned
       FROM #rr rrc, 
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND ss.datSampleCreate_dt<'4/10/6'
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id

 UPDATE t
 SET intReturned=u.intReturned
 FROM #r t, (SELECT SampleUnit_id, SUM(intReturned) intReturned
 FROM #Update
 GROUP BY SampleUnit_id) u
 WHERE t.SampleUnit_id=u.SampleUnit_id

 DROP TABLE #Update

END

UPDATE su
SET numResponseRate=RespRate
FROM SampleUnit su, (SELECT SampleUnit_id, ((intReturned*1.0)/(intSampled)*100) RespRate
FROM #r) a
WHERE su.SampleUnit_id=a.SampleUnit_id

UPDATE su
SET numResponseRate=numInitResponseRate
FROM SampleUnit su, (
         SELECT SampleUnit_id 
         FROM SampleUnit s, SamplePlan sp 
         WHERE sp.Survey_id=@Survey_id
         AND sp.SamplePlan_id=s.SamplePlan_id) a LEFT JOIN #r t
ON a.SampleUnit_id=t.SampleUnit_id
WHERE t.SampleUnit_id IS NULL
AND a.SampleUnit_id=su.SampleUnit_id

DROP TABLE #r

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF



GO


/****** Object:  StoredProcedure [dbo].[QCL_CalcTargets]    Script Date: 8/31/2017 11:35:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[QCL_CalcTargets]    
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
    SELECT SampleUnit_id, @SamplesLeft, intTargetReturn, numResponseRate, 
		case when (numInitResponseRate = 0 and (su.CAHPSType_id in (2,3,16))) 
			then dbo.GetHCAHPSEstResponseRate(su.sampleunit_ID) 
			else numInitResponseRate end    
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
     and (su.bithcahps=1 OR su.CAHPSType_id = 16 ) --OAS
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


GO



ALTER function [dbo].[GetHCAHPSEstResponseRate] (@Sampleunit_ID int)
RETURNS int
/*
	9/1/2017 CBurkholder RTP-2342 Check MedicareLookupSurveyType table first (HH/OAS at first)
*/
as
begin

	declare @EstRespRate int = 0
	declare @SwitchFromRateOverrideDate datetime
	declare @SamplingRateOverride int
	if exists(select 1 from medicarelookupsurveytype mlst inner join
		sufacility suf on mlst.MedicareNumber = suf.MedicareNumber inner join
		sampleunit su on suf.SUFacility_id = suf.SUFacility_id and mlst.surveytype_id = su.CAHPSType_id 
		where su.sampleunit_id = @sampleunit_id)
		begin
			select 
				@EstRespRate = EstRespRate * 100,
				@SwitchFromRateOverrideDate = SwitchFromRateOverrideDate,
				@SamplingRateOverride = SamplingRateOverride * 100
			from medicarelookupsurveytype mlst inner join
			sufacility suf on mlst.MedicareNumber = suf.MedicareNumber inner join
			sampleunit su on suf.SUFacility_id = suf.SUFacility_id and mlst.surveytype_id = su.CAHPSType_id 
			where su.sampleunit_id = @sampleunit_id

			if GetDate() < @SwitchFromRateOverrideDate
				SET @EstRespRate = @SamplingRateOverride
		end
	else
		begin
			--For CAHPSType_id 3 & 16 (HHCAHPS and OASCAHPS) we should not be in this code block
			if exists(select 1 from sampleunit where CAHPSType_id in (3,16) and sampleunit_id = @sampleunit_id)
				begin
					return cast('MEDICARE LOOKUP TAB NOT FILLED OUT FOR CAHPSType_id associated with SampleUnit_id: '+convert(varchar, @sampleunit_id) as int)
				end
			
			select distinct @estRespRate = ml.estRespRate * 100
			from sampleunit su, sufacility sf, medicarelookup ml
			where	su.sufacility_ID = sf.sufacility_ID and
					ml.medicarenumber = sf.medicarenumber and
					(su.bitHCAHPS = 1 or su.CAHPSType_id = 16) and 
					su.dontsampleUnit = 0 and
					su.sampleunit_ID = @Sampleunit_ID
		
			if @@Rowcount = 0 return 1
		end

	if @estRespRate = 0 return 1
    if @estRespRate is null return 1

	return @estRespRate

End

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectOutGoNeeded]    Script Date: 8/31/2017 4:22:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



/*  
Business Purpose:   
This procedure is used to support the Qualisys Class Library.  It returns 1 record   
for each sampleunit that needs to be sampled.  
  
Created:  02/24/2006 by DC  
  
Modified:  
--MWB 9/3/08  HCAHPS Prop Sampling Sprint 
--	Added a DontSampleUnit so users can "retire" a sampleunit without setting targets to 0 and renaming.
--	also added the ability to not sample the HCAHPS unit if it is a oversample.  All logic is controlled in the sampling app

*/    
  
ALTER  PROCEDURE [dbo].[QCL_SelectOutGoNeeded]  
 @SampleSet_id int,   
 @survey_id int,  
 @Period_id INT,   
 @SamplesInPeriod INT,  
 @SamplesRun INT,  
 @samplingMethod INT,  
 @ResponseRate_Recalc_Period INT,  
 @SampleHCAHPSUnit tinyint = 1
AS  

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON  
	--Calculates the current response rate and updates the sampleunit table  
	EXEC QCL_CalcResponseRates @survey_id, @ResponseRate_Recalc_Period  
	--Calculates the targets for the current sampleset and saves in the SampleSetUnitTarget table  
	EXEC QCL_CalcTargets @SampleSet_id, @Period_id, @SamplesInPeriod, @SamplesRun,   
	  @Survey_id, @samplingMethod  


	--MWB 9/3/08  HCAHPS Prop Sampling Sprint 
	if @SampleHCAHPSUnit = 1
		begin
		 SELECT su.SampleUnit_ID, intTarget   
		 FROM	dbo.samplesetunittarget sssu, Sampleunit su   
		 WHERE	sssu.sampleunit_ID = su.sampleunit_ID and 
				sssu.SampleSet_id = @SampleSet_id  
				and su.DontSampleUnit = 0
		end
	else
		begin
		 SELECT su.SampleUnit_ID, intTarget   
		 FROM	dbo.samplesetunittarget sssu, Sampleunit su   
		 WHERE	sssu.sampleunit_ID = su.sampleunit_ID and 
				sssu.SampleSet_id = @SampleSet_id  
				and su.DontSampleUnit = 0
				and su.bitHCAHPS = 0
		end

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
	SET NOCOUNT OFF  

END


GO

