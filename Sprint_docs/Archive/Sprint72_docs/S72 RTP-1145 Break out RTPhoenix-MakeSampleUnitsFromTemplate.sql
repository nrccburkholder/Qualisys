/*
S72 RTP-1145 Break out RTPhoenix-MakeSampleUnitsFromTemplate.sql

Chris Burkholder

3/30/2017

CREATE PROCEDURE RTPhoenix.MakeSampleUnitsFromTemplate
--DROP PROCEDURE RTPhoenix.MakeSampleUnitsFromTemplate
*/
Use [QP_Prod]
GO

if object_id('[RTPhoenix].[MakeSampleUnitsFromTemplate]') is not null
	DROP PROCEDURE [RTPhoenix].[MakeSampleUnitsFromTemplate]
GO

CREATE PROCEDURE [RTPhoenix].[MakeSampleUnitsFromTemplate]
	@TemplateJob_ID int
AS
begin

begin try

	begin tran

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
		  --declare @TargetSurvey_ID int
		  --declare @Study_nm char(10)
		  --declare @Study_desc varchar(255)
		  declare @Survey_nm varchar(10)
		  declare @SampleUnit_nm varchar(42) 
		  declare @MedicareNumber varchar(20)
		  --declare @ContractNumber [varchar](9) 
		  --declare @Survey_Start_Dt [datetime] 
		  --declare @Survey_End_Dt [datetime] 
		  declare @LoggedBy varchar(40)
		  --declare @LoggedAt datetime
		  declare @CompletedNotes varchar(255)
		  declare @CompletedAt datetime

		  declare @TemplateLogEntryInfo int
		  declare @TemplateLogEntryWarning int
		  declare @TemplateLogEntryError int

		  select @TemplateLogEntryInfo = TemplateLogEntryTypeID 
		  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'INFORMATIONAL'

		  select @TemplateLogEntryWarning = TemplateLogEntryTypeID 
		  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'WARNING'

		  select @TemplateLogEntryError = TemplateLogEntryTypeID 
		  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'ERROR'


	SELECT 
		  @TemplateJobType_ID = [TemplateJobTypeID]
		  ,@Template_ID = [TemplateID]
		  ,@TemplateSurvey_ID = [TemplateSurveyID]
		  ,@TemplateSampleUnit_ID = [TemplateSampleUnitID]
		  ,@CAHPSSurveyType_ID = [CAHPSSurveyTypeID]
		  ,@CAHPSSurveySubtype_ID = [CAHPSSurveySubtypeID]
		  ,@RTSurveyType_ID = [RTSurveyTypeID]
		  ,@RTSurveySubtype_ID = [RTSurveySubtypeID]
		  ,@AsOfDate = ISNULL([AsOfDate], GetDate())
		  ,@TargetClient_ID = [TargetClientID]
		  ,@TargetStudy_id = [TargetStudyID]
		  --,@TargetSurvey_id = [TargetStudyID]
		  --,@Study_nm = [StudyName]
		  --,@Study_desc = [StudyDescription]
		  ,@Survey_nm = [SurveyName]
		  ,@SampleUnit_nm = [SampleUnitName]
		  ,@MedicareNumber = [MedicareNumber]
		  --,@ContractNumber = [ContractNumber]
		  --,@Survey_Start_Dt = [SurveyStartDate]
		  --,@Survey_End_Dt = [SurveyEndDate]
		  ,@LoggedBy = [LoggedBy]
		  --,@LoggedAt = [LoggedAt]
		  ,@CompletedNotes = [CompletedNotes]
		  ,@CompletedAt = [CompletedAt]
	  FROM [RTPhoenix].[TemplateJob]
	  where [TemplateJobID] = @TemplateJob_ID 

	if @TemplateJob_ID is null
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 SELECT -1, NULL, @TemplateLogEntryWarning, 'No Template Job Found To Process', SYSTEM_USER, GetDate()

		commit tran

		RETURN
	end

	declare @template_NM varchar(40)
	declare @user varchar(40) = @LoggedBy
	declare @study_id int 
	declare @client_id int

