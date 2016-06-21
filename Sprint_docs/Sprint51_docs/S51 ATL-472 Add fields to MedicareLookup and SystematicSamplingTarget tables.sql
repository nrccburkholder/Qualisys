/*
S51 ATL-472 Add fields to MedicareLookup and SystematicSamplingTarget tables.sql

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

select * from qualpro_params

*/

USE [QP_Prod]
GO

IF NOT EXISTS(select * from QUALPRO_PARAMS where strparam_nm = 'SystematicAnnualReturnTarget')
INSERT INTO QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_GRP, STRPARAM_TYPE, NUMPARAM_VALUE, COMMENTS)
VALUES ('SystematicAnnualReturnTarget','SystematicDefaults','N',384,'Systematic Annual Return Target for OASCAHPS')
GO

IF NOT EXISTS(select * from QUALPRO_PARAMS where strparam_nm = 'SystematicEstimatedResponseRate')
INSERT INTO QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_GRP, STRPARAM_TYPE, NUMPARAM_VALUE, COMMENTS)
VALUES ('SystematicEstimatedResponseRate','SystematicDefaults','N',32,'Systematic Estimated Response Rate for OASCAHPS')
GO

if exists (select * from sys.procedures where name = 'QCL_SelectSystematicDefaultSamplingTargetValues')
	drop procedure QCL_SelectSystematicDefaultSamplingTargetValues
go
CREATE PROCEDURE QCL_SelectSystematicDefaultSamplingTargetValues
AS
SELECT qpp1.NUMPARAM_VALUE AS AnnualReturnTarget, qpp2.NUMPARAM_VALUE / 100.0 AS EstimatedResponseRate
from qualpro_params qpp1,
Qualpro_params qpp2 
where qpp1.strparam_nm = 'SystematicAnnualReturnTarget' 
and qpp2.strparam_nm = 'SystematicEstimatedResponseRate'
GO

IF NOT EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'SystematicSwitchToCalcDate' )
ALTER TABLE MEDICARELOOKUP
ADD SystematicSwitchToCalcDate DateTime
GO

IF NOT EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'SystematicAnnualReturnTarget' )
ALTER TABLE MEDICARELOOKUP
ADD SystematicAnnualReturnTarget int
GO

IF NOT EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'SystematicEstRespRate' )
ALTER TABLE MEDICARELOOKUP
ADD SystematicEstRespRate [decimal] (8,4)
GO

IF NOT EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[MEDICARELOOKUP]') AND name = 'NonSubmitting' )
ALTER TABLE MEDICARELOOKUP
ADD NonSubmitting bit
GO

IF NOT EXISTS ( SELECT * FROM sys.columns   WHERE  object_id = OBJECT_ID(N'[dbo].[SystematicSamplingTarget]') AND name = 'DateCalculated' )
ALTER TABLE SystematicSamplingTarget
ADD DateCalculated DateTime
GO

update medicarelookup set SystematicAnnualReturnTarget = 384, SystematicEstRespRate = 32, SystematicSwitchToCalcDate = '1/1/2000', NonSubmitting = 0

update medicarelookup set SystematicAnnualReturnTarget = ml.AnnualReturnTarget, SystematicEstRespRate = 100 * ml.EstRespRate, SystematicSwitchToCalcDate = ml.SwitchToCalcDate 
--select *
from medicarelookup ml
inner join systematicsamplingtarget sst on ml.MedicareNumber = sst.CCN

/****** Object:  StoredProcedure [dbo].[QCL_CalculateSystematicSamplingOutgo]    Script Date: 6/9/2016 11:13:28 AM ******/
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
	, case when dbo.yearqtr(min(SwitchToCalcDate)) < dbo.yearqtr(@samplingdate) then NULL else min(mlu.SystematicEstRespRate / 100.0) end as numResponseRate 
	, min(mlu.SystematicAnnualReturnTarget) as AnnualTarget
	, ceiling(min(mlu.SystematicAnnualReturnTarget)/4.0) as QuarterTarget
	, ceiling(min(mlu.SystematicAnnualReturnTarget)/12.0) as MonthTarget
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

insert into dbo.SystematicSamplingTarget (SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget, SamplesetsPerMonth, SamplesetTarget, OutgoNeededPerSampleset, DateCalculated)
select SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget, SamplesetsPerMonth, SamplesetTarget, OutgoNeededPerSampleset, GetDate()
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
    @Active bit,
	@SystematicAnnualReturnTarget int,
	@SystematicEstRespRate decimal(8,4),
	@SystematicSwitchToCalcDate datetime,
	@NonSubmitting bit
AS  
  
IF EXISTS (SELECT * FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber)  
BEGIN  
    RAISERROR ('MedicareNumber already exists.',18,1)  
    RETURN  
END  
  
INSERT INTO MedicareLookup (MedicareNumber, MedicareName, MedicarePropCalcType_ID, 
                            EstAnnualVolume, EstRespRate, EstIneligibleRate, 
                            SwitchToCalcDate, AnnualReturnTarget, SamplingLocked,
                            ProportionChangeThreshold, CensusForced, PENumber, Active,
							SystematicAnnualReturnTarget, SystematicEstRespRate, SystematicSwitchToCalcDate, NonSubmitting)
SELECT @MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstAnnualVolume,
       @EstRespRate, @EstIneligibleRate, @SwitchToCalcDate, @AnnualReturnTarget, 
       @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @PENumber, @Active,
	   @SystematicAnnualReturnTarget, @SystematicEstRespRate, @SystematicSwitchToCalcDate, @NonSubmitting

SELECT @MedicareNumber

GO

ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareNumbers]    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,  
       EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,  
       SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active,
	   SystematicAnnualReturnTarget, SystematicEstRespRate, SystematicSwitchToCalcDate, NonSubmitting
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
       SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active,
	   SystematicAnnualReturnTarget, SystematicEstRespRate, SystematicSwitchToCalcDate, NonSubmitting
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
       ml.SamplingLocked, ml.ProportionChangeThreshold, ml.CensusForced, ml.PENumber, ml.Active,
	   ml.SystematicAnnualReturnTarget, ml.SystematicEstRespRate, ml.SystematicSwitchToCalcDate, ml.NonSubmitting
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
    @Active bit,
	@SystematicAnnualReturnTarget int,
	@SystematicEspRespRate decimal(8,4),
	@SystematicSwitchToCalcDate datetime,
	@NonSubmitting bit
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
    Active = @Active,
	SystematicAnnualReturnTarget = @SystematicAnnualReturnTarget,
	SystematicEstRespRate = @SystematicEspRespRate,
	SystematicSwitchToCalcDate = @SystematicSwitchToCalcDate,
	NonSubmitting = @NonSubmitting
WHERE MedicareNumber = @MedicareNumber

GO
