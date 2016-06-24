/*
S51 ATL-472 Add fields to MedicareLookup and SystematicSamplingTarget tables - Rollback.sql

Chris Burkholder

INSERT INTO QUALPRO_PARAMS
CREATE PROCEDURE QCL_SelectSystematicDefaultSamplingTargetValues
ALTER TABLE MEDICARELOOKUP
ALTER TABLE SystematicSamplingTarget
ALTER PROCEDURE QCL_CalculateSystematicSamplingOutgo
ALTER PROCEDURE QCL_CalcTargets
ALTER FUNCTION GetHCAHPSEstReponseRate

ALTER PROCEDURE QCL_InsertMedicareNumber
ALTER PROCEDURE QCL_SelectAllMedicareNumbers
ALTER PROCEDURE QCL_SelectMedicareNumbers
ALTER PROCEDURE QCL_SelectMedicareNumbersBySurveyID
ALTER PROCEDURE QCL_UpdateMedicareNumber

select ml.* from medicarelookup ml
inner join systematicsamplingtarget sst on ml.MedicareNumber = sst.CCN

*/

USE [QP_Prod]
GO

if exists (select * from sys.procedures where name = 'QCL_SelectSystematicDefaultSamplingTargetValues')
	drop procedure QCL_SelectSystematicDefaultSamplingTargetValues


IF EXISTS(select * from QUALPRO_PARAMS where strparam_nm = 'SurveyRule: BypassInitRespRateNumericEnforcement - OAS CAHPS')
DELETE from Qualpro_params where strparam_nm = 'SurveyRule: BypassInitRespRateNumericEnforcement - OAS CAHPS'

