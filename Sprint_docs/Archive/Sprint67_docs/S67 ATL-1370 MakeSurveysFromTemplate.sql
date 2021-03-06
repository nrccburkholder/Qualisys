/*
ATL-1370 MakeSurveysFromTemplate.sql

Chris Burkholder

1/26/2017

Insert into client select from ClientTemplate 
Insert into study select from StudyTemplate

etc.

*/
USE [QP_Prod]
GO

	  declare @TemplateJob_ID int
      declare @Template_ID int
      declare @CAHPSSurveyType_ID int
      declare @CAHPSSurveySubtype_ID int
      declare @RTSurveyType_ID int
      declare @RTSurveySubtype_ID int
      declare @TargetClient_ID int
      declare @TargetStudy_ID int
      declare @Client_nm varchar(40)
      declare @Study_nm varchar(10)
      declare @Study_desc varchar(255)
	  declare @MedicareNumber varchar(20)
      declare @LoggedBy varchar(40)
      declare @LoggedAt datetime
      declare @CompletedNotes varchar(255)
      declare @CompletedAt datetime

SELECT TOP 1 
	  @TemplateJob_ID = [TemplateJob_ID]
      ,@Template_ID = [Template_ID]
      ,@CAHPSSurveyType_ID = [CAHPSSurveyType_ID]
      ,@CAHPSSurveySubtype_ID = [CAHPSSurveySubtype_ID]
      ,@RTSurveyType_ID = [RTSurveyType_ID]
      ,@RTSurveySubtype_ID = [RTSurveySubtype_ID]
      ,@TargetClient_ID = [TargetClient_ID]
      ,@TargetStudy_id = [TargetStudy_ID]
      ,@Client_nm = [Client_nm]
      ,@Study_nm = [Study_nm]
      ,@Study_desc = [Study_desc]
	  ,@MedicareNumber = [MedicareNumber]
      ,@LoggedBy = [LoggedBy]
      ,@LoggedAt = [LoggedAt]
      ,@CompletedNotes = [CompletedNotes]
      ,@CompletedAt = [CompletedAt]
  FROM [RTPhoenix].[TemplateJob]
  where CompletedAt is null

if @TemplateJob_ID is null
	RETURN

declare @template_NM varchar(40)
declare @user varchar(40) = @LoggedBy
declare @study_id int 
declare @client_id int

--if @Template_ID is null
--begin
	--TODO: Try to resolve which Template by matching CAHPSSurveyType_ID,
	--CAHPSSurveySubtype_ID, RTSurveyType_ID and RTSurveySubtype_ID against 
	--active templates
--end

SELECT @Template_ID = [Template_ID]
      ,@client_id = [Client_ID]
      ,@study_id = [Study_ID]
      ,@Template_NM = [Template_NM]
  FROM [RTPhoenix].[Template]
  where Template_ID = @Template_ID
	and [Active] = 1

if @study_id is null 
begin
	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, 'Template ID missing or not Active for TemplateJob_ID: '+convert(varchar,@TemplateJob_id), @user, GetDate())
		
	RETURN
end

if not exists(select 1 from [dbo].[client] where client_id = @TargetClient_ID)
begin
	INSERT INTO [dbo].[CLIENT]
			   ([STRCLIENT_NM]
			   ,[Active]
			   ,[ClientGroup_ID])
	SELECT Isnull(@Client_nm,[STRCLIENT_NM])
		  ,[Active]
		  ,[ClientGroup_ID]
	  FROM [RTPhoenix].[CLIENTTemplate]

	set @TargetClient_ID = scope_identity()
end

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Template to Export Found: '+convert(varchar,@Template_id), @user, GetDate())

