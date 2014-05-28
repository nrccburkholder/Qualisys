--Note that a few non-Contraint bound tables are deleted in this SP (QUESTIONRESULT,QuestionResult2,SENTMAILING,UNITDQ)

Create procedure DODBen_DeleteConstraintBoundTables
 @study_id int
AS
declare @rc int,@myError int,@myRowCount int,@expectedCount int

/* Delete the data that is in the base structure */
BEGIN TRANSACTION
	EXEC @rc=DODBen_DeleteTable @study_id, 'questionform_id', 'questionresult'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'questionform_id', 'questionresult2'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'questionform_id', 'questionform'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'cutoff'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	update dbo.scheduledmailing
	set sentmail_id = NULL
	from dbo.scheduledmailing scm, dbo.mailingmethodology mm, dbo.survey_def s
	where s.survey_id = mm.survey_id and mm.methodology_id = scm.methodology_id
	and s.study_id = @study_id
	SELECT @myError = @@Error, @myRowCount=@@rowcount
	exec DODBen_InsertDeletionLogRecord @study_id, 'scheduledmailing', 'Update', @myRowCount, @myError 
	if @myError <> 0
	begin
		ROLLBACK TRANSACTION 
		Return -1
	end

	EXEC @rc=DODBen_DeleteTable @study_id, 'sentmail_id', 'sentmailing'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'ScheduledMailing_id', 'scheduledmailing'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'selectedsample'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'samplepop'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'recurringencounter'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'tocl'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'unitdq'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'dataset_id', 'datasetmember'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'dataset_id', 'SAMPLEDATASET'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'sampleset_id', 'sampleset'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	update dbo.sampleplan
	set rootsampleunit_id=null
	from dbo.sampleplan ss, dbo.survey_def sd
	where ss.survey_id=sd.survey_id
	and sd.study_id = @study_id
	SELECT @myError = @@Error, @myRowCount=@@rowcount
	exec DODBen_InsertDeletionLogRecord @study_id, 'sampleplan', 'Update', @myRowCount, @myError, @ExpectedCount 
	if @myError <> 0
	begin
		ROLLBACK TRANSACTION 
		Return -1
	end

	EXEC @rc=DODBen_DeleteTable @study_id, 'cmnt_id', 'QDECommentSelCodes'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'cmnt_id', 'QDECOMMENTS'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'QDEFORM'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'sampleunit_id', 'SAMPLEUNITSECTION'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'sampleunit_id', 'sampleunit'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'REPORTINGHIERARCHY'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'sampleplan'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'DispositionListSurvey'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'PCLGENLOG'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END


	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'Period'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'Survey_SurveyTypeDef'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'MAILINGSTEP'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'survey_id', 'MAILINGMETHODOLOGY'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'SURVEY_DEF'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'DATA_SET'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'criteriaclause_id', 'CRITERIAINLIST'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'CRITERIASTMT_id', 'CRITERIACLAUSE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'table_id', 'HOUSEHOLDRULE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'NUMLKUPTABLE_ID', 'METALOOKUP'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'NUMMASTERTABLE_ID', 'METALOOKUP'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'TAGEXCEPTION'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'TAGFIELD'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'table_id', 'METASTRUCTURE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'STUDY_EMPLOYEE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END


	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'STUDYCOMPARISON'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'STUDYDELIVERYDATE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'STUDYREPORTTYPE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'BUSINESSRULE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'METATABLE'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'CRITERIASTMT'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END

	EXEC @rc=DODBen_DeleteTable @study_id, 'study_id', 'Study'
	IF @RC<>0 or @@error<>0  
	BEGIN
		Rollback Tran
		return -1
	END
COMMIT TRANSACTION


