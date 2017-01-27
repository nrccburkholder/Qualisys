/*
ATL-1370 MakeTemplateFromSurveys.sql

Chris Burkholder

1/24/2017

Insert into ClientTemplate select from client
Insert into StudyTemplate select from study

etc.

*/
USE [QP_Prod]
GO

declare @user varchar(40) = 'Template Creation'
declare @study_id int = 4955
declare @client_id int
select @client_id = client_id from study where study_id = @study_id

INSERT INTO [RTPhoenix].[Template]([Client_ID],[Study_ID],[Template_NM],[Active],[DateCreated])
     VALUES (-@client_id, -@study_id, 'First Template Piece by Piece', 0, GetDate())

declare @template_id int = scope_identity()

if not exists(select 1 from [RTPhoenix].[CLIENTTemplate] where client_id = -@client_id)
INSERT INTO [RTPhoenix].[CLIENTTemplate]
           ([CLIENT_ID]
           ,[STRCLIENT_NM]
           ,[Active]
           ,[ClientGroup_ID])
SELECT -[CLIENT_ID]
      ,[STRCLIENT_NM]
      ,[Active]
      ,[ClientGroup_ID]
  FROM [dbo].[CLIENT]
where client_id = @client_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Template Created for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[STUDYTemplate]
           ([STUDY_ID]
           ,[CLIENT_ID]
           ,[STRACCOUNTING_CD]
           ,[STRSTUDY_NM]
           ,[STRSTUDY_DSC]
           ,[STRBBS_USERNAME]
           ,[STRBBS_PASSWORD]
           ,[DATCREATE_DT]
           ,[DATCLOSE_DT]
           ,[INTARCHIVE_MONTHS]
           ,[BITSTUDYONGOING]
           ,[INTAP_NUMREPORTS]
           ,[INTAP_CONFINTERVAL]
           ,[INTAP_ERRORMARGIN]
           ,[INTAP_CUTOFFTARGET]
           ,[STROBJECTIVES_TXT]
           ,[DATOBJECTIVESIGNOFF_DT]
           ,[CURBUDGETAMT]
           ,[CURTOTALSPENT]
           ,[STRAP_BELOWQUOTA]
           ,[INTPOPULATIONTABLEID]
           ,[INTENCOUNTERTABLEID]
           ,[INTPROVIDERTABLEID]
           ,[STRREPORTLEVELS]
           ,[STROBJECTIVEDELIVERABLES]
           ,[ADEMPLOYEE_ID]
           ,[BITCLEANADDR]
           ,[DATARCHIVED]
           ,[DATCONTRACTSTART]
           ,[DATCONTRACTEND]
           ,[BITCHECKPHON]
           ,[bitProperCase]
           ,[BITMULTADDR]
           ,[Country_id]
           ,[bitNCOA]
           ,[bitExtractToDatamart]
           ,[Active]
           ,[bitAutosample])
SELECT -[STUDY_ID]
      ,-[CLIENT_ID]
      ,[STRACCOUNTING_CD]
      ,[STRSTUDY_NM]
      ,[STRSTUDY_DSC]
      ,[STRBBS_USERNAME]
      ,[STRBBS_PASSWORD]
      ,[DATCREATE_DT]
      ,[DATCLOSE_DT]
      ,[INTARCHIVE_MONTHS]
      ,[BITSTUDYONGOING]
      ,[INTAP_NUMREPORTS]
      ,[INTAP_CONFINTERVAL]
      ,[INTAP_ERRORMARGIN]
      ,[INTAP_CUTOFFTARGET]
      ,[STROBJECTIVES_TXT]
      ,[DATOBJECTIVESIGNOFF_DT]
      ,[CURBUDGETAMT]
      ,[CURTOTALSPENT]
      ,[STRAP_BELOWQUOTA]
      ,[INTPOPULATIONTABLEID]
      ,[INTENCOUNTERTABLEID]
      ,[INTPROVIDERTABLEID]
      ,[STRREPORTLEVELS]
      ,[STROBJECTIVEDELIVERABLES]
      ,[ADEMPLOYEE_ID]
      ,[BITCLEANADDR]
      ,[DATARCHIVED]
      ,[DATCONTRACTSTART]
      ,[DATCONTRACTEND]
      ,[BITCHECKPHON]
      ,[bitProperCase]
      ,[BITMULTADDR]
      ,[Country_id]
      ,[bitNCOA]
      ,[bitExtractToDatamart]
      ,[Active]
      ,[bitAutosample]
  FROM [dbo].[STUDY]
  where Study_id = @study_id


INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Study Inserted for study_id '+convert(varchar,@study_id), @user, GetDate())


INSERT INTO [RTPhoenix].[METATABLETemplate]
           ([TABLE_ID]
           ,[STRTABLE_NM]
           ,[STRTABLE_DSC]
           ,[STUDY_ID]
           ,[BITUSESADDRESS])