IF EXISTS(select * from QUALPRO_PARAMS where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - OAS CAHPS')
DELETE from Qualpro_params where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - OAS CAHPS'

IF EXISTS(select * from QUALPRO_PARAMS where strparam_nm = 'SystematicAnnualReturnTarget')
DELETE from QUALPRO_PARAMS where strparam_nm = 'SystematicAnnualReturnTarget'

IF EXISTS(select * from QUALPRO_PARAMS where strparam_nm = 'SystematicEstimatedResponseRate')
DELETE from QUALPRO_PARAMS where strparam_nm = 'SystematicEstimatedResponseRate'

/****** Object:  StoredProcedure [dbo].[QCL_CalculateSystematicSamplingOutgo]    Script Date: 6/9/2016 11:13:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_CalculateSystematicSamplingOutgo]    Script Date: 6/9/2016 11:36:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[QCL_CalculateSystematicSamplingOutgo]
@survey_id int, @samplingdate datetime
as

declare @CCN varchar(20)
select @CCN = suf.medicarenumber
from sampleplan sp
inner join sampleunit su on sp.SAMPLEPLAN_ID=su.sampleplan_id
inner join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
where sp.survey_id=@survey_id
and su.CAHPSType_id>0

if @CCN is null
	RAISERROR (N'Surveys using Systematic Sampling must have at least one unit defined as a CAHPS unit and linked to a CCN.',
           10, -- Severity
           1); -- State

if exists (select * from SystematicSamplingTarget where SampleQuarter = dbo.yearqtr(@samplingdate) and CCN=@CCN)
begin
	return
end

-- declare @survey_id int=19009, @samplingdate datetime = '7/1/16'
create table #SystematicSamplingTarget
(	SampleQuarter char(6)
,	CCN varchar(20)
,	numLocations smallint
,	SamplingAlgorithmID int
,	RespRateType varchar(15)
,	numResponseRate decimal(5,4)
,	AnnualTarget int
,	QuarterTarget int
,	MonthTarget int
,	SamplesetsPerMonth smallint
,	SamplesetTarget numeric(6,2)
,	OutgoNeededPerSampleset int
)

insert into #SystematicSamplingTarget (SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget)
select dbo.yearqtr(@samplingdate) as SampleQuarter
	, suf.medicarenumber as CCN
	, count(su.SAMPLEUNIT_ID) as numLocations
	, 4 as SamplingAlgorithmID
	, case when dbo.yearqtr(min(SwitchToCalcDate)) < dbo.yearqtr(@samplingdate) then 'Historic' else 'Default' end as RespRateType
	, case when dbo.yearqtr(min(SwitchToCalcDate)) < dbo.yearqtr(@samplingdate) then NULL else min(mlu.EstRespRate) end as numResponseRate 
	, min(mlu.AnnualReturnTarget) as AnnualTarget
	, ceiling(min(mlu.AnnualReturnTarget)/4.0) as QuarterTarget
	, ceiling(min(mlu.AnnualReturnTarget)/12.0) as MonthTarget
from sampleplan sp
inner join sampleunit su on sp.SAMPLEPLAN_ID=su.sampleplan_id
inner join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
inner join medicarelookup mlu on suf.medicarenumber=mlu.medicarenumber
where sp.survey_id=@survey_id
and su.CAHPSType_id=16
group by suf.medicarenumber 

if @@rowcount > 1
	RAISERROR (N'Surveys using Systematic Sampling can only reference one CCN.',
           10, -- Severity
           1); -- State

-- if MedicareLookup.AnnualReturnTarget isn't evenly divisible by 12, change AnnualTarget and QuarterTarget so that they align with the CEILING'd MonthTarget
if exists (select * from #SystematicSamplingTarget where AnnualTarget % 12 <> 0)
	update #SystematicSamplingTarget set AnnualTarget=12*MonthTarget, QuarterTarget=3*MonthTarget

if exists (select * from #SystematicSamplingTarget where RespRateType='Historic')
begin
	declare @rr float
	
	select @rr=1.0*sum(numReturned)/sum(numSampled)
	from (	select ss.sampleset_id, count(distinct sp.samplepop_id) as numSampled, count(distinct case when qf.datReturned is not null then qf.samplepop_id end) as numReturned, max(sm.datExpire) as datExpire
			from sampleset ss
			inner join samplepop sp on ss.sampleset_id=sp.sampleset_id
			inner join scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
			inner join sentmailing sm on scm.sentmail_id=sm.sentmail_id
			inner join questionform qf on scm.sentmail_id=qf.sentmail_id
			where ss.survey_id = @survey_id
			group by ss.sampleset_id
			having max(sm.datExpire)<getdate()
		) x

	update #SystematicSamplingTarget set numResponseRate = @rr where RespRateType='Historic'
end

if exists (select * from #SystematicSamplingTarget where numResponseRate is NULL or numResponseRate=0)
begin
	declare @RRtype varchar(15)
	select @RRType = RespRateType from #SystematicSamplingTarget
	RAISERROR (N'%s response rate cannot be 0 percent.',
           10, -- Severity,
           1, -- State
		   @RRtype); 
end

update #SystematicSamplingTarget 
set SamplesetsPerMonth=(select CEILING(sum(intExpectedSamples)/3.0)
						from #SystematicSamplingTarget sst
						inner join PeriodDef pd on sst.samplequarter = dbo.yearqtr(pd.datExpectedEncStart) and pd.survey_id=@survey_id)

update #SystematicSamplingTarget set SamplesetTarget=1.0*MonthTarget/SamplesetsPerMonth
update #SystematicSamplingTarget set OutgoNeededPerSampleset=CEILING(SamplesetTarget/numResponseRate)

insert into dbo.SystematicSamplingTarget (SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget, SamplesetsPerMonth, SamplesetTarget, OutgoNeededPerSampleset)
select SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget, SamplesetsPerMonth, SamplesetTarget, OutgoNeededPerSampleset
from #SystematicSamplingTarget 

drop table #SystematicSamplingTarget

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_CalcTargets]    Script Date: 6/21/2016 3:35:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
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

GO

ALTER function [dbo].[GetHCAHPSEstResponseRate] (@Sampleunit_ID int)
RETURNS int
as
begin

	Declare @estRespRate int
	set @estRespRate = 0

	select distinct @estRespRate = ml.estRespRate * 100
	from sampleunit su, sufacility sf, medicarelookup ml
	where	su.sufacility_ID = sf.sufacility_ID and
			ml.medicarenumber = sf.medicarenumber and
			su.bitHCAHPS = 1 and 
			su.dontsampleUnit = 0 and
			su.sampleunit_ID = @Sampleunit_ID

	if @@Rowcount = 0 return 1
	if @estRespRate = 0 return 1
    if @estRespRate is null return 1

	return @estRespRate

End

GO

ALTER PROCEDURE [dbo].[QCL_InsertMedicareNumber]  
    @MedicareNumber VARCHAR(20),  
    @MedicareName varchar(45),
    @MedicarePropCalcType_ID int,
    @EstAnnualVolume int,
    @EstRespRate decimal(8,4),
    @EstIneligibleRate decimal(8,4),
    @SwitchToCalcDate datetime,
    @AnnualReturnTarget int,
    @SamplingLocked tinyint,
    @ProportionChangeThreshold decimal(8,4),
    @CensusForced tinyint,
    @PENumber VARCHAR(50), 
    @Active bit
AS  
  
IF EXISTS (SELECT * FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber)  
BEGIN  
    RAISERROR ('MedicareNumber already exists.',18,1)  
    RETURN  
END  
  
INSERT INTO MedicareLookup (MedicareNumber, MedicareName, MedicarePropCalcType_ID, 
                            EstAnnualVolume, EstRespRate, EstIneligibleRate, 
                            SwitchToCalcDate, AnnualReturnTarget, SamplingLocked,
                            ProportionChangeThreshold, CensusForced, PENumber, Active)  
SELECT @MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstAnnualVolume,
       @EstRespRate, @EstIneligibleRate, @SwitchToCalcDate, @AnnualReturnTarget, 
       @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @PENumber, @Active

SELECT @MedicareNumber

GO

ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareNumbers]    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,  
       EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,  
       SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active
FROM MedicareLookup

SET NOCOUNT OFF    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

ALTER PROCEDURE [dbo].[QCL_SelectMedicareNumbers] (@MedicareNumber varchar(20))
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,
       EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,
       SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active
FROM MedicareLookup  
WHERE MedicareNumber = @MedicareNumber
  
GO

ALTER PROCEDURE [dbo].[QCL_SelectMedicareNumbersBySurveyID]  
    @SurveyID int  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
SELECT DISTINCT ml.MedicareNumber, ml.MedicareName, ml.MedicarePropCalcType_ID, ml.EstAnnualVolume,  
       ml.EstRespRate, ml.EstIneligibleRate, ml.SwitchToCalcDate, ml.AnnualReturnTarget,  
       ml.SamplingLocked, ml.ProportionChangeThreshold, ml.CensusForced, ml.PENumber, ml.Active
FROM MedicareLookup ml, SUFacility sf, SampleUnit su, SamplePlan sp, Survey_Def sd   
WHERE ml.MedicareNumber = sf.MedicareNumber  
  AND sf.SUFacility_id = su.SUFacility_id  
  AND su.SamplePlan_id = sp.SamplePlan_id  
  AND sp.Survey_id = sd.Survey_id  
  AND sd.Survey_id = @SurveyID  
  
GO

ALTER PROCEDURE [dbo].[QCL_UpdateMedicareNumber]  
    @MedicareNumber VARCHAR(20),  
    @MedicareName VARCHAR(45),
    @MedicarePropCalcType_ID int,
    @EstAnnualVolume int,
    @EstRespRate decimal(8,4),
    @EstIneligibleRate decimal(8,4),
    @SwitchToCalcDate datetime,
    @AnnualReturnTarget int,
    @SamplingLocked tinyint,
    @ProportionChangeThreshold decimal(8,4),
    @CensusForced tinyint,
    @PENumber VARCHAR(50), 
    @Active bit
AS  

UPDATE MedicareLookup  
SET MedicareName = @MedicareName,  
    MedicarePropCalcType_ID = @MedicarePropCalcType_ID,
    EstAnnualVolume = @EstAnnualVolume ,
    EstRespRate = @EstRespRate ,
    EstIneligibleRate = @EstIneligibleRate,
    SwitchToCalcDate = @SwitchToCalcDate ,
    AnnualReturnTarget = @AnnualReturnTarget,
    SamplingLocked = @SamplingLocked ,
    ProportionChangeThreshold = @ProportionChangeThreshold ,
    CensusForced = @CensusForced,
    PENumber = @PENumber, 
    Active = @Active
WHERE MedicareNumber = @MedicareNumber

GO

IF EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'SystematicSwitchToCalcDate' )
ALTER TABLE MEDICARELOOKUP
DROP COLUMN SystematicSwitchToCalcDate
GO

IF EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'SystematicAnnualReturnTarget' )
ALTER TABLE MEDICARELOOKUP
DROP COLUMN SystematicAnnualReturnTarget 
GO

IF EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'SystematicEstRespRate' )
ALTER TABLE MEDICARELOOKUP
DROP COLUMN SystematicEstRespRate 
GO

IF EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'NonSubmitting' )
ALTER TABLE MEDICARELOOKUP
DROP COLUMN NonSubmitting
GO

IF EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[SystematicSamplingTarget]') AND name = 'DateCalculated' )
ALTER TABLE SystematicSamplingTarget
DROP COLUMN DateCalculated
GO
