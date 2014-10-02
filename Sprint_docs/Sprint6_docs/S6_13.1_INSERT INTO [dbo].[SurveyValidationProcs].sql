
/*
Inserts new SurveyValidationProcs records 
and the SurveyValidationProcsBySurveyType mappings 

*/

declare @svpid int
declare @intOrder int
--declare @PCMHSubTypeId int

declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8


--SELECT @PCMHSubTypeId = [Subtype_id]
--FROM [dbo].[Subtype]
--where [Subtype_nm] = 'PCMH'

begin tran



truncate table SurveyValidationProcsBySurveyType

delete from SurveyValidationProcs
where ProcedureName = 'SV_ALL_CAHPS'

Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

-- now insert the discrete validation procs
SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_ModeMapping'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_ModeMapping','Validate Mode Mapping',@intOrder)
END
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SampleUnit'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnit','Survey has at least one sampleunit',@intOrder)
	set @svpid=scope_identity()	
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@CGCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_ActiveMethodology'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ActiveMethodology','Survey has an active methodology',@intOrder)
	set @svpid=scope_identity()	
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@CGCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_RequiredPopulationFields'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredPopulationFields','Check if fields are part of the Population',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredEncounterFields','Check if fields are part of the Encounter',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SSV_CAHPS_SkipPatterns'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SkipPatterns','Make sure skip patterns are enforced.',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@CGCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_Resurvey'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Resurvey','Check the ReSurvey Method',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_Householding'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Householding','Check for HouseHolding',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_AHA_Id'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_AHA_Id','Is AHA_id populated?',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_ReportingDate'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ReportingDate','Check reporting date Field',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplingMethod'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingMethod','Check the sampling method',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SampleUnitTarget'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnitTarget','Check that all HHCAHPS sampleunits have targets assigned.',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingAlgorithm','Check the sampling algorithm',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_MedicareNumber'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_MedicareNumber','Make sure the Medicare number is populated and/or active.',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_FacilityStatePopulated'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FacilityStatePopulated','Check that FacilityState is populated for the *CAHPS units',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplingEncounterDate'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingEncounterDate','Sampling Encounter date is either ServiceDate or DischargeDate',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_FormQuestions'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FormQuestions','All of questions are on the form and in the correct location',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_EnglishOrSpanish'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_EnglishOrSpanish','Check that only English or Hcahps Spanish is used on survey',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplePeriods'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplePeriods','Check for more than one sample period',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_AddrErrorDQ'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_AddrErrorDQ','Now check for Addr Error DQ rule',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_HasDQRule'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_HasDQRule','Has DQ Rules',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_HH_CAHPS_DQRules'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_HH_CAHPS_DQRules','Check DQ Rule',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_H_CAHPS_DQRules'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_H_CAHPS_DQRules','Check DQ rules',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

--SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_PCMH_CAHPS_DQRules'
--IF @@ROWCOUNT = 0	
--BEGIN
--	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_PCMH_CAHPS_DQRules','Check DQ rules',@intOrder)
--	set @svpid=scope_identity()
--END
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
--Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs



commit tran

--select *
--FROM SurveyValidationProcs_View
--order by SurveyValidationProcs_id

--select * from
--SurveyValidationProcsBySurveyType
--order by SurveyValidationProcs_id