SELECT -[TABLE_ID]
      ,[STRTABLE_NM]
      ,[STRTABLE_DSC]
      ,-[STUDY_ID]
      ,[BITUSESADDRESS]
  FROM [dbo].[METATABLE]
  where Study_id = @Study_id

INSERT INTO [RTPhoenix].[METASTRUCTURETemplate]
           ([TABLE_ID]
           ,[FIELD_ID]
           ,[BITKEYFIELD_FLG]
           ,[BITUSERFIELD_FLG]
           ,[BITMATCHFIELD_FLG]
           ,[BITPOSTEDFIELD_FLG]
           ,[bitPII]
           ,[bitAllowUS])
SELECT -ms.[TABLE_ID]
      ,[FIELD_ID]
      ,[BITKEYFIELD_FLG]
      ,[BITUSERFIELD_FLG]
      ,[BITMATCHFIELD_FLG]
      ,[BITPOSTEDFIELD_FLG]
      ,[bitPII]
      ,[bitAllowUS]
  FROM [dbo].[METASTRUCTURE] ms inner join --row expansion check TODO
		[dbo].[METATABLE] mt on ms.TABLE_ID = mt.TABLE_ID
		where Study_id = @Study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'META* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[SURVEY_DEFTemplate]
           ([SURVEY_ID]
           ,[STUDY_ID]
           ,[STRSURVEY_NM]
           ,[STRSURVEY_DSC]
           ,[INTRESPONSE_RECALC_PERIOD]
           ,[INTRESURVEY_PERIOD]
           ,[BITREPEATINGENCOUNTERS_FLG]
           ,[BITPHYSASSIST_NAME_FLG]
           ,[BITMINOR_EXCEPT_FLG]
           ,[BITNEWBORN_FLG]
           ,[DATSURVEY_START_DT]
           ,[DATSURVEY_END_DT]
           ,[STRMAILFREQ]
           ,[INTSAMPLESINPERIOD]
           ,[STRXMITROUTE]
           ,[BITUSECOMMENTS]
           ,[STRCMNTCOPYTYPE]
           ,[STRCMNTSORT]
           ,[BITSENDCMNTOUT]
           ,[STRSPECIALINSTRUCTIONS]
           ,[STRCMNTMAILFREQ]
           ,[STRCMNTCARRIER]
           ,[STROTHERINSTRUCTIONS]
           ,[STRCMNTTYPING_DBVER]
           ,[BITCMNTTYPING_ONDISK]
           ,[STRCMNT_CMNT]
           ,[BITVALIDATED_FLG]
           ,[DATVALIDATED]
           ,[BITFORMGENRELEASE]
           ,[BITLAYOUTVALID]
           ,[BITDYNAMIC]
           ,[STRCUTOFFRESPONSE_CD]
           ,[cutofftable_id]
           ,[cutofffield_id]
           ,[strHouseholdingType]
           ,[bitDoHousehold]
           ,[vcHouseholding]
           ,[intQuarter]
           ,[weighttype]
           ,[bitmultreturns]
           ,[Priority_Flg]
           ,[bitEnforceSkip]
           ,[strclientfacingName]
           ,[SurveyType_id]
           ,[AHANumber]
           ,[SurveyTypeDef_id]
           ,[ReSurveyMethod_id]
           ,[SamplingAlgorithmID]
           ,[SampleEncounterField_id]
           ,[SampleEncounterTable_id]
           ,[Contract]
           ,[bitPhoneTelematch]
           ,[Active]
           ,[PervasiveMapName]
           ,[ContractedLanguages]
           ,[UseUSPSAddrChangeService]
           ,[IsHandout]
           ,[IsPointInTime])
