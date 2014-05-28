/* This procedure will rollback the formgen of an entire survey. */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
CREATE procedure sp_rollback_formgen
	@study_id int,
	@survey_id int = NULL,
	@cascade tinyint = 1
as
	declare @rc int

	if @cascade = 1
	begin
		exec @rc=dbo.sp_rollback_pclgen @study_id, @survey_id, @cascade
		if @@error <> 0 OR @rc <> 0
			return -1
	end

	print 'Rolling back FormGen'

	CREATE TABLE #delformgen (
		survey_id int
	)
	IF @survey_id IS NULL
	BEGIN
		INSERT INTO #delformgen (survey_id)
		SELECT survey_id
		FROM dbo.survey_def
		WHERE study_id = @study_id
		if @@error <> 0
			return -1
	END
	ELSE
	BEGIN
		INSERT INTO #delformgen (survey_id) VALUES (@survey_id)
		if @@error <> 0
			return -1
	END

	BEGIN TRANSACTION

	print 'Deleting survey from dbo.PCLNeeded'
	delete dbo.PCLNeeded
	from #delformgen
	where dbo.pclneeded.survey_id = #delformgen.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

/*	print 'Deleting survey from dbo.Qstns_Individual'
	delete dbo.Qstns_Individual
	from dbo.qstns_individual qi, dbo.questionform qf, #delformgen df
	where qi.questionform_id = qf.questionform_id
	and qi.survey_id = qf.survey_id
	and qf.survey_id = df.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.Scls_Individual'
	delete dbo.Scls_Individual
	from dbo.scls_individual qi, dbo.questionform qf, #delformgen df
	where qi.questionform_id = qf.questionform_id
	and qi.survey_id = qf.survey_id
	and qf.survey_id = df.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.TextBox_Individual'
	delete dbo.TextBox_Individual
	from #delformgen
	where dbo.Textbox_Individual.survey_id = #delformgen.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end
*/
	print 'Deleting survey from dbo.QuestionForm'
	delete dbo.QuestionForm
	from #delformgen
	where dbo.QuestionForm.survey_id = #delformgen.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

/*	print 'Deleting survey from dbo.PCLGenRun'
	delete dbo.PCLGenRun
	from dbo.PCLGenRun pgr, dbo.PCLGenLog pgl, #delformgen df
	where pgr.pclgenrun_id = pgl.pclgenrun_id
	and pgl.survey_id = df.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end
*/
	print 'Deleting survey from dbo.PCLGenLog'
	delete dbo.PCLGenLog 
	from dbo.PCLGenLog pgl, #delformgen df
	where pgl.survey_id = df.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.SentMailing'
	delete dbo.SentMailing
	from dbo.sentmailing smg, dbo.scheduledmailing sm, dbo.mailingstep ms,
		#delformgen df
	where smg.scheduledmailing_id = sm.scheduledmailing_id
	and sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = df.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.FormGenError'
	delete dbo.FormGenError
	from dbo.formgenerror fge, dbo.scheduledmailing sm, dbo.mailingstep ms, #delformgen df
	where fge.scheduledmailing_id = sm.scheduledmailing_id
	and sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = df.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

/* We will delete all but the first ScheduledMailing step, this will be deleted by the
** sampling rollback if that is what called us.
*/
	print 'Deleting survey from dbo.ScheduledMailing Scheduled Items'
	delete dbo.ScheduledMailing
	from dbo.scheduledmailing sm, dbo.mailingstep ms, #delformgen df
	where sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = df.survey_id
	and ms.intsequence > 1
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

/* We need to set the SentMail_id in the ScheduledMailing records to NULL. */
	print 'Updating survey from dbo.ScheduledMailing Sent Items'
	update dbo.ScheduledMailing
	set sentmail_id = NULL
	from dbo.ScheduledMailing sm, dbo.mailingstep ms, #delformgen df
	where sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = df.survey_id
	and ms.intsequence = 1
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Finished rolling back FormGen'
	COMMIT TRANSACTION
	return 0


