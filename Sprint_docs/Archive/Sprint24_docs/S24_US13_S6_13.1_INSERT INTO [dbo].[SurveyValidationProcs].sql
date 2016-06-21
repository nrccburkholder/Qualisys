USE QP_Prod
/*


S24 US13.1  Setup PCMH survey validation

Tim Butler

Inserts new SurveyValidationProcs records and the SurveyValidationProcsBySurveyType mappings 

*/

declare @svpid int
declare @intOrder int
declare @PCMHSubTypeId int
declare @CGCAHPS int

SELECT  @CGCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

SELECT @PCMHSubTypeId = [Subtype_id]
FROM [dbo].[Subtype]
where [Subtype_nm] = 'PCMH Distinction'

begin tran


Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SampleUnit'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnit','Survey has at least one sampleunit',@intOrder)
	set @svpid=scope_identity()	
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_ActiveMethodology'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ActiveMethodology','Survey has an active methodology',@intOrder)
	set @svpid=scope_identity()	
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredEncounterFields','Check if fields are part of the Encounter',@intOrder)
	set @svpid=scope_identity()
END

INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SSV_CAHPS_SkipPatterns'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SkipPatterns','Make sure skip patterns are enforced.',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_Resurvey'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Resurvey','Check the ReSurvey Method',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_Householding'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Householding','Check for HouseHolding',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplingMethod'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingMethod','Check the sampling method',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SampleUnitTarget'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnitTarget','Check that all HHCAHPS sampleunits have targets assigned.',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingAlgorithm','Check the sampling algorithm',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_SamplingEncounterDate'
IF @@ROWCOUNT = 0
BEGIN	
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingEncounterDate','Sampling Encounter date is either ServiceDate or DischargeDate',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_FormQuestions'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FormQuestions','All of questions are on the form and in the correct location',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_PCMH_CAHPS_DQRules'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_PCMH_CAHPS_DQRules','Check DQ rules',@intOrder)
	set @svpid=scope_identity()
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs



commit tran

select *
FROM SurveyValidationProcs_View
where CAHPSType_ID = @CGCAHPS
order by SurveyValidationProcs_id

select * from
SurveyValidationProcsBySurveyType
where CAHPSType_ID = @CGCAHPS
order by SurveyValidationProcs_id