SELECT -[SURVEY_ID]
      ,-[STUDY_ID]
      ,[STRSURVEY_NM]
      ,[STRSURVEY_DSC]
      ,[INTRESPONSE_RECALC_PERIOD]
      ,[INTRESURVEY_PERIOD]
      ,[BITREPEATINGENCOUNTERS_FLG]
      ,[BITPHYSASSIST_NAME_FLG]
      ,[BITMINOR_EXCEPT_FLG]
      ,[BITNEWBORN_FLG]
      ,[DATSURVEY_START_DT]
      ,[DATSURVEY_END_DT]
      ,[STRMAILFREQ]
      ,[INTSAMPLESINPERIOD]
      ,[STRXMITROUTE]
      ,[BITUSECOMMENTS]
      ,[STRCMNTCOPYTYPE]
      ,[STRCMNTSORT]
      ,[BITSENDCMNTOUT]
      ,[STRSPECIALINSTRUCTIONS]
      ,[STRCMNTMAILFREQ]
      ,[STRCMNTCARRIER]
      ,[STROTHERINSTRUCTIONS]
      ,[STRCMNTTYPING_DBVER]
      ,[BITCMNTTYPING_ONDISK]
      ,[STRCMNT_CMNT]
      ,[BITVALIDATED_FLG]
      ,[DATVALIDATED]
      ,[BITFORMGENRELEASE]
      ,[BITLAYOUTVALID]
      ,[BITDYNAMIC]
      ,[STRCUTOFFRESPONSE_CD]
      ,-[cutofftable_id]
      ,[cutofffield_id]
      ,[strHouseholdingType]
      ,[bitDoHousehold]
      ,[vcHouseholding]
      ,[intQuarter]
      ,[weighttype]
      ,[bitmultreturns]
      ,[Priority_Flg]
      ,[bitEnforceSkip]
      ,[strclientfacingName]
      ,[SurveyType_id]
      ,[AHANumber]
      ,[SurveyTypeDef_id]
      ,[ReSurveyMethod_id]
      ,[SamplingAlgorithmID]
      ,[SampleEncounterField_id]
      ,-[SampleEncounterTable_id]
      ,[Contract]
      ,[bitPhoneTelematch]
      ,[Active]
      ,[PervasiveMapName]
      ,[ContractedLanguages]
      ,[UseUSPSAddrChangeService]
      ,[IsHandout]
      ,[IsPointInTime]
  FROM [dbo].[SURVEY_DEF]
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SurveySubtypeTemplate]
           ([SurveySubtype_id]
           ,[Survey_id]
           ,[Subtype_id])
SELECT -[SurveySubtype_id]
      ,-sst.[Survey_id]
      ,[Subtype_id]
  FROM [dbo].[SurveySubtype] sst inner join
  [dbo].[SURVEY_DEF] sd on sst.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SURVEY* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[MAILINGMETHODOLOGYTemplate]
           ([METHODOLOGY_ID]
           ,[SURVEY_ID]
           ,[BITACTIVEMETHODOLOGY]
           ,[STRMETHODOLOGY_NM]
           ,[DATCREATE_DT]
           ,[StandardMethodologyID])
SELECT -[METHODOLOGY_ID]
      ,-mm.[SURVEY_ID]
      ,[BITACTIVEMETHODOLOGY]
      ,[STRMETHODOLOGY_NM]
      ,[DATCREATE_DT]
      ,[StandardMethodologyID]
  FROM [dbo].[MAILINGMETHODOLOGY] mm inner join
  [dbo].[SURVEY_DEF] sd on mm.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[MAILINGSTEPTemplate]
           ([MAILINGSTEP_ID]
           ,[METHODOLOGY_ID]
           ,[SURVEY_ID]
           ,[INTSEQUENCE]
           ,[SELCOVER_ID]
           ,[BITSURVEYINLINE]
           ,[BITSENDSURVEY]
           ,[INTINTERVALDAYS]
           ,[BITTHANKYOUITEM]
           ,[STRMAILINGSTEP_NM]
           ,[BITFIRSTSURVEY]
           ,[OverRide_Langid]
           ,[MMMailingStep_id]
           ,[MailingStepMethod_id]
           ,[ExpireInDays]
           ,[ExpireFromStep]
           ,[Quota_ID]
           ,[QuotaStopCollectionAt]
           ,[DaysInField]
           ,[NumberOfAttempts]
           ,[WeekDay_Day_Call]
           ,[WeekDay_Eve_Call]
           ,[Sat_Day_Call]
           ,[Sat_Eve_Call]
           ,[Sun_Day_Call]
           ,[Sun_Eve_Call]
           ,[CallBackOtherLang]
           ,[CallbackUsingTTY]
           ,[AcceptPartial]
           ,[SendEmailBlast]
           ,[Vendor_ID]
           ,[ExcludePII])
SELECT -[MAILINGSTEP_ID]
      ,-ms.[METHODOLOGY_ID]
      ,-mm.[SURVEY_ID]
      ,[INTSEQUENCE]
      ,[SELCOVER_ID]
      ,[BITSURVEYINLINE]
      ,[BITSENDSURVEY]
      ,[INTINTERVALDAYS]
      ,[BITTHANKYOUITEM]
      ,[STRMAILINGSTEP_NM]
      ,[BITFIRSTSURVEY]
      ,[OverRide_Langid]
      ,[MMMailingStep_id]
      ,[MailingStepMethod_id]
      ,[ExpireInDays]
      ,[ExpireFromStep]
      ,[Quota_ID]
      ,[QuotaStopCollectionAt]
      ,[DaysInField]
      ,[NumberOfAttempts]
      ,[WeekDay_Day_Call]
      ,[WeekDay_Eve_Call]
      ,[Sat_Day_Call]
      ,[Sat_Eve_Call]
      ,[Sun_Day_Call]
      ,[Sun_Eve_Call]
      ,[CallBackOtherLang]
      ,[CallbackUsingTTY]
      ,[AcceptPartial]
      ,[SendEmailBlast]
      ,[Vendor_ID]
      ,[ExcludePII]
  FROM [dbo].[MAILINGSTEP] ms inner join
  [dbo].[MAILINGMETHODOLOGY] mm on ms.METHODOLOGY_ID = mm.METHODOLOGY_ID join
  [dbo].[SURVEY_DEF] sd on mm.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'MAILING* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[SAMPLEPLANTemplate]
           ([SAMPLEPLAN_ID]
           ,[ROOTSAMPLEUNIT_ID]
           ,[EMPLOYEE_ID]
           ,[SURVEY_ID]
           ,[DATCREATE_DT])
