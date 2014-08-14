

select * from
SurveyValidationProcs


begin tran
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_ModeMapping','Validate Mode Mapping',17)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnit ','Survey has at least one sampleunit',15)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ActiveMethodology','Survey has an active methodology',16)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredPopulationFields','Check if fields are part of the Population',18)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_RequiredEncounterFields','Check if fields are part of the Encounter',19)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SkipPatterns','Make sure skip patterns are enforced.',20)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Resurvey','Check the ReSurvey Method',21)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ExclusionType','Check resurvey Exclusion Type',22)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ExclusionMonths','Check resurvey Exclusion months',23)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_Householding','Check for HouseHolding',24)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_AHA_Id','Is AHA_id populated?',25)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_ReportingDate','Check reporting date Field',26)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingMethod','Check the sampling method',27)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SampleUnitTargets','Check that all HHCAHPS sampleunits have targets assigned.',27)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplingAlgorithm','Check the sampling algorithm',28)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_MedicareNumber','Make sure the Medicare number is populated and/or active.',29)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FacilityStatePopulated','Check that FacilityState is populated for the *CAHPS units',30)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplineEncounterDate','Sampling Encounter date is either ServiceDate or DischargeDate',31)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_FormQuestions','All of questions are on the form and in the correct location',32)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_EnglishOrSpanish','Check that only English or Hcahps Spanish is used on survey',33)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_SamplePeriods','Check for more than one sample period',34)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_AddrErrorDQ','Now check for Addr Error DQ rule',35)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_HasDQRule','Has DQ Rules',36)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_HH_CAHPS_DQRule','Check DQ Rule',37)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_H_CAHPS_DQRule','Check DQ rules',38)
INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_PCMH_CAHPS_DQRules','Check DQ rules',39)

/*
commit tran
rollback tran
*/
select * from
SurveyValidationProcs
order by SurveyValidationProcs_id
