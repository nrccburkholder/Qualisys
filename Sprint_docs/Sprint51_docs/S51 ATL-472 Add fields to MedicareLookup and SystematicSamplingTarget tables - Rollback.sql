/*
S51 ATL-472 Add fields to MedicareLookup and SystematicSamplingTarget tables - Rollback.sql

Chris Burkholder

INSERT INTO QUALPRO_PARAMS
CREATE PROCEDURE QCL_SelectSystematicDefaultSamplingTargetValues
ALTER TABLE MEDICARELOOKUP
ALTER TABLE SystematicSamplingTarget
ALTER PROCEDURE QCL_CalculateSystematicSamplingOutgo

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