SELECT -[SAMPLEPLAN_ID]
      ,-[ROOTSAMPLEUNIT_ID]
      ,[EMPLOYEE_ID]
      ,-sp.[SURVEY_ID]
      ,[DATCREATE_DT]
  FROM [dbo].[SAMPLEPLAN] sp inner join
  [dbo].[SURVEY_DEF] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SAMPLEUNITTemplate]
           ([SAMPLEUNIT_ID]
           ,[CRITERIASTMT_ID]
           ,[SAMPLEPLAN_ID]
           ,[PARENTSAMPLEUNIT_ID]
           ,[STRSAMPLEUNIT_NM]
           ,[INTTARGETRETURN]
           ,[INTMINCONFIDENCE]
           ,[INTMAXMARGIN]
           ,[NUMINITRESPONSERATE]
           ,[NUMRESPONSERATE]
           ,[REPORTING_HIERARCHY_ID]
           ,[SUFacility_id]
           ,[SUServices]
           ,[bitsuppress]
           ,[bitCHART]
           ,[Priority]
           ,[SampleSelectionType_id]
           ,[DontSampleUnit]
           ,[CAHPSType_id]
           ,[bitLowVolumeUnit])
SELECT -[SAMPLEUNIT_ID]
      ,-[CRITERIASTMT_ID]
      ,-su.[SAMPLEPLAN_ID]
      ,-[PARENTSAMPLEUNIT_ID]
      ,[STRSAMPLEUNIT_NM]
      ,[INTTARGETRETURN]
      ,[INTMINCONFIDENCE]
      ,[INTMAXMARGIN]
      ,[NUMINITRESPONSERATE]
      ,[NUMRESPONSERATE]
      ,[REPORTING_HIERARCHY_ID]
      ,-[SUFacility_id]
      ,[SUServices]
      ,[bitsuppress]
      ,[bitCHART]
      ,[Priority]
      ,[SampleSelectionType_id]
      ,[DontSampleUnit]
      ,[CAHPSType_id]
/*      ,[bitHCAHPS]
      ,[bitHHCAHPS]
      ,[bitMNCM]
      ,[bitACOCAHPS]*/
      ,[bitLowVolumeUnit]
  FROM [dbo].[SAMPLEUNIT] su inner join
  [dbo].[SAMPLEPLAN] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [dbo].[SURVEY_DEF] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SAMPLEUNITSECTIONTemplate]
           ([SAMPLEUNITSECTION_ID]
           ,[SAMPLEUNIT_ID]
           ,[SELQSTNSSECTION]
           ,[SELQSTNSSURVEY_ID])
SELECT -[SAMPLEUNITSECTION_ID]
      ,-sus.[SAMPLEUNIT_ID]
      ,[SELQSTNSSECTION]
      ,-[SELQSTNSSURVEY_ID]
  FROM [dbo].[SAMPLEUNITSECTION] sus inner join
  [dbo].[SAMPLEUNIT] su on su.SAMPLEUNIT_ID = sus.SAMPLEUNIT_ID join
  [dbo].[SAMPLEPLAN] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [dbo].[SURVEY_DEF] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SAMPLE* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[PeriodDefTemplate]
           ([PeriodDef_id]
           ,[Survey_id]
           ,[Employee_id]
           ,[datAdded]
           ,[strPeriodDef_nm]
           ,[intExpectedSamples]
           ,[DaysToSample]
           ,[datExpectedEncStart]
           ,[datExpectedEncEnd]
           ,[strDayOrder]
           ,[MonthWeek]
           ,[SamplingMethod_id])
SELECT -[PeriodDef_id]
      ,-pd.[Survey_id]
      ,[Employee_id]
      ,[datAdded]
      ,[strPeriodDef_nm]
      ,[intExpectedSamples]
      ,[DaysToSample]
      ,[datExpectedEncStart]
      ,[datExpectedEncEnd]
      ,[strDayOrder]
      ,[MonthWeek]
      ,[SamplingMethod_id]
  FROM [dbo].[PeriodDef] pd inner join
  [dbo].[SURVEY_DEF] sd on pd.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[PeriodDatesTemplate]
           ([PeriodDef_id]
           ,[SampleNumber]
           ,[datScheduledSample_dt]
           ,[SampleSet_id]
           ,[datSampleCreate_dt])
