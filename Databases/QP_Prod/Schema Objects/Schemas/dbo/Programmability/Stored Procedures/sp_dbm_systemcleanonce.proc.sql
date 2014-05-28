/* This stored procedure will delete records from the following tables once their mailing date
** is eight weeks old.  These records are all related to the generation of a questionnaire
** and required scanning information.  This means all returned questionnaires that had mailing
** date more than eight weeks old will no be scanned, nor reprintable, and therefore will not
** be reported.  The tables are...
** Bubblepos, BubbleItemPos, PCLOutput, CommentLinePos, CommentPos
**
** Created by: Daniel Vansteenburg, 9/17/1999
** Modified by:  Brian Dohmen, 4/27/00 to move entries to qp_scanner database prior to deleting and then dumping the qp_scanner database to disk
*/
CREATE procedure dbo.sp_dbm_systemcleanonce
as
	declare @expiredays int
	declare @batchsize int
	declare @pcloexpiredays int

/* Get the expiration days from QualPro params.  Since we are expiring, we are going into
** the past, the numparam_value is a positive number, do we need to turn it into a negative.
*/
	select @expiredays = numparam_value * -1
	from dbo.qualpro_params
	where strparam_nm = 'DaysToExpire'
	and strparam_grp = 'DBManager'

/* Get the PCLOutput expiration days from QualPro params.  Since we are expiring, we are going into
** the past, the numparam_value is a positive number, do we need to turn it into a negative.
*/
	select @pcloexpiredays = numparam_value * -1
	from dbo.qualpro_params
	where strparam_nm = 'PCLODaysToExpire'
	and strparam_grp = 'DBManager'

/* Get the batch size */
	select @batchsize = numparam_value
	from dbo.qualpro_params
	where strparam_nm = 'DBManagerBatch'
	and strparam_grp = 'DBManager'

--	Truncate table qp_scanner.dbo.bubbleitempos
--	Truncate table qp_scanner.dbo.commentlinepos
--	Truncate table qp_scanner.dbo.commentpos
--	Truncate table qp_scanner.dbo.bubblepos
--	Truncate table qp_scanner.dbo.pcloutput

/* Determine the sentmailings to be cleaned out. 
** We will do transactional batches of @batchsize records for each deleted, and
** delete the records by sentmail or questionform.
*/
	create table #sentmailing (
		sentmail_id int,
		questionform_id int
	)
	create index idx_sentmail on #sentmailing (sentmail_id)
	create index idx_qstnfrm on #sentmailing (questionform_id)

/* Get the sentmailing and questionform ids of the items we are going to delete.  Once
** we get them, we will delete the records that match the criteria.  Since, not all mailing
** items are associated with a QuestionForm, we need to LEFT OUTER JOIN in Questionform
** to make sure we get the right information.
*/
	SET ROWCOUNT @batchsize
	INSERT INTO #sentmailing (sentmail_id, questionform_id)
	SELECT DISTINCT sm.sentmail_id, qf.questionform_id
	FROM dbo.sentmailing sm LEFT OUTER JOIN dbo.questionform qf
		ON sm.sentmail_id = qf.sentmail_id
	WHERE sm.datmailed <= dateadd(dd,@expiredays,getdate())
	AND sm.datdeleted IS NULL
	WHILE @@ROWCOUNT > 0
	BEGIN
		SET ROWCOUNT 0
		BEGIN TRANSACTION

--			Insert into qp_scanner.dbo.bubbleitempos
--			select dbo.bubbleitempos.* from dbo.bubbleitempos, #sentmailing 
--			where dbo.BubbleItemPos.questionform_id = #sentmailing.questionform_id

			DELETE dbo.BubbleItemPos
			FROM #sentmailing
			WHERE dbo.BubbleItemPos.questionform_id = #sentmailing.questionform_id
			if @@error <> 0
			begin
				ROLLBACK TRANSACTION
				DROP TABLE #sentmailing
				return
			end

