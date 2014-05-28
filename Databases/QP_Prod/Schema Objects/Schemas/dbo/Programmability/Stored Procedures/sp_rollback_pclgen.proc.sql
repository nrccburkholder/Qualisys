/* Create the rollback for PCLGen */
/* This procedure will rollback the pclgen of an entire survey. */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
create procedure sp_rollback_pclgen
	@study_id int,
	@survey_id int = NULL,
	@cascade tinyint = 1
as
	declare @rc int
	if @cascade = 1
	begin
		exec @rc = dbo.sp_rollback_scanning @study_id, @survey_id, @cascade
		if @@error <> 0 OR @rc <> 0
			return -1
	end

	print 'Rolling back PCLGen'
	
	CREATE TABLE #delpclgen (
		survey_id int
	)
	IF @survey_id IS NULL
	BEGIN
		INSERT INTO #delpclgen (survey_id)
		SELECT survey_id
		FROM dbo.survey_def
		WHERE study_id = @study_id
		if @@error <> 0
			return -1
	END
	ELSE
	BEGIN
		INSERT INTO #delpclgen (survey_id) VALUES (@survey_id)
		if @@error <> 0
			return -1
	END

	BEGIN TRANSACTION
	print 'Deleting survey from dbo.PCLOutput'

	delete dbo.PCLOutput
	from dbo.PCLOutput pclo, dbo.SentMailing smg, dbo.ScheduledMailing sm, 
	     dbo.mailingstep ms, #delpclgen dp
	where pclo.sentmail_id = smg.sentmail_id
	and smg.scheduledmailing_id = sm.scheduledmailing_id
	and sm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.BubbleItemPos'
	delete dbo.bubbleitempos
	from dbo.bubbleitempos bip, dbo.bubblepos bp, dbo.questionform qf, #delpclgen dp
	where bip.questionform_id = bp.questionform_id
	and bip.sampleunit_id = bp.sampleunit_id
	and bip.intpage_num = bp.intpage_num
	and bip.qstncore = bp.qstncore
	and bp.questionform_id = qf.questionform_id
	and qf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.BubblePos'
	delete dbo.bubblepos
	from dbo.bubblepos bp, dbo.questionform qf, #delpclgen dp
	where bp.questionform_id = qf.questionform_id
	and qf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.CommentLinePos'
	delete dbo.CommentLinePos
	from dbo.commentlinepos cip, dbo.commentpos cp, dbo.questionform qf, #delpclgen dp
	where cip.questionform_id = cp.questionform_id
	and cip.intpage_num = cp.intpage_num
	and cip.cmntbox_id = cp.cmntbox_id
	and cip.sampleunit_id = cp.sampleunit_id
	and cp.questionform_id = qf.questionform_id
	and qf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.CommentPos'
	delete dbo.commentpos
	from dbo.commentpos cp, dbo.questionform qf, #delpclgen dp
	where cp.questionform_id = qf.questionform_id
	and qf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.BubbleLoc'
	DELETE	dbo.BubbleLoc
	FROM	dbo.PCLQuestionForm pclqf, dbo.PCLResults pclr, dbo.BubbleLoc bl,
			#delpclgen dp
	WHERE	pclqf.questionform_id = pclr.questionform_id
	AND	pclr.questionform_id = bl.questionform_id
	AND	pclr.selqstns_id = bl.selqstns_id
	AND	pclr.sampleunit_id = bl.sampleunit_id
	AND	pclqf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.CommentLoc'
	DELETE	dbo.CommentLoc
	FROM	dbo.PCLQuestionForm pclqf, dbo.PCLResults pclr, dbo.CommentLoc cl, 
			#delpclgen dp
	WHERE	pclqf.questionform_id = pclr.questionform_id
	AND	pclr.questionform_id = cl.questionform_id
	AND	pclr.selqstns_id = cl.selqstns_id
	AND	pclr.sampleunit_id = cl.sampleunit_id
	AND	pclqf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.PCLResults'
	DELETE	dbo.PCLResults
	FROM	dbo.PCLQuestionForm pclqf, dbo.PCLResults pclr, #delpclgen dp
	WHERE	pclqf.questionform_id = pclr.questionform_id
	AND	pclqf.survey_id = dp.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.PCLQuestionForm'
	DELETE dbo.PCLQuestionForm
	FROM #delpclgen
	WHERE	dbo.PCLQuestionForm.survey_id = #delpclgen.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Finished rolling back PCLGen'
	COMMIT TRANSACTION
	return 0