SELECT -pdt.[PeriodDef_id]
      ,[SampleNumber]
      ,[datScheduledSample_dt]
      ,[SampleSet_id]
      ,[datSampleCreate_dt]
  FROM [dbo].[PeriodDates] pdt inner join
  [dbo].[PeriodDef] pdf on pdt.PeriodDef_id = pdf.PeriodDef_id inner join
  [dbo].[SURVEY_DEF] sd on pdf.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Period* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[BUSINESSRULETemplate]
           ([BUSINESSRULE_ID]
           ,[SURVEY_ID]
           ,[STUDY_ID]
           ,[CRITERIASTMT_ID]
           ,[BUSRULE_CD])
SELECT -[BUSINESSRULE_ID]
      ,-[SURVEY_ID]
      ,-[STUDY_ID]
      ,-[CRITERIASTMT_ID]
      ,[BUSRULE_CD]
  FROM [dbo].[BUSINESSRULE]
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[HOUSEHOLDRULETemplate]
           ([HOUSEHOLDRULE_ID]
           ,[TABLE_ID]
           ,[FIELD_ID]
           ,[SURVEY_ID])
SELECT -[HOUSEHOLDRULE_ID]
      ,-[TABLE_ID]
      ,[FIELD_ID]
      ,-hhr.[SURVEY_ID]
  FROM [dbo].[HOUSEHOLDRULE] hhr inner join
  [dbo].[SURVEY_DEF] sd on hhr.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'HOUSEHOLDRULE/BUSINESSRULE template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[CRITERIASTMTTemplate]
           ([CRITERIASTMT_ID]
           ,[STUDY_ID]
           ,[STRCRITERIASTMT_NM]
           ,[strCriteriaString])
SELECT -[CRITERIASTMT_ID]
      ,-[STUDY_ID]
      ,[STRCRITERIASTMT_NM]
      ,[strCriteriaString]
  FROM [dbo].[CRITERIASTMT]
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[CRITERIACLAUSETemplate]
           ([CRITERIACLAUSE_ID]
           ,[CRITERIAPHRASE_ID]
           ,[CRITERIASTMT_ID]
           ,[TABLE_ID]
           ,[FIELD_ID]
           ,[INTOPERATOR]
           ,[STRLOWVALUE]
           ,[STRHIGHVALUE])
SELECT -[CRITERIACLAUSE_ID]
      ,[CRITERIAPHRASE_ID]
      ,-cc.[CRITERIASTMT_ID]
      ,-[TABLE_ID]
      ,[FIELD_ID]
      ,[INTOPERATOR]
      ,[STRLOWVALUE]
      ,[STRHIGHVALUE]
  FROM [dbo].[CRITERIACLAUSE] cc inner join
  [dbo].[CRITERIASTMT] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[CRITERIAINLISTTemplate]
           ([CRITERIAINLIST_ID]
           ,[CRITERIACLAUSE_ID]
           ,[STRLISTVALUE])
SELECT -[CRITERIAINLIST_ID]
      ,-ci.[CRITERIACLAUSE_ID]
      ,[STRLISTVALUE]
  FROM [dbo].[CRITERIAINLIST] ci inner join
  [dbo].[CRITERIACLAUSE] cc on ci.CRITERIACLAUSE_ID = cc.CRITERIACLAUSE_ID inner join
  [dbo].[CRITERIASTMT] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'CRITERIA* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[MedicareLookupTemplate]
           ([MedicareNumber]
           ,[MedicareName]
           ,[Active]
           ,[MedicarePropCalcType_ID]
           ,[EstAnnualVolume]
           ,[EstRespRate]
           ,[EstIneligibleRate]
           ,[SwitchToCalcDate]
           ,[AnnualReturnTarget]
           ,[SamplingLocked]
           ,[ProportionChangeThreshold]
           ,[CensusForced]
           ,[PENumber]
           ,[SystematicAnnualReturnTarget]
           ,[SystematicEstRespRate]
           ,[SystematicSwitchToCalcDate]
           ,[NonSubmitting])
