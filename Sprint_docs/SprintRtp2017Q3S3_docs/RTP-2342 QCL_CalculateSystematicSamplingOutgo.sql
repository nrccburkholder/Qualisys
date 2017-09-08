/*
	RTP-2342 QCL_CalculateSystematicSamplingOutgo.sql

	Chris Burkholder

	9/8/2017

	ALTER QCL_CalculateSystematicSamplingOutgo

	bug fix, still accessing removed columns
*/

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_CalculateSystematicSamplingOutgo]    Script Date: 9/8/2017 10:05:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[QCL_CalculateSystematicSamplingOutgo]
@survey_id int, @samplingdate datetime
as

declare @CCN varchar(20)
declare @SurveyTypeId int
select @CCN = suf.medicarenumber,
	@SurveyTypeId = su.CAHPSType_id
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

if not exists(select * from MedicareLookupSurveyType where MedicareNumber = @CCN and SurveyType_ID = @SurveyTypeId)
	RAISERROR (N'Surveys using Systematic Sampling must have values on this sample unit''s particular CAHPS tab for this CCN in Medicare Management.' ,
           10, -- Severity
           1); -- State

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
	, case when dbo.yearqtr(min(SwitchToCalcDate)) < dbo.yearqtr(@samplingdate) then NULL else min(mlu.EstRespRate / 100.0) end as numResponseRate 
	, min(mlu.AnnualReturnTarget) as AnnualTarget
	, ceiling(min(mlu.AnnualReturnTarget)/4.0) as QuarterTarget
	, ceiling(min(mlu.AnnualReturnTarget)/12.0) as MonthTarget
from sampleplan sp
inner join sampleunit su on sp.SAMPLEPLAN_ID=su.sampleplan_id
inner join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
inner join MedicareLookupSurveyType mlu on suf.medicarenumber=mlu.medicarenumber
where sp.survey_id=@survey_id
and su.CAHPSType_id=16
and mlu.SurveyType_ID=16
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

