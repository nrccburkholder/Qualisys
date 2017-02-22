/*
S68 RTP-1352 Break out RTPhoenix-MakeStudyFromTemplate.sql

Chris Burkholder

2/14/2017

CREATE PROCEDURE RTPhoenix.MakeStudyFromTemplate
--DROP PROCEDURE RTPhoenix.MakeStudyFromTemplate
*/
Use [QP_Prod]
GO

CREATE PROCEDURE [RTPhoenix].[MakeStudyFromTemplate]
	@TemplateJob_ID int
AS
begin

begin try

	begin tran

		  declare @TemplateJobType_ID int
		  declare @Template_ID int
		  declare @TemplateSurvey_ID int
		  --declare @TemplateSampleUnit_ID int		
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
		  --declare @Survey_nm varchar(10)
		  --declare @SampleUnit_nm varchar(42) 
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
		  --,@TemplateSampleUnit_ID = [TemplateSampleUnitID]
		  ,@CAHPSSurveyType_ID = [CAHPSSurveyTypeID]
		  ,@CAHPSSurveySubtype_ID = [CAHPSSurveySubtypeID]
		  ,@RTSurveyType_ID = [RTSurveyTypeID]
		  ,@RTSurveySubtype_ID = [RTSurveySubtypeID]
		  ,@AsOfDate = ISNULL([AsOfDate], GetDate())
		  ,@TargetClient_ID = [TargetClientID]
		  ,@TargetStudy_id = [TargetStudyID]
		  ,@TargetSurvey_id = [TargetStudyID]
		  ,@Study_nm = [StudyName]
		  ,@Study_desc = [StudyDescription]
		  --,@Survey_nm = [SurveyName]
		  --,@SampleUnit_nm = [SampleUnitName]
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

	if not exists(select 1 from [dbo].[client] where client_id = @TargetClient_ID)
	begin
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Client ID missing for TemplateJob_ID: '+convert(varchar,@TemplateJob_id), @user, GetDate())
		
		UPDATE [RTPhoenix].[TemplateJob]
		   SET [CompletedNotes] = 'Client ID missing for TemplateJob_ID: '+convert(varchar,@TemplateJob_id)
			  ,[CompletedAt] = GetDate()
		 WHERE [TemplateJobID] = @TemplateJob_ID

		commit tran

		RETURN
	end

	IF NOT EXISTS(select 1 from [dbo].[MedicareLookup] where MedicareNumber = @MedicareNumber)
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


	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Template to Import Found: '+convert(varchar,@Template_id), @user, GetDate())

	if not exists(select 1 from [dbo].[study] where study_id = @TargetStudy_ID)
	begin
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
			  ,IsNull(@Study_NM,[STRSTUDY_NM])
			  ,IsNull(@Study_Desc,[STRSTUDY_DSC])
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

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Study Table Inserted from Template for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

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
		WHERE db0.study_id = @TargetStudy_id and mt.study_id = @study_id

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'META tables template (MetaStructure row count:'+ 
			 convert(varchar,@@RowCount) + ') imported for study_id '+
			 convert(varchar,@TargetStudy_id), @user, GetDate())

		INSERT INTO [dbo].[METALOOKUP]
				   ([NUMMASTERTABLE_ID]
				   ,[NUMMASTERFIELD_ID]
				   ,[NUMLKUPTABLE_ID]
				   ,[NUMLKUPFIELD_ID]
				   ,[STRLKUP_TYPE])
		SELECT db0.table_id
			  ,[NUMMASTERFIELD_ID]
			  ,db1.table_id
			  ,[NUMLKUPFIELD_ID]
			  ,[STRLKUP_TYPE]
		  FROM [RTPhoenix].[METALOOKUPTemplate] ml inner join
				[RTPhoenix].[METATABLETemplate] mt on ml.NUMMASTERTABLE_ID = mt.TABLE_ID inner join
				[dbo].[METATABLE] db0 on mt.strtable_nm = db0.strtable_nm inner join
				[RTPhoenix].[METATABLETemplate] mt2 on ml.NUMLKUPTABLE_ID = mt2.TABLE_ID inner join
				[dbo].[METATABLE] db1 on mt2.strtable_nm = db1.strtable_nm
				where db0.Study_id = @TargetStudy_id and db1.Study_id = @TargetStudy_id and 
					mt.Study_id = @Study_id and mt2.Study_id = @Study_id 
	end

	INSERT INTO [dbo].[CRITERIASTMT]
			   ([STUDY_ID]
			   ,[STRCRITERIASTMT_NM]
			   ,[strCriteriaString])
	SELECT @TargetStudy_id
		  ,[STRCRITERIASTMT_NM]
		  ,[strCriteriaString]
	  FROM [RTPhoenix].[CRITERIASTMTTemplate]
	  where Study_id = @study_id

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
				'CriteriaStmt template (row count:'+ 
				convert(varchar,@@RowCount) + 
				') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[CRITERIACLAUSE] 
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
			[dbo].[METATABLE] db0 on mt.strtable_nm = db0.strtable_nm inner join
			[dbo].[CriteriaStmt] db01 on cs.STRCRITERIASTMT_NM = db01.STRCRITERIASTMT_NM and
						convert(varchar,cs.strCriteriaString) = convert(varchar,db01.strCriteriaString) and
						cs.study_id = @study_id and db01.study_id = @TargetStudy_id
	WHERE db0.study_id = @TargetStudy_id and mt.study_id = @study_id

		declare @ccRowCount int = @@RowCount

	--Eliminate duplicate criteriaclause rows having the higher id
	delete cc1
	--select cc1.* 
	from [dbo].[criteriaclause] cc1 inner join
	[dbo].[criteriaclause] cc2 on cc1.criteriastmt_id = cc2.criteriastmt_id and
						cc1.criteriaphrase_id = cc2.criteriaphrase_id 
	inner join [dbo].[criteriastmt] cs on cs.criteriastmt_id = cc1.criteriastmt_id
	where cs.study_id = @TargetStudy_id and cc1.CRITERIACLAUSE_ID > cc2.CRITERIACLAUSE_ID

		set @ccRowCount = @ccRowCount - @@RowCount
				
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'CriteriaClause template (row count:'+ 
			 convert(varchar,@ccRowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[CRITERIAINLIST] 
			   ([CRITERIACLAUSE_ID]
			   ,[STRLISTVALUE])
	SELECT db01.[CRITERIACLAUSE_ID]
		  ,ci.[STRLISTVALUE]
	  FROM [RTPhoenix].[CRITERIAINLISTTemplate] ci inner join
	  [RTPhoenix].[CRITERIACLAUSETemplate] cc on ci.CRITERIACLAUSE_ID = cc.CRITERIACLAUSE_ID inner join
	  [RTPhoenix].[CRITERIASTMTTemplate] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID inner join
			[dbo].[CriteriaStmt] db0 on cs.STRCRITERIASTMT_NM = db0.STRCRITERIASTMT_NM inner join
			[dbo].[CRITERIACLAUSE] db01 on db01.CRITERIASTMT_ID = db0.CRITERIASTMT_ID and
						db01.CRITERIAPHRASE_ID = cc.CRITERIAPHRASE_ID
	WHERE cs.study_id = @study_id and db0.study_id = @TargetStudy_id
				
		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'CriteriaInList template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())


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
			[dbo].[METATABLE] db0 on db0.STRTABLE_NM = mt.STRTABLE_NM 
	WHERE db0.study_id = @TargetStudy_ID and mt.STUDY_ID = @study_id

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'TagField template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [dbo].[STUDY_EMPLOYEE] 
			   ([EMPLOYEE_ID]
			   ,[STUDY_ID])
	SELECT [EMPLOYEE_ID]
		  ,@TargetStudy_ID
	  FROM [RTPhoenix].[STUDY_EMPLOYEETemplate]
	  where Study_id = @study_id and Employee_id not in
	  (select Employee_id from [dbo].[study_employee] where study_id = @TargetStudy_ID)

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'Study_Employee template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	commit tran

end try
begin catch
	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			SELECT @Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Make Study From Template Job did not succeed and was rolled back', SYSTEM_USER, GetDate()

	rollback tran
end catch

	INSERT INTO [QLoader].[QP_Load].[dbo].[Package]
			   ([intVersion]
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
	SELECT [intVersion]
		  ,[strPackage_nm]
		  ,@TargetClient_ID
		  ,@TargetStudy_ID
		  ,[intTeamNumber]
		  ,[strLogin_nm]
		  ,[datLastModified]
		  ,[bitArchive]
		  ,[datArchive]
		  ,[FileType_id]
		  ,[FileTypeSettings]
		  ,[SignOffBy_id]
		  ,[datCreated]
		  ,[strPackageFriendly_nm]+convert(nvarchar,@TargetStudy_id)
		  ,[bitActive]
		  ,[bitDeleted]
		  ,[OwnerMember_id]
	  FROM [RTPhoenix].[PackageQLTemplate]
	  where Study_id = @Study_id

	Declare @Package_id int
	Select @Package_id = Package_id from [QLoader].[QP_Load].[dbo].[Package]
	where Study_id = @TargetStudy_id

	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			'QLoader Package template (Package ID: '+
			convert(nvarchar,@Package_id)+
			') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [QLoader].[QP_Load].[dbo].[Destination]
			   ([Package_id]
			   ,[intVersion]
			   ,[Table_id]
			   ,[Field_id]
			   ,[Formula]
			   ,[bitNULLCount]
			   ,[intFreqLimit]
			   ,[Sources])
	SELECT db0.[Package_id]
		  ,d.[intVersion]
		  ,db1.Table_id
		  ,d.[Field_id]
		  ,[Formula]
		  ,[bitNULLCount]
		  ,[intFreqLimit]
		  ,[Sources]
	  FROM [RTPhoenix].[DestinationQLTemplate] d inner join
	  [RTPhoenix].[PackageQLTemplate] p on d.Package_id = p.Package_id and p.Study_id = @study_id inner join
	  [RTPhoenix].[METATABLETemplate] mt on mt.TABLE_ID = d.table_id inner join
			[QLoader].[QP_Load].[dbo].[Package] db0 on db0.study_id = @TargetStudy_ID inner join
			[dbo].[METATABLE] db1 on db1.STUDY_ID = @TargetStudy_ID and db1.STRTABLE_NM = mt.STRTABLE_NM inner join
			[dbo].[METASTRUCTURE] db2 on db2.TABLE_ID = db1.TABLE_ID and db2.FIELD_ID = d.Field_id 

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'QLoader Destination template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	INSERT INTO [QLoader].[QP_Load].[dbo].[Source]
			   ([Package_id]
			   ,[intVersion]
			   ,[strName]
			   ,[strAlias]
			   ,[intLength]
			   ,[DataType_id]
			   ,[Ordinal])
	SELECT db0.[Package_id]
		  ,s.[intVersion]
		  ,[strName]
		  ,[strAlias]
		  ,[intLength]
		  ,[DataType_id]
		  ,[Ordinal]
	  FROM [RTPhoenix].[SourceQLTemplate] s inner join
	  [RTPhoenix].[PackageQLTemplate] p on s.Package_id = p.Package_id and p.Study_id = @study_id inner join
			[QLoader].[QP_Load].[dbo].[Package] db0 on db0.study_id = @TargetStudy_ID 

		INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 
			 'QLoader Source template (row count:'+ 
			 convert(varchar,@@RowCount) + 
			 ') imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	/* -- DTSMapping is not needed for RTPhoenix ingestion -- CJB 2/3/2017
	INSERT INTO [QLoader].[QP_Load].[dbo].[DTSMapping]
			   ([intVersion]
			   ,[Source_id]
			   ,[Destination_id]
			   ,[Package_id])
	SELECT [intVersion]
		  ,[Source_id]
		  ,[Destination_id]
		  ,[Package_id]
	  FROM [RTPhoenix].[DTSMappingQLTemplate]
	*/

	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'QLoader template tables imported for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	SET @CompletedNotes = 'Completed import of Study_id '+convert(varchar,@TargetStudy_ID)+
		' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [TargetClientID] = @TargetClient_ID
		  ,[TargetStudyID] = @TargetStudy_ID
		  ,[StudyName] = @Study_nm
		  ,[StudyDescription] = @Study_desc
		  ,[CompletedNotes] = @CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE [TemplateJobID] = @TemplateJob_ID

	INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Completed TemplateJob '+convert(varchar,@TemplateJob_ID)+
		 ', Client/Study '+convert(varchar,@TargetClient_id)+'/'+convert(varchar,@TargetStudy_id)+')', @user, GetDate())

	--Insert a ProcessStudyOwnedTables job

	INSERT INTO [RTPhoenix].[TemplateJob]
			   ([TemplateJobTypeID]
			   ,[MasterTemplateJobID]
			   ,[TemplateID]
			   ,[TemplateSurveyID]
			   ,[TemplateSampleUnitID]
			   ,[CAHPSSurveyTypeID]
			   ,[CAHPSSurveySubtypeID]
			   ,[RTSurveyTypeID]
			   ,[RTSurveySubtypeID]
			   ,[AsOfDate]
			   ,[TargetClientID]
			   ,[TargetStudyID]
			   ,[TargetSurveyID]
			   ,[StudyName]
			   ,[StudyDescription]
			   ,[SurveyName]
			   ,[SampleUnitName]
			   ,[MedicareNumber]
			   ,[ContractNumber]
			   ,[SurveyStartDate]
			   ,[SurveyEndDate]
			   ,[MethodologyID]
			   ,[LanguageID]
			   ,[LoggedBy]
			   ,[LoggedAt]
			   ,[CompletedNotes]
			   ,[CompletedAt])
	SELECT 4--[TemplateJobTypeID]
		  ,@TemplateJob_ID--[MasterTemplateJobID]
		  ,[TemplateID]
		  ,[TemplateSurveyID]
		  ,[TemplateSampleUnitID]
		  ,[CAHPSSurveyTypeID]
		  ,[CAHPSSurveySubtypeID]
		  ,[RTSurveyTypeID]
		  ,[RTSurveySubtypeID]
		  ,[AsOfDate]
		  ,[TargetClientID]
		  ,[TargetStudyID]
		  ,[TargetSurveyID]
		  ,[StudyName]
		  ,[StudyDescription]
		  ,[SurveyName]
		  ,[SampleUnitName]
		  ,[MedicareNumber]
		  ,[ContractNumber]
		  ,[SurveyStartDate]
		  ,[SurveyEndDate]
		  ,[MethodologyID]
		  ,[LanguageID]
		  ,[LoggedBy]
		  ,getdate()
		  ,null
		  ,null
	  FROM [RTPhoenix].[TemplateJob]
	  WHERE [TemplateJobID] = @TemplateJob_ID

	--Determine if a MakeSurveysFromTemplate job is needed and add (if so)

	if @TemplateSurvey_ID = -1 -- -1 means all surveys
		INSERT INTO [RTPhoenix].[TemplateJob]
				   ([TemplateJobTypeID]
				   ,[MasterTemplateJobID]
				   ,[TemplateID]
				   ,[TemplateSurveyID]
				   ,[TemplateSampleUnitID]
				   ,[CAHPSSurveyTypeID]
				   ,[CAHPSSurveySubtypeID]
				   ,[RTSurveyTypeID]
				   ,[RTSurveySubtypeID]
				   ,[AsOfDate]
				   ,[TargetClientID]
				   ,[TargetStudyID]
				   ,[TargetSurveyID]
				   ,[StudyName]
				   ,[StudyDescription]
				   ,[SurveyName]
				   ,[SampleUnitName]
				   ,[MedicareNumber]
				   ,[ContractNumber]
				   ,[SurveyStartDate]
				   ,[SurveyEndDate]
				   ,[MethodologyID]
				   ,[LanguageID]
				   ,[LoggedBy]
				   ,[LoggedAt]
				   ,[CompletedNotes]
				   ,[CompletedAt])
		SELECT 2--[TemplateJobTypeID]
			  ,@TemplateJob_ID--[MasterTemplateJobID]
			  ,tj.[TemplateID]
			  ,sd.Survey_ID
			  ,[TemplateSampleUnitID]
			  ,[CAHPSSurveyTypeID]
			  ,[CAHPSSurveySubtypeID]
			  ,[RTSurveyTypeID]
			  ,[RTSurveySubtypeID]
			  ,[AsOfDate]
			  ,[TargetClientID]
			  ,[TargetStudyID]
			  ,[TargetSurveyID]
			  ,[StudyName]
			  ,[StudyDescription]
			  ,IsNull([SurveyName], sd.strSurvey_NM)
			  ,[SampleUnitName]
			  ,[MedicareNumber]
			  ,[ContractNumber]
			  ,[SurveyStartDate]
			  ,[SurveyEndDate]
			  ,[MethodologyID]
			  ,[LanguageID]
			  ,[LoggedBy]
			  ,getdate()
			  ,null
			  ,null
		  FROM [RTPhoenix].[TemplateJob] tj
		  INNER JOIN [RTPhoenix].[Template] t on tj.TemplateID = t.TemplateID
		  INNER JOIN [RTPhoenix].[Survey_DefTemplate] sd on sd.STUDY_ID = t.Study_ID
		  WHERE [TemplateJobID] = @TemplateJob_ID
	else
	if @TemplateSurvey_ID > 0 -- if >0, then a survey ID, or -1 means all surveys
		INSERT INTO [RTPhoenix].[TemplateJob]
				   ([TemplateJobTypeID]
				   ,[MasterTemplateJobID]
				   ,[TemplateID]
				   ,[TemplateSurveyID]
				   ,[TemplateSampleUnitID]
				   ,[CAHPSSurveyTypeID]
				   ,[CAHPSSurveySubtypeID]
				   ,[RTSurveyTypeID]
				   ,[RTSurveySubtypeID]
				   ,[AsOfDate]
				   ,[TargetClientID]
				   ,[TargetStudyID]
				   ,[TargetSurveyID]
				   ,[StudyName]
				   ,[StudyDescription]
				   ,[SurveyName]
				   ,[SampleUnitName]
				   ,[MedicareNumber]
				   ,[ContractNumber]
				   ,[SurveyStartDate]
				   ,[SurveyEndDate]
				   ,[MethodologyID]
				   ,[LanguageID]
				   ,[LoggedBy]
				   ,[LoggedAt]
				   ,[CompletedNotes]
				   ,[CompletedAt])		
		SELECT 2--[TemplateJobTypeID]
			  ,@TemplateJob_ID--[MasterTemplateJobID]
			  ,[TemplateID]
			  ,[TemplateSurveyID]
			  ,[TemplateSampleUnitID]
			  ,[CAHPSSurveyTypeID]
			  ,[CAHPSSurveySubtypeID]
			  ,[RTSurveyTypeID]
			  ,[RTSurveySubtypeID]
			  ,[AsOfDate]
			  ,[TargetClientID]
			  ,[TargetStudyID]
			  ,[TargetSurveyID]
			  ,[StudyName]
			  ,[StudyDescription]
			  ,[SurveyName]
			  ,[SampleUnitName]
			  ,[MedicareNumber]
			  ,[ContractNumber]
			  ,[SurveyStartDate]
			  ,[SurveyEndDate]
			  ,[MethodologyID]
			  ,[LanguageID]
			  ,[LoggedBy]
			  ,getdate()
			  ,null
			  ,null
		  FROM [RTPhoenix].[TemplateJob]
		  WHERE [TemplateJobID] = @TemplateJob_ID

end