SELECT '-' + ml.[MedicareNumber]
      ,[MedicareName]
      ,ml.[Active]
      ,[MedicarePropCalcType_ID]
      ,[EstAnnualVolume]
      ,[EstRespRate]
      ,[EstIneligibleRate]
      ,[SwitchToCalcDate]
      ,[AnnualReturnTarget]
      ,[SamplingLocked]
      ,[ProportionChangeThreshold]
      ,[CensusForced]
      ,[PENumber]
      ,[SystematicAnnualReturnTarget]
      ,[SystematicEstRespRate]
      ,[SystematicSwitchToCalcDate]
      ,[NonSubmitting]
  FROM [dbo].[MedicareLookup] ml inner join
  [dbo].[SUFacility] suf on ml.medicarenumber = suf.medicarenumber inner join
  [dbo].[SAMPLEUNIT] su on suf.SUFacility_id = su.SUFacility_id inner join
  [dbo].[SAMPLEPLAN] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [dbo].[SURVEY_DEF] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id
  
  INSERT INTO [RTPhoenix].[SUFacilityTemplate]
           ([SUFacility_id]
           ,[strFacility_nm]
           ,[City]
           ,[State]
           ,[Country]
           ,[Region_id]
           ,[AdmitNumber]
           ,[BedSize]
           ,[bitPeds]
           ,[bitTeaching]
           ,[bitTrauma]
           ,[bitReligious]
           ,[bitGovernment]
           ,[bitRural]
           ,[bitForProfit]
           ,[bitRehab]
           ,[bitCancerCenter]
           ,[bitPicker]
           ,[bitFreeStanding]
           ,[AHA_id]
           ,[MedicareNumber])
SELECT -suf.[SUFacility_id]
      ,[strFacility_nm]
      ,[City]
      ,[State]
      ,[Country]
      ,[Region_id]
      ,[AdmitNumber]
      ,[BedSize]
      ,[bitPeds]
      ,[bitTeaching]
      ,[bitTrauma]
      ,[bitReligious]
      ,[bitGovernment]
      ,[bitRural]
      ,[bitForProfit]
      ,[bitRehab]
      ,[bitCancerCenter]
      ,[bitPicker]
      ,[bitFreeStanding]
      ,[AHA_id]
      ,'-'+[MedicareNumber]
  FROM [dbo].[SUFacility] suf inner join
  [dbo].[SAMPLEUNIT] su on suf.SUFacility_id = su.SUFacility_id inner join
  [dbo].[SAMPLEPLAN] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [dbo].[SURVEY_DEF] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SUFacility/MedicareLookup template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[Sel_CoverTemplate]
           ([SelCover_id]
           ,[Survey_id]
           ,[PageType]
           ,[Description]
           ,[Integrated]
           ,[bitLetterHead])
SELECT [SelCover_id]
      ,-sc.[Survey_id]
      ,[PageType]
      ,[Description]
      ,[Integrated]
      ,[bitLetterHead]
  FROM [dbo].[Sel_Cover] sc inner join
  [dbo].[SURVEY_DEF] sd on sc.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SEL_LOGOTemplate]
           ([QPC_ID]
           ,[COVERID]
           ,[SURVEY_ID]
           ,[DESCRIPTION]
           ,[X]
           ,[Y]
           ,[WIDTH]
           ,[HEIGHT]
           ,[SCALING]
           ,[BITMAP]
           ,[VISIBLE])
SELECT [QPC_ID]
      ,[COVERID]
      ,-sl.[SURVEY_ID]
      ,[DESCRIPTION]
      ,[X]
      ,[Y]
      ,[WIDTH]
      ,[HEIGHT]
      ,[SCALING]
      ,[BITMAP]
      ,[VISIBLE]
  FROM [dbo].[SEL_LOGO] sl inner join
  [dbo].[SURVEY_DEF] sd on sl.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SEL_PCLTemplate]
           ([QPC_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[COVERID]
           ,[DESCRIPTION]
           ,[X]
           ,[Y]
           ,[WIDTH]
           ,[HEIGHT]
           ,[PCLSTREAM]
           ,[KNOWNDIMENSIONS])
SELECT [QPC_ID]
      ,-sp.[SURVEY_ID]
      ,[LANGUAGE]
      ,[COVERID]
      ,[DESCRIPTION]
      ,[X]
      ,[Y]
      ,[WIDTH]
      ,[HEIGHT]
      ,[PCLSTREAM]
      ,[KNOWNDIMENSIONS]
  FROM [dbo].[SEL_PCL] sp inner join
  [dbo].[SURVEY_DEF] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SEL_QSTNSTemplate]
           ([SELQSTNS_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[SCALEID]
           ,[SECTION_ID]
           ,[LABEL]
           ,[PLUSMINUS]
           ,[SUBSECTION]
           ,[ITEM]
           ,[SUBTYPE]
           ,[WIDTH]
           ,[HEIGHT]
           ,[RICHTEXT]
           ,[SCALEPOS]
           ,[SCALEFLIPPED]
           ,[NUMMARKCOUNT]
           ,[BITMEANABLE]
           ,[NUMBUBBLECOUNT]
           ,[QSTNCORE]
           ,[BITLANGREVIEW]
           ,[strFullQuestion])
SELECT [SELQSTNS_ID]
      ,-sq.[SURVEY_ID]
      ,[LANGUAGE]
      ,[SCALEID]
      ,[SECTION_ID]
      ,[LABEL]
      ,[PLUSMINUS]
      ,[SUBSECTION]
      ,[ITEM]
      ,[SUBTYPE]
      ,[WIDTH]
      ,[HEIGHT]
      ,[RICHTEXT]
      ,[SCALEPOS]
      ,[SCALEFLIPPED]
      ,[NUMMARKCOUNT]
      ,[BITMEANABLE]
      ,[NUMBUBBLECOUNT]
      ,[QSTNCORE]
      ,[BITLANGREVIEW]
      ,[strFullQuestion]
  FROM [dbo].[SEL_QSTNS] sq inner join
  [dbo].[SURVEY_DEF] sd on sq.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SEL_SCLSTemplate]
           ([SURVEY_ID]
           ,[QPC_ID]
           ,[ITEM]
           ,[LANGUAGE]
           ,[VAL]
           ,[LABEL]
           ,[RICHTEXT]
           ,[MISSING]
           ,[CHARSET]
           ,[SCALEORDER]
           ,[INTRESPTYPE])