INSERT INTO [dbo].[STUDY]
           ([CLIENT_ID]
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
SELECT @TargetClient_ID
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
  FROM [RTPhoenix].[STUDYTemplate]
  where Study_id = @study_id

SET @TargetStudy_ID = ident_current('dbo.study')

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Study Table Inserted from Template for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[METATABLE]
           ([STRTABLE_NM]
           ,[STRTABLE_DSC]
           ,[STUDY_ID]
           ,[BITUSESADDRESS])
SELECT [STRTABLE_NM]
      ,[STRTABLE_DSC]
      ,@TargetStudy_ID
      ,[BITUSESADDRESS]
  FROM [RTPhoenix].[METATABLETemplate]
  where Study_id = @Study_id

INSERT INTO [dbo].[METASTRUCTURE]
           ([TABLE_ID]
           ,[FIELD_ID]
           ,[BITKEYFIELD_FLG]
           ,[BITUSERFIELD_FLG]
           ,[BITMATCHFIELD_FLG]
           ,[BITPOSTEDFIELD_FLG]
           ,[bitPII]
           ,[bitAllowUS])
SELECT db0.[TABLE_ID]
      ,[FIELD_ID]
      ,[BITKEYFIELD_FLG]
      ,[BITUSERFIELD_FLG]
      ,[BITMATCHFIELD_FLG]
      ,[BITPOSTEDFIELD_FLG]
      ,[bitPII]
      ,[bitAllowUS]
  FROM [RTPhoenix].[METASTRUCTURETemplate] ms inner join
		[RTPhoenix].[METATABLETemplate] mt on ms.TABLE_ID = mt.TABLE_ID inner join
		[dbo].[METATABLE] db0 on mt.strtable_nm = db0.strtable_nm 
				and db0.study_id = @TargetStudy_id and mt.study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'META* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[SURVEY_DEF]
           ([STUDY_ID]
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
SELECT @TargetStudy_Id
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
      ,db0.[TABLE_ID]
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
      ,db02.[TABLE_ID]
      ,[Contract]
      ,[bitPhoneTelematch]
      ,[Active]
      ,[PervasiveMapName]
      ,[ContractedLanguages]
      ,[UseUSPSAddrChangeService]
      ,[IsHandout]
      ,[IsPointInTime]
  FROM [RTPhoenix].[SURVEY_DEFTemplate] sd inner join
		[RTPhoenix].[METATABLETemplate] mt on sd.CutOffTABLE_ID = mt.TABLE_ID inner join
		[dbo].[METATABLE] db0 on mt.strtable_nm = db0.strtable_nm and
					db0.study_id = @TargetStudy_id and mt.study_id = @study_id
				inner join
		[RTPhoenix].[METATABLETemplate] mt2 on sd.SampleEncounterTABLE_ID = mt2.TABLE_ID inner join
		[dbo].[METATABLE] db02 on mt2.strtable_nm = db02.strtable_nm and 
					db02.study_id = @TargetStudy_id and mt2.study_id = @study_id

INSERT INTO [dbo].[SurveySubtype]
           ([Survey_id]
           ,[Subtype_id]) --declare @study_id int = -4955 declare @TargetStudy_id int = 4958
SELECT db0.[Survey_id]
      ,sst.[Subtype_id]
  FROM [RTPhoenix].[SurveySubtypeTemplate] sst inner join
		[RTPhoenix].[SURVEY_DEFTemplate] sd on sst.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SURVEY* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[MAILINGMETHODOLOGY]
           ([SURVEY_ID]
           ,[BITACTIVEMETHODOLOGY]
           ,[STRMETHODOLOGY_NM]
           ,[DATCREATE_DT]
           ,[StandardMethodologyID]) --declare @study_id int = -4955 declare @TargetStudy_id int = 4958
SELECT db0.[SURVEY_ID]
      ,mm.[BITACTIVEMETHODOLOGY]
      ,mm.[STRMETHODOLOGY_NM]
      ,mm.[DATCREATE_DT]
      ,mm.[StandardMethodologyID]
  FROM [RTPhoenix].[MAILINGMETHODOLOGYTemplate] mm inner join
		[RTPhoenix].[SURVEY_DEFTemplate] sd on mm.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

declare @ExpireFromStepStub int 
select @ExpireFromStepStub = ident_current('dbo.mailingstep') + 1

INSERT INTO [dbo].[MAILINGSTEP]
           ([METHODOLOGY_ID]
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
SELECT db01.[METHODOLOGY_ID]
      ,db0.[SURVEY_ID]
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
      ,@ExpireFromStepStub --[ExpireFromStep]
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
  FROM [RTPhoenix].[MAILINGSTEPTemplate] ms inner join
        [RTPhoenix].[MAILINGMETHODOLOGYTemplate] mm on ms.METHODOLOGY_ID = mm.METHODOLOGY_ID inner join
		[RTPhoenix].[SURVEY_DEFTemplate] sd on mm.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
		[dbo].[MAILINGMETHODOLOGY] db01 on mm.STRMETHODOLOGY_NM = db01.STRMETHODOLOGY_NM and
					db01.SURVEY_ID = db0.survey_id

update ms set ExpireFromStep = ms2.mailingstep_id 
--select ms.ExpireFromStep, ms2.ExpireFromStep 
from [dbo].[mailingstep] ms inner join [dbo].[mailingstep] ms2 on 
	ms.survey_id = ms2.survey_id and ms2.intsequence = 1
	where ms.MAILINGSTEP_ID > @ExpireFromStepStub

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'MAILING* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[SAMPLEPLAN]
           ([ROOTSAMPLEUNIT_ID]
           ,[EMPLOYEE_ID]
           ,[SURVEY_ID]
           ,[DATCREATE_DT])
SELECT -[ROOTSAMPLEUNIT_ID] --fill in later, negate back to original positive ID...
      ,[EMPLOYEE_ID]
      ,db0.[SURVEY_ID]
      ,[DATCREATE_DT]
  FROM [RTPhoenix].[SAMPLEPLANTemplate] sp inner join
		[RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[CRITERIASTMT]
           ([STUDY_ID]
           ,[STRCRITERIASTMT_NM]
           ,[strCriteriaString])
SELECT @TargetStudy_id
      ,[STRCRITERIASTMT_NM]
      ,[strCriteriaString]
  FROM [RTPhoenix].[CRITERIASTMTTemplate]
  where Study_id = @study_id

INSERT INTO [dbo].[SAMPLEUNIT]
           ([CRITERIASTMT_ID]
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
SELECT -[CRITERIASTMT_ID] --fill in later, negate back to original positive ID...
      ,db02.[SAMPLEPLAN_ID]
      ,-[PARENTSAMPLEUNIT_ID] --fill in later, negate back to original positive ID...
      ,[STRSAMPLEUNIT_NM]
      ,[INTTARGETRETURN]
      ,[INTMINCONFIDENCE]
      ,[INTMAXMARGIN]
      ,[NUMINITRESPONSERATE]
      ,[NUMRESPONSERATE]
      ,[REPORTING_HIERARCHY_ID]
      ,db04.[SUFacility_id] 
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
  FROM [RTPhoenix].[SAMPLEUNITTemplate] su inner join
  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
		[dbo].[SamplePlan] db02 on db02.DATCREATE_DT = sp.DATCREATE_DT and 
					db02.survey_id = db0.survey_id
				left join
		[dbo].[SUFacility] db04 on su.SUFacility_id <> 0 and 
					db04.MedicareNumber = @MedicareNumber

--TODO backfill SAMPLEPLAN.ROOTSAMPLEUNIT_ID

--TODO backfill sampleunit.CRITERIASTMT_ID

--TODO backfill SAMPLEUNIT.PARENTSAMPLEUNIT_ID

INSERT INTO [dbo].[SAMPLEUNITSECTION] 
           ([SAMPLEUNIT_ID]
           ,[SELQSTNSSECTION]
           ,[SELQSTNSSURVEY_ID]) 
SELECT db03.[SAMPLEUNIT_ID]
      ,[SELQSTNSSECTION]
      ,-[SELQSTNSSURVEY_ID] --trying to leave the negative id in temporarily...
  FROM [RTPhoenix].[SAMPLEUNITSECTIONTemplate] sus inner join
  [RTPhoenix].[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = sus.SAMPLEUNIT_ID join
  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
		[dbo].[SamplePlan] db02 on db02.DATCREATE_DT = sp.DATCREATE_DT and 
					db02.survey_id = db0.survey_id
				inner join
		[dbo].[SampleUnit] db03 on su.strsampleunit_nm = db03.strsampleunit_nm and
					db03.SAMPLEPLAN_ID = db02.SAMPLEPLAN_ID

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SAMPLE* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[PeriodDef]
           ([Survey_id]
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
SELECT db0.[Survey_id]
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
  FROM [RTPhoenix].[PeriodDefTemplate] pd inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on pd.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[PeriodDates]
           ([PeriodDef_id]
           ,[SampleNumber]
           ,[datScheduledSample_dt]
           ,[SampleSet_id]
           ,[datSampleCreate_dt])
SELECT db01.[PeriodDef_id]
      ,[SampleNumber]
      ,[datScheduledSample_dt]
      ,[SampleSet_id]
      ,[datSampleCreate_dt]
  FROM [RTPhoenix].[PeriodDatesTemplate] pdt inner join
  [RTPhoenix].[PeriodDefTemplate] pdf on pdt.PeriodDef_id = pdf.PeriodDef_id inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on pdf.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
		[dbo].[PeriodDef] db01 on db01.strPeriodDef_nm = pdf.strPeriodDef_nm and
					db01.Survey_id = db0.Survey_id and pdf.Survey_id = sd.Survey_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Period* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[BUSINESSRULE]
           ([SURVEY_ID]
           ,[STUDY_ID]
           ,[CRITERIASTMT_ID]
           ,[BUSRULE_CD])
SELECT db0.[SURVEY_ID]
      ,@TargetStudy_ID
      ,db01.[CRITERIASTMT_ID]
      ,[BUSRULE_CD]
  FROM [RTPhoenix].[BUSINESSRULETemplate] br inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on br.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
  [RTPhoenix].[CriteriaStmtTemplate] cst on cst.CRITERIASTMT_ID = br.CRITERIASTMT_ID inner join
		[dbo].[CriteriaStmt] db01 on cst.STRCRITERIASTMT_NM = db01.STRCRITERIASTMT_NM and
					db01.study_id = @TargetStudy_id and cst.study_id = @study_id 

INSERT INTO [dbo].[HOUSEHOLDRULE] 
           ([TABLE_ID]
           ,[FIELD_ID]
           ,[SURVEY_ID])
SELECT db01.[TABLE_ID]
      ,[FIELD_ID]
      ,db0.[SURVEY_ID]
  FROM [RTPhoenix].[HOUSEHOLDRULETemplate] hhr inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on hhr.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
  [RTPhoenix].[METATABLETemplate] mt on hhr.TABLE_ID = mt.TABLE_ID inner join
		[dbo].[METATABLE] db01 on mt.strtable_nm = db01.strtable_nm and
					db01.study_id = @TargetStudy_id and mt.study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'HOUSEHOLDRULE/BUSINESSRULE template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[CRITERIACLAUSE] --TODO: Narrow down join
           ([CRITERIAPHRASE_ID]
           ,[CRITERIASTMT_ID]
           ,[TABLE_ID]
           ,[FIELD_ID]
           ,[INTOPERATOR]
           ,[STRLOWVALUE]
           ,[STRHIGHVALUE])
SELECT cc.[CRITERIAPHRASE_ID]
      ,db01.[CRITERIASTMT_ID]
      ,db0.[TABLE_ID]
      ,cc.[FIELD_ID]
      ,cc.[INTOPERATOR]
      ,cc.[STRLOWVALUE]
      ,cc.[STRHIGHVALUE]
  FROM [RTPhoenix].[CRITERIACLAUSETemplate] cc inner join
  [RTPhoenix].[CRITERIASTMTTemplate] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
				inner join
  [RTPhoenix].[METATABLETemplate] mt on cc.TABLE_ID = mt.TABLE_ID inner join
		[dbo].[METATABLE] db0 on mt.strtable_nm = db0.strtable_nm and 
					db0.study_id = @TargetStudy_id and mt.study_id = @study_id
				inner join
		[dbo].[CriteriaStmt] db01 on cs.STRCRITERIASTMT_NM = db01.STRCRITERIASTMT_NM and
					convert(varchar,cs.strCriteriaString) = convert(varchar,db01.strCriteriaString) and
					cs.study_id = @study_id and db01.study_id = @TargetStudy_id

INSERT INTO [dbo].[CRITERIAINLIST] 
           ([CRITERIACLAUSE_ID]
           ,[STRLISTVALUE])
SELECT db01.[CRITERIACLAUSE_ID]
      ,ci.[STRLISTVALUE]
  FROM [RTPhoenix].[CRITERIAINLISTTemplate] ci inner join
  [RTPhoenix].[CRITERIACLAUSETemplate] cc on ci.CRITERIACLAUSE_ID = cc.CRITERIACLAUSE_ID inner join
  [RTPhoenix].[CRITERIASTMTTemplate] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID inner join
		[dbo].[CriteriaStmt] db0 on cs.STRCRITERIASTMT_NM = db0.STRCRITERIASTMT_NM and
					cs.study_id = @study_id and db0.study_id = @TargetStudy_id
				inner join
		[dbo].[CRITERIACLAUSE] db01 on db01.CRITERIASTMT_ID = db0.CRITERIASTMT_ID

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'CRITERIA* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[MedicareLookup] 
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
SELECT @MedicareNumber
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
  FROM [RTPhoenix].[MedicareLookupTemplate] ml inner join
  [RTPhoenix].[SUFacilityTemplate] suf on ml.medicarenumber = suf.medicarenumber inner join
  [RTPhoenix].[SAMPLEUNITTemplate] su on suf.SUFacility_id = su.SUFacility_id inner join
  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id
  
  INSERT INTO [dbo].[SUFacility]
           ([strFacility_nm]
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
SELECT [strFacility_nm]
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
      ,@MedicareNumber
  FROM [RTPhoenix].[SUFacilityTemplate] suf inner join
  [RTPhoenix].[SAMPLEUNITTemplate] su on suf.SUFacility_id = su.SUFacility_id inner join
  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SUFacility/MedicareLookup template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[Sel_Cover] 
           ([SelCover_id]
           ,[Survey_id]
           ,[PageType]
           ,[Description]
           ,[Integrated]
           ,[bitLetterHead])
SELECT [SelCover_id]
      ,db0.[Survey_id]
      ,[PageType]
      ,[Description]
      ,[Integrated]
      ,[bitLetterHead]
  FROM [RTPhoenix].[Sel_CoverTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[SEL_LOGO] 
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
      ,db0.[SURVEY_ID]
      ,[DESCRIPTION]
      ,[X]
      ,[Y]
      ,[WIDTH]
      ,[HEIGHT]
      ,[SCALING]
      ,[BITMAP]
      ,[VISIBLE]
  FROM [RTPhoenix].[SEL_LOGOTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[SEL_PCL]
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
      ,db0.[SURVEY_ID]
      ,[LANGUAGE]
      ,[COVERID]
      ,[DESCRIPTION]
      ,[X]
      ,[Y]
      ,[WIDTH]
      ,[HEIGHT]
      ,[PCLSTREAM]
      ,[KNOWNDIMENSIONS]
  FROM [RTPhoenix].[SEL_PCLTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[SEL_QSTNS]
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
      ,db0.[SURVEY_ID]
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
  FROM [RTPhoenix].[SEL_QSTNSTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[SEL_SCLS] 
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
SELECT db0.[SURVEY_ID]
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
  FROM [RTPhoenix].[SEL_SCLSTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[SEL_SKIP] 
           ([SURVEY_ID]
           ,[SELQSTNS_ID]
           ,[SELSCLS_ID]
           ,[SCALEITEM]
           ,[NUMSKIP]
           ,[NUMSKIPTYPE])
SELECT db0.[SURVEY_ID]
      ,[SELQSTNS_ID]
      ,[SELSCLS_ID]
      ,[SCALEITEM]
      ,[NUMSKIP]
      ,[NUMSKIPTYPE]
  FROM [RTPhoenix].[SEL_SKIPTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'SEL* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[SEL_TEXTBOX] 
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
      ,db0.[SURVEY_ID]
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
  FROM [RTPhoenix].[SEL_TEXTBOXTemplate] sel inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sel.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[ModeSectionMapping]
           ([Survey_Id]
           ,[MailingStepMethod_Id]
           ,[MailingStepMethod_nm]
           ,[Section_Id]
           ,[SectionLabel])
SELECT db0.[Survey_Id]
      ,db01.[MailingStepMethod_Id]
      ,[MailingStepMethod_nm]
      ,[Section_Id]
      ,[SectionLabel]
  FROM [RTPhoenix].[ModeSectionMappingTemplate] msmt inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on msmt.Survey_id = sd.SURVEY_ID inner join
		[dbo].[MailingStep] ms on ms.SURVEY_ID = sd.survey_id inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				inner join
		[dbo].[MailingStep] db01 on db01.SURVEY_ID = db0.survey_id and
					ms.STRMAILINGSTEP_NM = db01.STRMAILINGSTEP_NM

INSERT INTO [dbo].[TAGFIELD] 
           ([TAG_ID]
           ,[TABLE_ID]
           ,[FIELD_ID]
           ,[STUDY_ID]
           ,[REPLACEFIELD_FLG]
           ,[STRREPLACELITERAL])
SELECT tf.[TAG_ID]
      ,db0.[TABLE_ID]
      ,tf.[FIELD_ID]
      ,@TargetStudy_ID
      ,tf.[REPLACEFIELD_FLG]
      ,tf.[STRREPLACELITERAL]
  FROM [RTPhoenix].[TAGFIELDTemplate] tf inner join
  [RTPhoenix].[METATABLETemplate] mt on tf.TABLE_ID = mt.TABLE_ID inner join
		[dbo].[METATABLE] db0 on db0.STRTABLE_NM = mt.STRTABLE_NM and
					db0.study_id = @TargetStudy_ID and mt.STUDY_ID = @study_id

INSERT INTO [dbo].[CODEQSTNS]
           ([SELQSTNS_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[CODE]
           ,[INTSTARTPOS]
           ,[INTLENGTH])
SELECT [SELQSTNS_ID]
      ,db0.[SURVEY_ID]
      ,[LANGUAGE]
      ,[CODE]
      ,[INTSTARTPOS]
      ,[INTLENGTH]
  FROM [RTPhoenix].[CODEQSTNSTemplate] cq inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on cq.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[CODESCLS] 
           ([SURVEY_ID]
           ,[QPC_ID]
           ,[ITEM]
           ,[LANGUAGE]
           ,[CODE]
           ,[INTSTARTPOS]
           ,[INTLENGTH])
SELECT db0.[SURVEY_ID]
      ,[QPC_ID]
      ,[ITEM]
      ,[LANGUAGE]
      ,[CODE]
      ,[INTSTARTPOS]
      ,[INTLENGTH]
  FROM [RTPhoenix].[CODESCLSTemplate] cs inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on cs.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

INSERT INTO [dbo].[CODETXTBOX] 
           ([QPC_ID]
           ,[SURVEY_ID]
           ,[LANGUAGE]
           ,[CODE]
           ,[INTSTARTPOS]
           ,[INTLENGTH])
SELECT [QPC_ID]
      ,db0.[SURVEY_ID]
      ,[LANGUAGE]
      ,[CODE]
      ,[INTSTARTPOS]
      ,[INTLENGTH]
  FROM [RTPhoenix].[CODETXTBOXTemplate] ct inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on ct.Survey_id = sd.SURVEY_ID inner join
		[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm and
					db0.study_id = @TargetStudy_id and sd.study_id = @study_id

--declare @study_id int = 4955 declare @client_id int select @client_id = client_id from study where study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'CODE* template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

INSERT INTO [dbo].[STUDY_EMPLOYEE] 
           ([EMPLOYEE_ID]
           ,[STUDY_ID])
SELECT [EMPLOYEE_ID]
      ,@TargetStudy_ID
  FROM [RTPhoenix].[STUDY_EMPLOYEETemplate]
  where Study_id = @study_id and Employee_id not in
  (select Employee_id from [dbo].[study_employee] where study_id = @TargetStudy_ID)

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Study_Employee template table imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

SET @CompletedNotes = 'Completed import of Study_id '+convert(varchar,@TargetStudy_ID)+
	' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

UPDATE [RTPhoenix].[TemplateJob]
   SET [TargetClient_ID] = @TargetClient_ID
      ,[TargetStudy_ID] = @TargetStudy_ID
      ,[Client_nm] = @Client_nm
      ,[Study_nm] = @Study_nm
      ,[Study_desc] = @Study_desc
      ,[CompletedNotes] = @CompletedNotes
      ,[CompletedAt] = GetDate()
 WHERE TemplateJob_ID = @TemplateJob_ID

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, 'Completed TemplateJob '+convert(varchar,@TemplateJob_ID)+
	 ', Client/Study '+@client_nm+'('+convert(varchar,@TargetClient_id)+')/'+
	 @study_nm+'('+convert(varchar,@TargetStudy_id)+')', @user, GetDate())