--@Template_ID must be assigned here if it is not already set because MakeSampleUnit may be the first called

	if @Template_ID is null or @Template_ID <= 0
	begin
		select @Template_ID = T.TemplateID 
		from RTPhoenix.Template t
			inner join RTPhoenix.ClientStudySurvey_viewTemplate cssv1 on t.TemplateID = cssv1.TemplateID
			inner join RTPhoenix.ClientStudySurvey_viewTemplate cssv2 on t.TemplateID = cssv2.TemplateID
		where cssv1.SurveyType_id = @CAHPSSurveyType_ID and
			IsNull(cssv1.Subtype_id, -1) = IsNull(@CAHPSSurveySubtype_ID, -1) and
			cssv2.SurveyType_id = @RTSurveyType_ID and
			IsNull(cssv2.Subtype_id, -1) = IsNull(@RTSurveySubtype_ID, -1) and
			@AsOfDate > isnull(T.BeginDate, '1/1/2001') and
			@AsOfDate < isnull(T.EndDate, '1/1/3001')

		update RTPhoenix.TemplateJob set [TemplateID] = @Template_ID
		where [TemplateJobID] = @TemplateJob_ID
	end

	SELECT @Template_ID = [TemplateID]
		  ,@client_id = [Client_ID]
		  ,@study_id = [Study_ID]
		  ,@Template_NM = [TemplateName]
	  FROM [RTPhoenix].[Template]
	  where [TemplateID] = @Template_ID
		and [Active] = 1

	if @study_id is null 
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 SELECT @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Template ID missing or not Active for TemplateJob_ID: '+convert(varchar,@TemplateJob_id), @user, GetDate()

		UPDATE [RTPhoenix].[TemplateJob]
		   SET [CompletedNotes] = 'Template ID missing or not Active for TemplateJob_ID: '+convert(varchar,@TemplateJob_id)
			  ,[CompletedAt] = GetDate()
		 WHERE [TemplateJobID] = @TemplateJob_ID

		commit tran

		RETURN
	end

	if (@TemplateSampleUnit_ID = 0)
		select @TemplateSampleUnit_ID = su.SAMPLEUNIT_ID,
			@TemplateSurvey_id = sd.SURVEY_ID from
			RTPhoenix.SAMPLEUNITTemplate su inner join
			RTPhoenix.SAMPLEPLANTemplate sp on su.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID inner join
			RTPhoenix.SURVEY_DEFTemplate sd on sp.SURVEY_ID = sd.SURVEY_ID inner join
			RTPhoenix.Template t on sd.STUDY_ID = t.Study_ID
		where t.TemplateID = @Template_ID
			and sd.STRSURVEY_NM = @Survey_nm
			and su.STRSAMPLEUNIT_NM = @SampleUnit_nm

	-- if @MedicareNumber is null, we assume this Sample Unit is not for CAHPS and continue
	-- if @MedicareNumber is not null, and does not exist in MedicareLookup this is an error
	
	IF @MedicareNumber is not null and NOT EXISTS(select 1 from [dbo].[MedicareLookup] where MedicareNumber = @MedicareNumber)
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'MedicareNumber ('+@MedicareNumber+') not found for TemplateJob_ID: '+convert(varchar,@TemplateJob_id), @user, GetDate())

		UPDATE [RTPhoenix].[TemplateJob]
		   SET [CompletedNotes] = 'Medicare Number not found for TemplateJob_ID: '+convert(varchar,@TemplateJob_id)
			  ,[CompletedAt] = GetDate()
		 WHERE [TemplateJobID] = @TemplateJob_ID

		commit tran
		
		RETURN
	end

	IF @MedicareNumber is not null and NOT EXISTS(select 1 from [dbo].[SUFacility]
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
		SELECT LEFT(db0.[MedicareName],100)
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
		  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID inner join
		  [dbo].[MedicareLookup] db0 on db0.MedicareNumber = @MedicareNumber
		  where Study_id = @study_id
			AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'SUFacility template (newest SUFacility ID: '+
				convert(nvarchar,Ident_Current('dbo.SUFacility'))+
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	END

	if not exists (select * from [dbo].[ClientSUFacilityLookup] csu inner join
						[dbo].[SUFacility] suf on csu.SUFacility_id = suf.SUFacility_id
						where suf.MedicareNumber = @MedicareNumber
							and csu.Client_id = @TargetClient_ID)
		INSERT INTO [dbo].[ClientSUFacilityLookup]([client_ID], [SUFacility_ID])
			select @TargetClient_ID, SUFacility_ID 
			from SUFacility 
			where MedicareNumber = @MedicareNumber

	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			select @Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			strFacility_nm + ' is SUFacility to be used for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate()
			from [dbo].[SUFacility] where MedicareNumber = @MedicareNumber
	if @@rowcount > 1
	begin
		rollback tran

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				select @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 
				'More than one SUFacility found for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate()

		RETURN
	end

	--check for sampleunit name and for survey name-medicare number also

	declare @targetSampleUnitName char(10) = @SampleUnit_nm
	if @targetSampleUnitName is not null
	begin
		if exists(select 1 from [dbo].[sampleunit] db0 inner join
					[dbo].[sampleplan] db1 on db0.SAMPLEPLAN_ID = db1.SAMPLEPLAN_ID inner join
					[dbo].[survey_def] db2 on db2.SURVEY_ID = db1.SURVEY_ID inner join
					[dbo].[study] db3 on db2.STUDY_ID = db3.STUDY_ID
				where 
					db3.study_id = @TargetStudy_ID and
					db2.STRSURVEY_NM = @Survey_nm and
					db0.STRSAMPLEUNIT_NM = CASE WHEN CAHPSType_id > 0 THEN 
												RTRIM(convert(nvarchar,@Survey_NM))+'-'+@MedicareNumber
											ELSE @targetSampleUnitName
											END
					)
		begin
			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 
					RTrim(convert(nvarchar,@targetSampleUnitName)) + ' sample unit already exists for Survey: '+convert(varchar,@Survey_nm), @user, GetDate())
		
			UPDATE [RTPhoenix].[TemplateJob]
			   SET [CompletedNotes] = RTrim(convert(nvarchar,@targetSampleUnitName)) + ' sample unit already exists for Survey: '+convert(varchar,@Survey_nm)
				  ,[CompletedAt] = GetDate()
			 WHERE [TemplateJobID] = @TemplateJob_ID

			commit tran

			RETURN
		end
	end
	else --indicates @targetSampleUnitName is null
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryWarning, 
				'Calling MakeSampleUnitsFromTemplate with SampleUnitName NULL is deprecated; TargetStudy_ID: '+convert(varchar,@TargetStudy_ID), @user, GetDate())
	end

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
	SELECT null --db01.[CRITERIASTMT_ID] --fill in later from job, else get from template
		  ,db02.[SAMPLEPLAN_ID]
		  ,null --[PARENTSAMPLEUNIT_ID] --fill in later from template
		  ,su.[STRSAMPLEUNIT_NM]--insert new sample unit name here only after inner joins dependent on the template's sample unit name
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
			[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id /*inner join
			[dbo].[CriteriaStmt] db01 on cs.STRCRITERIASTMT_NM = db01.STRCRITERIASTMT_NM and
						convert(varchar,cs.strCriteriaString) = convert(varchar,db01.strCriteriaString) */
					left join
			[dbo].[SUFacility] db04 on su.SUFacility_id <> 0 and 
						db04.MedicareNumber = @MedicareNumber
	WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id and
			cs.study_id = @study_id --and db01.study_id = @TargetStudy_id
	  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	  AND ((@TemplateSampleUnit_ID = -1) OR (su.SampleUnit_ID = @TemplateSampleUnit_ID))

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
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
	  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))

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
	  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	  AND ((@TemplateSampleUnit_ID = -1) OR (su.SampleUnit_ID = @TemplateSampleUnit_ID))

	--fill in SAMPLEUNIT.CriteriaStmt_ID later from job, else get from template

	declare @TargetSampleUnit_ID int = null

	set @TargetSampleUnit_ID = ident_current('dbo.sampleunit')

	if exists(select * from sampleunit where sampleunit_id = @TargetSampleUnit_ID and CAHPSType_id > 0)
	begin
		insert into CriteriaStmt (STUDY_ID,STRCRITERIASTMT_NM,strCriteriaString)
		values (@TargetStudy_ID,'SampUnit','(ENCOUNTERCCN = "'+@MedicareNumber+'")')

		declare @CriteriaStmtID int = ident_current('dbo.criteriastmt')
		declare @TableID int, @FieldID int
		select @TableID = Table_ID from MetaTable 
			where study_id = @TargetStudy_ID and strTable_NM = 'ENCOUNTER'
		select @FieldID = ms.Field_ID from MetaStructure ms inner join 
				MetaField mf on mf.field_id = ms.field_id 
			where Table_ID = @TableID and STRFIELD_NM = 'CCN'

		if @FieldID is null
		begin
			rollback tran

			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
					select @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 
					'CCN not found on ENCOUNTER table for Study:'+convert(varchar,@TargetStudy_id), @user, GetDate()

			return
		end		

		insert into CriteriaClause (CRITERIAPHRASE_ID, CRITERIASTMT_ID,TABLE_ID,FIELD_ID,INTOPERATOR,STRLOWVALUE,STRHIGHVALUE)
		values (1,@CriteriaStmtID,@TableID,@FieldID,1,@MedicareNumber,NULL)
	end
	else
	begin
		update db03 set [CRITERIASTMT_ID] = db04.[CRITERIASTMT_ID]
		--select su.STRSAMPLEUNIT_NM, db04.STRCRITERIASTRING, db04.STRCRITERIASTMT_NM
		  from [RTPhoenix].[SAMPLEUNITTemplate] su inner join
		  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
		  [RTPhoenix].SURVEY_DEFTemplate sd on sp.SURVEY_ID = sd.SURVEY_ID inner join
		  [RTPhoenix].[CRITERIASTMTTemplate] cs on cs.STUDY_ID = sd.STUDY_ID and
							su.CRITERIASTMT_ID = cs.CRITERIASTMT_ID inner join
				[dbo].[Survey_Def] db0 on sd.strsurvey_nm = db0.strsurvey_nm inner join
				[dbo].[SamplePlan] db02 on db02.survey_id = db0.survey_id inner join
				[dbo].[SampleUnit] db03 on db02.SAMPLEPLAN_ID = db03.SAMPLEPLAN_ID and
							db03.STRSAMPLEUNIT_NM = su.STRSAMPLEUNIT_NM
						inner join
				[dbo].[CriteriaStmt] db04 on db04.study_id = db0.study_id and
							db04.STRCRITERIASTMT_NM = cs.STRCRITERIASTMT_NM and
							convert(nvarchar,db04.strCriteriaString) = convert(nvarchar,cs.strCriteriaString)
		WHERE db0.study_id = @TargetStudy_id and sd.study_id = @study_id
		  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
		  AND ((@TemplateSampleUnit_ID = -1) OR (su.SampleUnit_ID = @TemplateSampleUnit_ID))
	end

	--end SAMPLEUNIT.CriteriaStmt_ID
				
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
	  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	  AND ((@TemplateSampleUnit_ID = -1) OR (su.SampleUnit_ID = @TemplateSampleUnit_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
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
	  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	  AND ((@TemplateSampleUnit_ID = -1) OR (su.SampleUnit_ID = @TemplateSampleUnit_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
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
	  AND ((@TemplateSurvey_ID = -1) OR (sd.SURVEY_ID = @TemplateSurvey_ID))
	  AND ((@TemplateSampleUnit_ID = -1) OR (su.SampleUnit_ID = @TemplateSampleUnit_ID))
				
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'SampleUnitSection template (row count:'+ 
				convert(varchar,@@RowCount) + 
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	SET @CompletedNotes = 'Completed Make Sample Units From Template for Study_id '+convert(varchar,@TargetStudy_ID)+
		' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

	if exists(select * from sampleunit where sampleunit_id = @TargetSampleUnit_ID and CAHPSType_id > 0)
	begin
		update dbo.SampleUnit 
			set  [CRITERIASTMT_ID] = @CriteriaStmtID
				,[STRSAMPLEUNIT_NM] = 
				CASE WHEN @MedicareNumber is not null 
					THEN RTRIM(convert(nvarchar,@Survey_NM))+'-'+@MedicareNumber 
					ELSE IsNull(@SampleUnit_nm, [STRSAMPLEUNIT_NM])
				END
		where sampleunit_id = @TargetSampleUnit_ID
	end

	declare @SampleUnitName varchar(42)
	select @SampleUnitName = [STRSAMPLEUNIT_NM] from sampleunit where sampleunit_id = @TargetSampleUnit_ID

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [SampleUnitName] = @SampleUnitName
		  ,[CompletedNotes] = @CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE [TemplateJobID] = @TemplateJob_ID

	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Completed Make Sample Units From Template for TemplateJob_id '+convert(varchar,@TemplateJob_ID)+
		 ', Study '+convert(varchar,@TargetStudy_id)+')', @user, GetDate())

	commit tran

end try
begin catch
	rollback tran

	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			SELECT @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Make Sample Units From Template Job did not succeed and was rolled back', SYSTEM_USER, GetDate()

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [CompletedNotes] = 'Make Sample Units From Template Job did not succeed and was rolled back: '+@CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE [TemplateJobID] = @TemplateJob_ID
end catch

end

GO