SELECT -ss.[SURVEY_ID]
      ,[QPC_ID]
      ,[ITEM]
      ,[LANGUAGE]
      ,[VAL]
      ,[LABEL]
      ,[RICHTEXT]
      ,[MISSING]
      ,[CHARSET]
      ,[SCALEORDER]
      ,[INTRESPTYPE]
  FROM [dbo].[SEL_SCLS] ss inner join
  [dbo].[SURVEY_DEF] sd on ss.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[SEL_SKIPTemplate]
           ([SURVEY_ID]
           ,[SELQSTNS_ID]
           ,[SELSCLS_ID]
           ,[SCALEITEM]
           ,[NUMSKIP]
           ,[NUMSKIPTYPE])
SELECT -ss.[SURVEY_ID]
      ,[SELQSTNS_ID]
      ,[SELSCLS_ID]
      ,[SCALEITEM]
      ,[NUMSKIP]
      ,[NUMSKIPTYPE]
  FROM [dbo].[SEL_SKIP] ss inner join
  [dbo].[SURVEY_DEF] sd on ss.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SEL* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[SEL_TEXTBOXTemplate]
           ([QPC_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[COVERID]
           ,[X]
           ,[Y]
           ,[WIDTH]
           ,[HEIGHT]
           ,[RICHTEXT]
           ,[BORDER]
           ,[SHADING]
           ,[BITLANGREVIEW]
           ,[LABEL])
SELECT [QPC_ID]
      ,-st.[SURVEY_ID]
      ,[LANGUAGE]
      ,[COVERID]
      ,[X]
      ,[Y]
      ,[WIDTH]
      ,[HEIGHT]
      ,[RICHTEXT]
      ,[BORDER]
      ,[SHADING]
      ,[BITLANGREVIEW]
      ,[LABEL]
  FROM [dbo].[SEL_TEXTBOX] st inner join
  [dbo].[SURVEY_DEF] sd on st.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[ModeSectionMappingTemplate]
           ([ID]
           ,[Survey_Id]
           ,[MailingStepMethod_Id]
           ,[MailingStepMethod_nm]
           ,[Section_Id]
           ,[SectionLabel])
SELECT [ID]
      ,-msmt.[Survey_Id]
      ,-[MailingStepMethod_Id]
      ,[MailingStepMethod_nm]
      ,[Section_Id]
      ,[SectionLabel]
  FROM [dbo].[ModeSectionMapping] msmt inner join
  [dbo].[SURVEY_DEF] sd on msmt.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TAGFIELDTemplate]
           ([TAGFIELD_ID]
           ,[TAG_ID]
           ,[TABLE_ID]
           ,[FIELD_ID]
           ,[STUDY_ID]
           ,[REPLACEFIELD_FLG]
           ,[STRREPLACELITERAL])
SELECT -[TAGFIELD_ID]
      ,[TAG_ID]
      ,-tf.[TABLE_ID]
      ,[FIELD_ID]
      ,-tf.[STUDY_ID]
      ,[REPLACEFIELD_FLG]
      ,[STRREPLACELITERAL]
  FROM [dbo].[TAGFIELD] tf inner join
  [dbo].[METATABLE] mt on tf.table_id = mt.table_id
  where tf.study_id = @study_id

