
declare @svpid int
declare @intOrder int


begin tran

-- delete the previous single cahps validation proc from the list
DELETE [dbo].[SurveyValidationProcs]
WHERE ProcedureName = 'SV_ALL_CAHPS'


DELETE [dbo].[SurveyValidationProcs]
WHERE ProcedureName = 'SV_ModeMapping'

DELETE [dbo].[SurveyValidationProcs]
WHERE ProcedureName like 'SV_CAHPS_%'

truncate table SurveyValidationProcsBySurveyType

Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

-- now insert the discrete validation procs
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_ModeMapping','Validate Mode Mapping',@intOrder)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnit ','Survey has at least one sampleunit',@intOrder)
set @svpid=scope_identity()	
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,4)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ActiveMethodology','Survey has an active methodology',@intOrder)
set @svpid=scope_identity()	
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,4)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredPopulationFields','Check if fields are part of the Population',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredEncounterFields','Check if fields are part of the Encounter',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SkipPatterns','Make sure skip patterns are enforced.',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,4)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Resurvey','Check the ReSurvey Method',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Householding','Check for HouseHolding',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_AHA_Id','Is AHA_id populated?',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ReportingDate','Check reporting date Field',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingMethod','Check the sampling method',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnitTarget','Check that all HHCAHPS sampleunits have targets assigned.',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingAlgorithm','Check the sampling algorithm',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,8)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_MedicareNumber','Make sure the Medicare number is populated and/or active.',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FacilityStatePopulated','Check that FacilityState is populated for the *CAHPS units',30)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingEncounterDate','Sampling Encounter date is either ServiceDate or DischargeDate',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FormQuestions','All of questions are on the form and in the correct location',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_EnglishOrSpanish','Check that only English or Hcahps Spanish is used on survey',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplePeriods','Check for more than one sample period',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_AddrErrorDQ','Now check for Addr Error DQ rule',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_HasDQRule','Has DQ Rules',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,10)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_HH_CAHPS_DQRules','Check DQ Rule',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,3)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_H_CAHPS_DQRules','Check DQ rules',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,2)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_PCMH_CAHPS_DQRules','Check DQ rules',@intOrder)
set @svpid=scope_identity()
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,4,9)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


/*
commit tran
rollback tran
*/
select * from
SurveyValidationProcs
order by SurveyValidationProcs_id

select * from
SurveyValidationProcsBySurveyType
order by SurveyValidationProcs_id