/*
S68 RTP-1352 Break out RTPhoenix-MakeSampleUnitsFromTemplate.sql

Chris Burkholder

2/14/2017

CREATE PROCEDURE RTPhoenix.MakeSampleUnitsFromTemplate
--DROP PROCEDURE RTPhoenix.MakeSampleUnitsFromTemplate
*/
Use [QP_Prod]
GO

CREATE PROCEDURE [RTPhoenix].[MakeSampleUnitsFromTemplate]
	@TemplateJob_ID int
AS
begin

	begin tran

--TODO: handle @TemplateSampleUnit_ID <> -1 case (0 Sample Units or 1 specific Sample Units)

		  declare @TemplateJobType_ID int
		  declare @Template_ID int
		  declare @TemplateSurvey_ID int
		  declare @TemplateSampleUnit_ID int		
		  declare @CAHPSSurveyType_ID int
		  declare @CAHPSSurveySubtype_ID int
		  declare @RTSurveyType_ID int
		  declare @RTSurveySubtype_ID int
		  declare @AsOfDate datetime
		  declare @TargetClient_ID int
		  declare @TargetStudy_ID int
		  declare @TargetSurvey_ID int
		  declare @Study_nm varchar(10)
		  declare @Study_desc varchar(255)
		  declare @Survey_nm varchar(10)
		  declare @SampleUnit_nm varchar(42) 
		  declare @MedicareNumber varchar(20)
		  declare @LoggedBy varchar(40)
		  declare @LoggedAt datetime
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
		  ,@CAHPSSurveyType_ID = [CAHPSSurveyType_ID]
		  ,@CAHPSSurveySubtype_ID = [CAHPSSurveySubtype_ID]
		  ,@RTSurveyType_ID = [RTSurveyType_ID]
		  ,@RTSurveySubtype_ID = [RTSurveySubtype_ID]
		  ,@AsOfDate = ISNULL([AsOfDate], GetDate())
		  ,@TargetClient_ID = [TargetClient_ID]
		  ,@TargetStudy_id = [TargetStudy_ID]
		  ,@TargetSurvey_id = [TargetStudy_ID]
		  ,@Study_nm = [Study_nm]
		  ,@Study_desc = [Study_desc]
		  ,@Survey_nm = [Survey_nm]
		  ,@SampleUnit_nm = [SampleUnit_nm]
		  ,@MedicareNumber = [MedicareNumber]
		  ,@LoggedBy = [LoggedBy]
		  ,@LoggedAt = [LoggedAt]
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

	--Add Sample Unit(s) here

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
	SELECT db01.[CRITERIASTMT_ID] 
		  ,db02.[SAMPLEPLAN_ID]
		  ,null --[PARENTSAMPLEUNIT_ID] --fill in later from template
		  ,su.[STRSAMPLEUNIT_NM]
		  ,su.[INTTARGETRETURN]
		  ,su.[INTMINCONFIDENCE]
		  ,su.[INTMAXMARGIN]
		  ,su.[NUMINITRESPONSERATE]
		  ,su.[NUMRESPONSERATE]
		  ,su.[REPORTING_HIERARCHY_ID]
		  ,db04.[SUFacility_id] 
		  ,su.[SUServices]
		  ,su.[bitsuppress]
		  ,su.[bitCHART]
		  ,su.[Priority]
		  ,su.[SampleSelectionType_id]
		  ,su.[DontSampleUnit]
		  ,su.[CAHPSType_id]
	/*      ,[bitHCAHPS]
		  ,[bitHHCAHPS]
		  ,[bitMNCM]
		  ,[bitACOCAHPS]*/
		  ,su.[bitLowVolumeUnit]
	  FROM [RTPhoenix].[SAMPLEUNITTemplate] su inner join
	  [RTPhoenix].[CRITERIASTMTTemplate] cs on su.CRITERIASTMT_ID = cs.CRITERIASTMT_ID inner join
	  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
	  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id inner join
			[dbo].[CriteriaStmt] db01 on cs.STRCRITERIASTMT_NM = db01.STRCRITERIASTMT_NM and
						convert(varchar,cs.strCriteriaString) = convert(varchar,db01.strCriteriaString) 
					left join
			[dbo].[SUFacility] db04 on su.SUFacility_id <> 0 and 
						db04.MedicareNumber = @MedicareNumber
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id and
			cs.study_id = @study_id and db01.study_id = @TargetStudy_id

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'SampleUnit template (newest Sample Unit ID: '+
				convert(nvarchar,Ident_Current('dbo.SampleUnit'))+
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	--backfill SAMPLEPLAN.ROOTSAMPLEUNIT_ID

	update db02 set ROOTSAMPLEUNIT_ID = db03.SAMPLEUNIT_ID
	--select sp.[_STRSAMPLEUNIT_NM_ROOT], db03.[SAMPLEUNIT_ID]
	  from [RTPhoenix].[SAMPLEPLANTemplate] sp inner join
	  [RTPhoenix].SURVEY_DEFTemplate sd on sp.SURVEY_ID = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id inner join
			[dbo].[SampleUnit] db03 on db02.SAMPLEPLAN_ID = db03.SAMPLEPLAN_ID and
						db03.STRSAMPLEUNIT_NM = sp._STRSAMPLEUNIT_NM_ROOT
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id

	--backfill SAMPLEUNIT.PARENTSAMPLEUNIT_ID

	update db03 set [PARENTSAMPLEUNIT_ID] = db03p.[SAMPLEUNIT_ID]
	--select su.[_STRSAMPLEUNIT_NM_PARENT], su.[STRSAMPLEUNIT_NM], db03p.SAMPLEUNIT_ID
	  from [RTPhoenix].[SAMPLEUNITTemplate] su inner join
	  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
	  [RTPhoenix].SURVEY_DEFTemplate sd on sp.SURVEY_ID = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id inner join
			[dbo].[SampleUnit] db03 on db02.SAMPLEPLAN_ID = db03.SAMPLEPLAN_ID and
						db03.STRSAMPLEUNIT_NM = su.STRSAMPLEUNIT_NM
					inner join
			[dbo].[SampleUnit] db03p on db02.SAMPLEPLAN_ID = db03p.SAMPLEPLAN_ID and
						db03p.STRSAMPLEUNIT_NM = su._STRSAMPLEUNIT_NM_PARENT
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				
	INSERT INTO [dbo].[SAMPLEUNITTREEINDEX] 
			   ([SAMPLEUNIT_ID]
			   ,[ANCESTORUNIT_ID])
	SELECT db02.[SAMPLEUNIT_ID]
		  ,db03.[SAMPLEUNIT_ID]
	  FROM [RTPhoenix].[SAMPLEUNITTREEINDEXTemplate] suti inner join
	  [RTPhoenix].[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = suti.SAMPLEUNIT_ID join
	  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
	  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[SamplePlan] db01 on db01.survey_id = db0.survey_id
					inner join
			[dbo].[SampleUnit] db02 on su.strsampleunit_nm = db02.strsampleunit_nm and
						db02.SAMPLEPLAN_ID = db01.SAMPLEPLAN_ID
					inner join
			[dbo].[SampleUnit] db03 on db03.STRSAMPLEUNIT_NM = suti._STRSAMPLEUNIT_NM_ANCESTOR and
						db03.sampleplan_id = db01.sampleplan_id
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'SampleUnitTreeIndex template (row count:'+
			 convert(varchar, @@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[SampleUnitService]
			   ([SampleUnit_id]
			   ,[Service_id]
			   ,[strAltService_nm]
			   ,[datLastUpdated])
	SELECT db03.[SampleUnit_id]
		  ,[Service_id]
		  ,[strAltService_nm]
		  ,[datLastUpdated]
	  FROM [RTPhoenix].[SampleUnitServiceTemplate] sus inner join
	  [RTPhoenix].[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = sus.SAMPLEUNIT_ID join
	  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
	  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id inner join
			[dbo].[SampleUnit] db03 on su.strsampleunit_nm = db03.strsampleunit_nm and
						db03.SAMPLEPLAN_ID = db02.SAMPLEPLAN_ID
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'SampleUnitService template (row count:'+ 
				convert(varchar,@@RowCount) + 
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[SAMPLEUNITSECTION] 
			   ([SAMPLEUNIT_ID]
			   ,[SELQSTNSSECTION]
			   ,[SELQSTNSSURVEY_ID]) 
	SELECT db03.[SAMPLEUNIT_ID]
		  ,[SELQSTNSSECTION]
		  ,db0.SURVEY_ID 
	  FROM [RTPhoenix].[SAMPLEUNITSECTIONTemplate] sus inner join
	  [RTPhoenix].[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = sus.SAMPLEUNIT_ID join
	  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
	  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
			[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
			[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id inner join
			[dbo].[SampleUnit] db03 on su.strsampleunit_nm = db03.strsampleunit_nm and
						db03.SAMPLEPLAN_ID = db02.SAMPLEPLAN_ID
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
				
		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'SampleUnitSection template (row count:'+ 
				convert(varchar,@@RowCount) + 
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	SET @CompletedNotes = 'Completed Make Sample Units From Template for Study_id '+convert(varchar,@TargetStudy_ID)+
		' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [CompletedNotes] = @CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE TemplateJob_ID = @TemplateJob_ID

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Completed Make Sample Units From Template for TemplateJob_id '+convert(varchar,@TemplateJob_ID)+
		 ', Study '+convert(varchar,@TargetStudy_id)+')', @user, GetDate())

	commit tran

end