INSERT INTO [RTPhoenix].[CODEQSTNSTemplate]
           ([SELQSTNS_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[CODE]
           ,[INTSTARTPOS]
           ,[INTLENGTH])
SELECT [SELQSTNS_ID]
      ,-cq.[SURVEY_ID]
      ,[LANGUAGE]
      ,[CODE]
      ,[INTSTARTPOS]
      ,[INTLENGTH]
  FROM [dbo].[CODEQSTNS] cq inner join
  [dbo].[SURVEY_DEF] sd on cq.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[CODESCLSTemplate]
           ([SURVEY_ID]
           ,[QPC_ID]
           ,[ITEM]
           ,[LANGUAGE]
           ,[CODE]
           ,[INTSTARTPOS]
           ,[INTLENGTH])
SELECT -cs.[SURVEY_ID]
      ,[QPC_ID]
      ,[ITEM]
      ,[LANGUAGE]
      ,[CODE]
      ,[INTSTARTPOS]
      ,[INTLENGTH]
  FROM [dbo].[CODESCLS] cs inner join
  [dbo].[SURVEY_DEF] sd on cs.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[CODETXTBOXTemplate]
           ([QPC_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[CODE]
           ,[INTSTARTPOS]
           ,[INTLENGTH])
SELECT [QPC_ID]
      ,-ct.[SURVEY_ID]
      ,[LANGUAGE]
      ,[CODE]
      ,[INTSTARTPOS]
      ,[INTLENGTH]
  FROM [dbo].[CODETXTBOX] ct inner join
  [dbo].[SURVEY_DEF] sd on ct.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'CODE* template tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[STUDY_EMPLOYEETemplate]
           ([EMPLOYEE_ID]
           ,[STUDY_ID])
SELECT [EMPLOYEE_ID]
      ,-[STUDY_ID]
  FROM [dbo].[STUDY_EMPLOYEE] 
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Study_Employee template table exported for study_id '+convert(varchar,@study_id), @user, GetDate())

/**********************
******* QP_LOAD *******
**********************/

--declare @study_id int = 4955 declare @client_id int select @client_id = client_id from study where study_id = @study_id

INSERT INTO [RTPhoenix].[PackageQLTemplate]
           ([Package_id]
           ,[intVersion]
           ,[strPackage_nm]
           ,[Client_id]
           ,[Study_id]
           ,[intTeamNumber]
           ,[strLogin_nm]
           ,[datLastModified]
           ,[bitArchive]
           ,[datArchive]
           ,[FileType_id]
           ,[FileTypeSettings]
           ,[SignOffBy_id]
           ,[datCreated]
           ,[strPackageFriendly_nm]
           ,[bitActive]
           ,[bitDeleted]
           ,[OwnerMember_id])
SELECT -[Package_id]
      ,[intVersion]
      ,[strPackage_nm]
      ,-[Client_id]
      ,-[Study_id]
      ,[intTeamNumber]
      ,[strLogin_nm]
      ,[datLastModified]
      ,[bitArchive]
      ,[datArchive]
      ,[FileType_id]
      ,[FileTypeSettings]
      ,[SignOffBy_id]
      ,[datCreated]
      ,[strPackageFriendly_nm]
      ,[bitActive]
      ,[bitDeleted]
      ,[OwnerMember_id]
  FROM [QLoader].[QP_Load].[dbo].[Package]
  where study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'QLoader Package table exported for study_id '+convert(varchar,@study_id), @user, GetDate())

INSERT INTO [RTPhoenix].[DestinationQLTemplate]
           ([Destination_id]
           ,[Package_id]
           ,[intVersion]
           ,[Table_id]
           ,[Field_id]
           ,[Formula]
           ,[bitNULLCount]
           ,[intFreqLimit]
           ,[Sources])
SELECT -[Destination_id]
      ,-d.[Package_id]
      ,d.[intVersion]
      ,-[Table_id]
      ,[Field_id]
      ,[Formula]
      ,[bitNULLCount]
      ,[intFreqLimit]
      ,[Sources]
  FROM [QLoader].[QP_Load].[dbo].[Destination] d inner join 
	[QLoader].[QP_Load].[dbo].[Package] p on d.package_id = p.package_id
  where study_id = @study_id

INSERT INTO [RTPhoenix].[SourceQLTemplate]
           ([Source_id]
           ,[Package_id]
           ,[intVersion]
           ,[strName]
           ,[strAlias]
           ,[intLength]
           ,[DataType_id]
           ,[Ordinal])
SELECT -[Source_id]
      ,-s.[Package_id]
      ,s.[intVersion]
      ,[strName]
      ,[strAlias]
      ,[intLength]
      ,[DataType_id]
      ,[Ordinal]
  FROM [QLoader].[QP_Load].[dbo].[Source] s inner join
	[QLoader].[QP_Load].[dbo].[Package] p on s.package_id = p.package_id
  where study_id = @study_id

INSERT INTO [RTPhoenix].[DTSMappingQLTemplate]
           ([intVersion]
           ,[Source_id]
           ,[Destination_id]
           ,[Package_id])
SELECT dtsm.[intVersion]
      ,-[Source_id]
      ,-[Destination_id]
      ,-dtsm.[Package_id]
  FROM [QLoader].[QP_Load].[dbo].[DTSMapping] dtsm inner join
	[QLoader].[QP_Load].[dbo].[Package] p on dtsm.package_id = p.package_id
  where study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'QLoader Source/Destination/DTSMapping tables exported for study_id '+convert(varchar,@study_id), @user, GetDate())
