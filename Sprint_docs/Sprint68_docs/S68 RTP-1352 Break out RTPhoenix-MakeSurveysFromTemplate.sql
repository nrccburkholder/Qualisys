/*
S68 RTP-1352 Break out RTPhoenix-MakeSurveysFromTemplate.sql

Chris Burkholder

2/14/2017

CREATE PROCEDURE RTPhoenix.MakeSurveysFromTemplate
--DROP PROCEDURE RTPhoenix.MakeSurveysFromTemplate
*/
Use [QP_Prod]
GO

CREATE PROCEDURE [RTPhoenix].[MakeSurveysFromTemplate]
	@TemplateJob_ID int
AS
begin

begin try

	begin tran

		  declare @TemplateJobType_ID int
		  declare @Template_ID int
		  declare @TemplateSurvey_ID int
		  declare @TemplateSampleUnit_ID int		
		  --declare @CAHPSSurveyType_ID int
		  --declare @CAHPSSurveySubtype_ID int
		  --declare @RTSurveyType_ID int
		  --declare @RTSurveySubtype_ID int
		  --declare @AsOfDate datetime
		  --declare @TargetClient_ID int
		  declare @TargetStudy_ID int
		  declare @TargetSurvey_ID int
		  --declare @Study_nm varchar(10)
		  --declare @Study_desc varchar(255)
		  declare @Survey_nm varchar(10)
		  --declare @SampleUnit_nm varchar(42) 
		  declare @MedicareNumber varchar(20)
		  declare @ContractNumber [varchar](9) 
		  declare @Survey_Start_Dt [datetime] 
		  declare @Survey_End_Dt [datetime] 
		  declare @LoggedBy varchar(40)
		  --declare @LoggedAt datetime
		  declare @CompletedNotes varchar(255)
		  declare @CompletedAt datetime

		  declare @TemplateLogEntryInfo int
		  declare @TemplateLogEntryWarning int
		  declare @TemplateLogEntryError int

		  select @TemplateLogEntryInfo = TemplateLogEntryType_ID 
		  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'INFORMATIONAL'

		  select @TemplateLogEntryWarning = TemplateLogEntryType_ID 
		  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'WARNING'

		  select @TemplateLogEntryError = TemplateLogEntryType_ID 
		  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'ERROR'


	SELECT 
		  @TemplateJobType_ID = [TemplateJobType_ID]
		  ,@Template_ID = [Template_ID]
		  ,@TemplateSurvey_ID = [TemplateSurvey_ID]
		  ,@TemplateSampleUnit_ID = [TemplateSampleUnit_ID]
		  --,@CAHPSSurveyType_ID = [CAHPSSurveyType_ID]
		  --,@CAHPSSurveySubtype_ID = [CAHPSSurveySubtype_ID]
		  --,@RTSurveyType_ID = [RTSurveyType_ID]
		  --,@RTSurveySubtype_ID = [RTSurveySubtype_ID]
		  --,@AsOfDate = ISNULL([AsOfDate], GetDate())
		  --,@TargetClient_ID = [TargetClient_ID]
		  ,@TargetStudy_id = [TargetStudy_ID]
		  ,@TargetSurvey_id = [TargetStudy_ID]
		  --,@Study_nm = [Study_nm]
		  --,@Study_desc = [Study_desc]
		  ,@Survey_nm = [Survey_nm]
		  --,@SampleUnit_nm = [SampleUnit_nm]
		  ,@MedicareNumber = [MedicareNumber]
		  ,@ContractNumber = [ContractNumber]
		  ,@Survey_Start_Dt = [Survey_Start_Dt]
		  ,@Survey_End_Dt = [Survey_End_Dt]
		  ,@LoggedBy = [LoggedBy]
		  --,@LoggedAt = [LoggedAt]
		  ,@CompletedNotes = [CompletedNotes]
		  ,@CompletedAt = [CompletedAt]
	  FROM [RTPhoenix].[TemplateJob]
	  where [TemplateJob_ID] = @TemplateJob_ID 

	if @TemplateJob_ID is null
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 SELECT -1, NULL, @TemplateLogEntryWarning, 'No Template Job Found To Process', SYSTEM_USER, GetDate()

		commit tran

		RETURN
	end

	declare @template_NM varchar(40)
	declare @user varchar(40) = @LoggedBy
	declare @study_id int 
	declare @client_id int

	SELECT @Template_ID = [Template_ID]
		  ,@client_id = [Client_ID]
		  ,@study_id = [Study_ID]
		  ,@Template_NM = [Template_NM]
	  FROM [RTPhoenix].[Template]
	  where Template_ID = @Template_ID
		and [Active] = 1

	--TODO: Add Survey(s) here

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
		  ,[STRSURVEY_NM]--insert new survey name here only after inner joins dependent on the template's survey name
		  ,[STRSURVEY_DSC]
		  ,[INTRESPONSE_RECALC_PERIOD]
		  ,[INTRESURVEY_PERIOD]
		  ,[BITREPEATINGENCOUNTERS_FLG]
		  ,[BITPHYSASSIST_NAME_FLG]
		  ,[BITMINOR_EXCEPT_FLG]
		  ,[BITNEWBORN_FLG]
		  ,IsNull(@Survey_Start_Dt,[DATSURVEY_START_DT])
		  ,IsNull(@Survey_End_Dt,[DATSURVEY_END_DT])
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
		  ,0--[BITVALIDATED_FLG]
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
		  ,IsNull(@ContractNumber,[Contract])
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
			[dbo].[METATABLE] db02 on mt2.strtable_nm = db02.strtable_nm 
	WHERE db02.study_id = @TargetStudy_id and mt2.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

	INSERT INTO [dbo].[SurveySubtype]
			   ([Survey_id]
			   ,[Subtype_id]) 
	SELECT db0.[Survey_id]
		  ,sst.[Subtype_id]
	  FROM [RTPhoenix].[SurveySubtypeTemplate] sst inner join
			[RTPhoenix].[SURVEY_DEFTemplate] sd on sst.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			'SURVEY template (newest Survey ID: '+
			convert(nvarchar,Ident_Current('dbo.Survey_Def'))+
			') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
	  [RTPhoenix].[CriteriaStmtTemplate] cst on cst.CRITERIASTMT_ID = br.CRITERIASTMT_ID inner join
			[dbo].[CriteriaStmt] db01 on cst.STRCRITERIASTMT_NM = db01.STRCRITERIASTMT_NM and
						convert(nvarchar,cst.strCriteriaString) = convert(nvarchar,db01.strCriteriaString) and
						db01.study_id = @TargetStudy_id and cst.study_id = @study_id 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'BusinessRule template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[HOUSEHOLDRULE] 
			   ([TABLE_ID]
			   ,[FIELD_ID]
			   ,[SURVEY_ID])
	SELECT db01.[TABLE_ID]
		  ,[FIELD_ID]
		  ,db0.[SURVEY_ID]
	  FROM [RTPhoenix].[HOUSEHOLDRULETemplate] hhr inner join
	  [RTPhoenix].[SURVEY_DEFTemplate] sd on hhr.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
	  [RTPhoenix].[METATABLETemplate] mt on hhr.TABLE_ID = mt.TABLE_ID inner join
			[dbo].[METATABLE] db01 on mt.strtable_nm = db01.strtable_nm and
						db01.study_id = @TargetStudy_id and mt.study_id = @study_id
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'HouseholdRule template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[MAILINGMETHODOLOGY]
			   ([SURVEY_ID]
			   ,[BITACTIVEMETHODOLOGY]
			   ,[STRMETHODOLOGY_NM]
			   ,[DATCREATE_DT]
			   ,[StandardMethodologyID]) 
	SELECT db0.[SURVEY_ID]
		  ,mm.[BITACTIVEMETHODOLOGY]
		  ,mm.[STRMETHODOLOGY_NM]
		  ,mm.[DATCREATE_DT]
		  ,mm.[StandardMethodologyID]
	  FROM [RTPhoenix].[MAILINGMETHODOLOGYTemplate] mm inner join
			[RTPhoenix].[SURVEY_DEFTemplate] sd on mm.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			'MAILINGMETHODOLOGY template (newest MailingMethodology ID: '+
			convert(nvarchar,Ident_Current('dbo.MailingMethodology'))+
			') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[MAILINGMETHODOLOGY] db01 on mm.STRMETHODOLOGY_NM = db01.STRMETHODOLOGY_NM and
						db01.SURVEY_ID = db0.survey_id
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

	update ms set ExpireFromStep = ms2.mailingstep_id 
	--select ms.ExpireFromStep, ms2.ExpireFromStep 
	from [dbo].[mailingstep] ms inner join [dbo].[mailingstep] ms2 on 
		ms.survey_id = ms2.survey_id and ms2.intsequence = 1
		where ms.MAILINGSTEP_ID >= @ExpireFromStepStub

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			'MAILINGSTEP template (newest MailingStep ID: '+
			convert(nvarchar,Ident_Current('dbo.MailingStep'))+
			') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	/* ----------- The MedicareLookup record must be pre-existing according to the code review on 2/6/2017 CJB

	IF NOT EXISTS(select 1 from [dbo].[MedicareLookup] where MedicareNumber = @MedicareNumber)
	BEGIN
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

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'MedicareLookup template table imported for study_id '+
				convert(varchar,@TargetStudy_id), @user, GetDate())
	END
	*/
  
	IF NOT EXISTS(select 1 from [dbo].[SUFacility]
				where MedicareNumber = @MedicareNumber)
	BEGIN
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
			AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'SUFacility template (newest SUFacility ID: '+
				convert(nvarchar,Ident_Current('dbo.SUFacility'))+
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())
	END

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			select @Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			strFacility_nm + ' is SUFacility to be used for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate()
			from [dbo].[SUFacility] where MedicareNumber = @MedicareNumber
	if @@rowcount > 1
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				select @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 
				'More than one SUFacility found for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate()

		commit tran

		RETURN
	end

	INSERT INTO [dbo].[SAMPLEPLAN]
			   ([ROOTSAMPLEUNIT_ID]
			   ,[EMPLOYEE_ID]
			   ,[SURVEY_ID]
			   ,[DATCREATE_DT])
	SELECT null --[ROOTSAMPLEUNIT_ID] --fill in later from template
		  ,[EMPLOYEE_ID]
		  ,db0.[SURVEY_ID]
		  ,[DATCREATE_DT]
	  FROM [RTPhoenix].[SAMPLEPLANTemplate] sp inner join
			[RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			'SamplePlan template (newest Sample Plan ID: '+
			convert(nvarchar,Ident_Current('dbo.SamplePlan'))+
			') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'PeriodDef template (row count:'+
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[PeriodDef] db01 on db01.strPeriodDef_nm = pdf.strPeriodDef_nm and
						db01.Survey_id = db0.Survey_id and pdf.Survey_id = sd.Survey_id
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'PeriodDates template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_Cover template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_Logo template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_PCL template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_Qstns template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_Scls template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_Skip template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Sel_Textbox template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[MailingStep] db01 on db01.SURVEY_ID = db0.survey_id and
						ms.STRMAILINGSTEP_NM = db01.STRMAILINGSTEP_NM
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'ModeSectionMapping template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'CodeQstns template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'CodeScls template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm 
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'CodeTxtBox template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	SET @CompletedNotes = 'Completed Make Surveys From Template for Study_id '+convert(varchar,@TargetStudy_ID)+
		' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

	if (@TemplateSurvey_ID > 0) --specific TemplateSurvey_ID  yields a specific TargetSurvey_ID
	begin
		UPDATE [dbo].[Survey_DEF]
		set [STRSURVEY_NM] = IsNull(@Survey_nm, [STRSURVEY_NM])
		where [Survey_ID] = @TargetSurvey_ID

		UPDATE [RTPhoenix].[TemplateJob]
		   SET [TargetSurvey_ID] = db0.survey_id
			  ,[Survey_nm] = db0.STRSURVEY_NM
			  ,[CompletedNotes] = @CompletedNotes
			  ,[CompletedAt] = GetDate()
		  FROM [RTPhoenix].[TemplateJob] tj INNER JOIN
			   [RTPhoenix].[Template] t on tj.Template_ID = t.Template_ID INNER JOIN
			   [RTPhoenix].[SURVEY_DEFTemplate] sd on sd.STUDY_ID = t.Study_ID INNER JOIN
			   [dbo].[Survey_Def] db0 on db0.STRSURVEY_NM = sd.STRSURVEY_NM
		 WHERE TemplateJob_ID = @TemplateJob_ID and
			db0.study_id = @TargetStudy_id and sd.study_id = @study_id
			AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	end
	else
		UPDATE [RTPhoenix].[TemplateJob]
		   SET [CompletedNotes] = @CompletedNotes
			  ,[CompletedAt] = GetDate()
		 WHERE TemplateJob_ID = @TemplateJob_ID

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Completed Make Surveys From Template for TemplateJob_id '+convert(varchar,@TemplateJob_ID)+
		 ', Study '+convert(varchar,@TargetStudy_id)+')', @user, GetDate())

	--Determine if a MakeSampleUnitsFromTemplate job is needed and add (if so)

	if @TemplateSampleUnit_ID = -1 -- if >0, then a survey ID, or -1 means all surveys
		INSERT INTO [RTPhoenix].[TemplateJob]
				   ([TemplateJobType_ID]
				   ,[MasterTemplateJob_ID]
				   ,[Template_ID]
				   ,[TemplateSurvey_ID]
				   ,[TemplateSampleUnit_ID]
				   ,[CAHPSSurveyType_ID]
				   ,[CAHPSSurveySubtype_ID]
				   ,[RTSurveyType_ID]
				   ,[RTSurveySubtype_ID]
				   ,[AsOfDate]
				   ,[TargetClient_ID]
				   ,[TargetStudy_ID]
				   ,[TargetSurvey_ID]
				   ,[Study_nm]
				   ,[Study_desc]
				   ,[Survey_nm]
				   ,[SampleUnit_nm]
				   ,[MedicareNumber]
				   ,[LoggedBy]
				   ,[LoggedAt]
				   ,[CompletedNotes]
				   ,[CompletedAt])
		SELECT 3--[TemplateJobType_ID]
			  ,@TemplateJob_ID--[MasterTemplateJob_ID]
			  ,tj.[Template_ID]
			  ,[TemplateSurvey_ID]
			  ,su.SampleUnit_id
			  ,[CAHPSSurveyType_ID]
			  ,[CAHPSSurveySubtype_ID]
			  ,[RTSurveyType_ID]
			  ,[RTSurveySubtype_ID]
			  ,[AsOfDate]
			  ,[TargetClient_ID]
			  ,[TargetStudy_ID]
			  ,[TargetSurvey_ID]
			  ,[Study_nm]
			  ,[Study_desc]
			  ,IsNull([Survey_nm], sd.strSurvey_NM)
			  ,IsNull([SampleUnit_nm], su.strSampleUnit_NM)
			  ,[MedicareNumber]
			  ,[LoggedBy]
			  ,getdate()
			  ,null
			  ,null
		  FROM [RTPhoenix].[TemplateJob] tj
		  INNER JOIN [RTPhoenix].[Template] t on tj.Template_ID = t.Template_ID
		  INNER JOIN [RTPhoenix].[Survey_DefTemplate] sd on sd.STUDY_ID = t.Study_ID
		  INNER JOIN [RTPhoenix].[SAMPLEPLANTemplate] sp on sp.SURVEY_ID = sd.SURVEY_ID
		  INNER JOIN [RTPhoenix].[SampleUnitTemplate] su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
		  WHERE [TemplateJob_ID] = @TemplateJob_ID
			AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	else
	if @TemplateSampleUnit_ID > 0 -- if >0, then a survey ID, or -1 means all surveys
		INSERT INTO [RTPhoenix].[TemplateJob]
				   ([TemplateJobType_ID]
				   ,[MasterTemplateJob_ID]
				   ,[Template_ID]
				   ,[TemplateSurvey_ID]
				   ,[TemplateSampleUnit_ID]
				   ,[CAHPSSurveyType_ID]
				   ,[CAHPSSurveySubtype_ID]
				   ,[RTSurveyType_ID]
				   ,[RTSurveySubtype_ID]
				   ,[AsOfDate]
				   ,[TargetClient_ID]
				   ,[TargetStudy_ID]
				   ,[TargetSurvey_ID]
				   ,[Study_nm]
				   ,[Study_desc]
				   ,[Survey_nm]
				   ,[SampleUnit_nm]
				   ,[MedicareNumber]
				   ,[ContractNumber]
				   ,[Survey_Start_Dt]
				   ,[Survey_End_Dt]
 				   ,[Methodology_ID]
				   ,[Language_ID]
				   ,[LoggedBy]
				   ,[LoggedAt]
				   ,[CompletedNotes]
				   ,[CompletedAt])
		SELECT 3--[TemplateJobType_ID]
			  ,@TemplateJob_ID--[MasterTemplateJob_ID]
			  ,[Template_ID]
			  ,[TemplateSurvey_ID]
			  ,[TemplateSampleUnit_ID]
			  ,[CAHPSSurveyType_ID]
			  ,[CAHPSSurveySubtype_ID]
			  ,[RTSurveyType_ID]
			  ,[RTSurveySubtype_ID]
			  ,[AsOfDate]
			  ,[TargetClient_ID]
			  ,[TargetStudy_ID]
			  ,[TargetSurvey_ID]
			  ,[Study_nm]
			  ,[Study_desc]
			  ,[Survey_nm]
			  ,[SampleUnit_nm]
			  ,[MedicareNumber]
			  ,[ContractNumber]
			  ,[Survey_Start_Dt]
			  ,[Survey_End_Dt]
			  ,[Methodology_ID]
			  ,[Language_ID]
			  ,[LoggedBy]
			  ,getdate()
			  ,null
			  ,null
		  FROM [RTPhoenix].[TemplateJob]
		  WHERE [TemplateJob_ID] = @TemplateJob_ID

	commit tran

end try
begin catch
	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			SELECT @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Make Sample Units From Template Job did not succeed and was rolled back', SYSTEM_USER, GetDate()

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [CompletedNotes] = 'Make Surveys From Template Job did not succeed and was rolled back: '+@CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE TemplateJob_ID = @TemplateJob_ID

	rollback tran
end catch

end
