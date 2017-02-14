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

	begin tran

--TODO: handle @TemplateSurvey_ID = -1 case (all Surveys)

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

	--TODO: Add Survey(s) here

	SET @CompletedNotes = 'Completed Make Surveys From Template for Study_id '+convert(varchar,@TargetStudy_ID)+
		' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [CompletedNotes] = @CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE TemplateJob_ID = @TemplateJob_ID

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Completed Make Surveys From Template for TemplateJob_id '+convert(varchar,@TemplateJob_ID)+
		 ', Study '+convert(varchar,@TargetStudy_id)+')', @user, GetDate())

	--Determine if a MakeSampleUnitsFromTemplate job is needed and add (if so)

	if @TemplateSampleUnit_ID <> 0 -- if >0, then a survey ID, or -1 means all surveys
		INSERT INTO [RTPhoenix].[TemplateJob]
				   ([TemplateJobType_ID]
				   ,[MasterTemplateJobType_ID]
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
			  ,@TemplateJob_ID--[MasterTemplateJobType_ID]
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
			  ,getdate()
			  ,null
			  ,null
		  FROM [RTPhoenix].[TemplateJob]
		  WHERE [TemplateJob_ID] = @TemplateJob_ID

	commit tran

end
