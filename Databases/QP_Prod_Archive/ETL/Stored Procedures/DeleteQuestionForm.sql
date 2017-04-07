CREATE PROCEDURE [ETL].[DeleteQuestionForm]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @cnt1 INT = 0;
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_QF' --Deleted QuestionForm

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	--WITH cteSP AS
	--(
		SELECT DISTINCT sp.SamplePop_ID
		INTO #tmpSP
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SamplePop] sp ON sp.SamplePop_ID = q.Pkey1 AND sp.Recover = 0 AND EntityTypeID=7
		INNER JOIN [ARCHIVE].[QuestionForm] s ON q.Pkey1 = s.[SamplePop_ID] 
		WHERE q.ArchiveRunID = @ArchiveRunID
	CREATE INDEX ix_temp_sp on #tmpSP (SamplePop_ID)
	--)

	WHILE 1=1
	BEGIN
		--DELETE s
		--  FROM [QP_Prod].[dbo].[QuestionForm] s
		--  INNER JOIN #tmpSP t ON s.[SamplePop_ID] = t.[SamplePop_ID]
		--  INNER JOIN [ARCHIVE].[QuestionForm] a ON s.QuestionForm_ID = a.QuestionForm_ID

		DELETE TOP (@NumToWork) s
		  FROM [QP_Prod].[dbo].[QuestionForm] s
		  WHERE s.QuestionForm_ID IN (
								SELECT a.QuestionForm_ID 
								FROM [ARCHIVE].[QuestionForm] a
								INNER JOIN #tmpSP t ON t.[SamplePop_ID] = a.[SamplePop_ID])


		SELECT @cnt1 = @@ROWCOUNT;
		IF @cnt1 < @NumToWork
		BEGIN
		 SELECT @TaskCount = @TaskCount + @cnt1;
		 BREAK;
		END
		ELSE
		 SELECT @TaskCount = @TaskCount + @cnt1;
	END

	SET @CurrentDateTime = GETDATE();


	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount

END