--			Insert into qp_scanner.dbo.commentlinepos
--			select dbo.commentlinepos.* from dbo.commentlinepos, #sentmailing 
--			where dbo.CommentLinePos.questionform_id = #sentmailing.questionform_id

			DELETE dbo.CommentLinePos
			FROM #sentmailing
			WHERE dbo.CommentLinePos.questionform_id = #sentmailing.questionform_id
			if @@error <> 0
			begin
				ROLLBACK TRANSACTION
				DROP TABLE #sentmailing
				return
			end

--			Insert into qp_scanner.dbo.commentpos
--			select dbo.commentpos.* from dbo.commentpos, #sentmailing 
--			where dbo.CommentPos.questionform_id = #sentmailing.questionform_id

			DELETE dbo.CommentPos
			FROM #sentmailing
			WHERE dbo.CommentPos.questionform_id = #sentmailing.questionform_id
			if @@error <> 0
			begin
				ROLLBACK TRANSACTION
				DROP TABLE #sentmailing
				return
			end

--			Insert into qp_scanner.dbo.bubblepos
--			select dbo.bubblepos.* from dbo.bubblepos, #sentmailing 
--			where dbo.BubblePos.questionform_id = #sentmailing.questionform_id

			DELETE dbo.BubblePos
			FROM #sentmailing
			WHERE dbo.BubblePos.questionform_id = #sentmailing.questionform_id
			if @@error <> 0
			begin
				ROLLBACK TRANSACTION
				DROP TABLE #sentmailing
				return
			end

			
--			Insert into qp_scanner.dbo.pcloutput
--			select dbo.pcloutput.* from dbo.pcloutput, #sentmailing 
--			where dbo.PCLOutput.sentmail_id = #sentmailing.sentmail_id

			DELETE dbo.PCLOutput
			FROM #sentmailing
			WHERE dbo.PCLOutput.sentmail_id = #sentmailing.sentmail_id
			if @@error <> 0
			begin
				ROLLBACK TRANSACTION
				DROP TABLE #sentmailing
				return
			end

			UPDATE dbo.sentmailing
			SET datdeleted = getdate()
			FROM #sentmailing
			WHERE dbo.sentmailing.sentmail_id = #sentmailing.sentmail_id
			if @@error <> 0
			begin
				ROLLBACK TRANSACTION
				DROP TABLE #sentmailing
				return
			end
		COMMIT TRANSACTION

		TRUNCATE TABLE #sentmailing
		if @@error <> 0
		begin
			DROP TABLE #sentmailing
			return
		end
		SET ROWCOUNT @batchsize
		INSERT INTO #sentmailing (sentmail_id, questionform_id)
		SELECT DISTINCT sm.sentmail_id, qf.questionform_id
		FROM dbo.sentmailing sm LEFT OUTER JOIN dbo.questionform qf
			ON sm.sentmail_id = qf.sentmail_id
		WHERE sm.datmailed <= dateadd(dd,@expiredays,getdate())
		AND sm.datdeleted IS NULL
	END
	SET ROWCOUNT 0
	DROP TABLE #sentmailing

/* Next, we will trim up PCLOutput by removing the Image data by setting the
** image field to NULL.  We will do this as one batch, since it won't be too large.
*/

--	Insert into qp_scanner.dbo.pcloutput
--	select dbo.pcloutput.* 
--	from dbo.pcloutput, dbo.sentmailing
--	WHERE dbo.PCLOutput.sentmail_id = dbo.sentmailing.sentmail_id
--	AND dbo.sentmailing.datmailed <= dateadd(dd,@pcloexpiredays,getdate())
--	AND dbo.sentmailing.datdeleted IS NULL

	DELETE dbo.PCLOutput
	FROM dbo.sentmailing
	WHERE dbo.PCLOutput.sentmail_id = dbo.sentmailing.sentmail_id
	AND dbo.sentmailing.datmailed <= dateadd(dd,@pcloexpiredays,getdate())
	AND dbo.sentmailing.datdeleted IS NULL

--BACKUP DATABASE [QP_Scanner] TO [QP_Scanner] WITH  INIT ,  NOUNLOAD ,  NAME = N'QP_Scanner backup',  SKIP ,  STATS = 10,  NOFORMAT

/* This backup is written to NRC10\d\sql7\backkup\qp_scanner.bak
*/


