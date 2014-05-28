/* Create the rollback for Scanning */
/* This procedure will rollback the Scans of an entire study/survey. */
create procedure sp_rollback_scanning
	@study_id int,
	@survey_id int = NULL,
	@cascade tinyint = 1
as
	declare @rc int
	if @cascade = 1
	begin
		exec @rc=dbo.sp_rollback_export @study_id, @survey_id, @cascade
		if @@error <> 0 OR @rc <> 0
			return -1
	end

	print 'Deleting Scanning'
	CREATE TABLE #delscan (
		survey_id int
	)
	IF @survey_id IS NULL
	BEGIN
		INSERT INTO #delscan (survey_id)
		SELECT survey_id
		FROM dbo.survey_def
		WHERE study_id = @study_id
		if @@error <> 0
			return -1
	END
	ELSE
	BEGIN
		INSERT INTO #delscan (survey_id) VALUES (@survey_id)
		if @@error <> 0
			return -1
	END

	BEGIN TRANSACTION

	print 'Deleting survey from dbo.QuestionResult'
	DELETE dbo.QuestionResult
	FROM dbo.QuestionResult qr, dbo.QuestionForm qf, #delscan ds
	WHERE qr.questionform_id = qf.questionform_id
	AND qf.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.ScanImportError'
	DELETE dbo.ScanImportError
	FROM dbo.ScanImportError see, dbo.SentMailing smg, dbo.ScheduledMailing sm, dbo.mailingstep ms, #delscan ds
	WHERE see.strLithoCode = smg.strLithoCode
	AND smg.scheduledmailing_id = sm.scheduledmailing_id
	AND sm.mailingstep_id = ms.mailingstep_id
	AND ms.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.ScanExportError'
	DELETE dbo.ScanExportError
	FROM dbo.ScanExportError see, dbo.SentMailing smg, dbo.ScheduledMailing sm, dbo.mailingstep ms, #delscan ds
	WHERE see.strLithoCode = smg.strLithoCode
	AND smg.scheduledmailing_id = sm.scheduledmailing_id
	AND sm.mailingstep_id = ms.mailingstep_id
	AND ms.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

/* Thank you's only. */
	print 'Deleting survey from dbo.SentMailing, thank you items only'
	delete dbo.SentMailing
	from dbo.sentmailing smg, dbo.scheduledmailing sm, dbo.mailingstep ms, #delscan df
	where smg.scheduledmailing_id = sm.scheduledmailing_id
	and sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = df.survey_id
	and ms.bitThankYouItem = 1
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

/* Thank you's only. */
	print 'Deleting survey from dbo.ScheduledMailing Sent Items, thank you items only'
	delete dbo.ScheduledMailing
	from dbo.ScheduledMailing sm, dbo.mailingstep ms, #delscan df
	where sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = df.survey_id
	and ms.bitThankYouItem = 1
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Updating SentMailing datUndeliverable'
	update dbo.sentmailing
	set datUndeliverable = NULL
	from dbo.sentmailing smg, dbo.scheduledmailing sm, dbo.mailingstep ms, #delscan ds
	where smg.scheduledmailing_id = sm.scheduledmailing_id
	and sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Updating QuestionForm datReturned'
	UPDATE dbo.QuestionForm
	SET datReturned = NULL
	FROM #delscan
	WHERE dbo.QuestionForm.survey_id = #delscan.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end
	COMMIT TRANSACTION


