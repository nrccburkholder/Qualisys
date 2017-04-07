CREATE PROCEDURE [ETL].[DeleteQuestionResult]
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
	WHERE TaskCode = 'D_QR' --Deleted QuestionResult

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

	--)
	CREATE INDEX ix_temp_sp on #tmpSP (SamplePop_ID)
	--select * from #tmpSP

	--drop table #tmpSP
	WHILE 1=1
	BEGIN
		--DELETE TOP (1000) s
		----select s.[QUESTIONRESULT_ID]
		--FROM [QP_Prod].[dbo].[QuestionResult] s
		--INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON s.QuestionForm_ID = qf.QuestionForm_ID
		--INNER JOIN #tmpSP t ON t.SamplePop_ID = qf.SamplePop_ID
		--INNER JOIN [ARCHIVE].[QuestionResult] a ON s.[QUESTIONRESULT_ID] = a.[QUESTIONRESULT_ID] 

		DELETE TOP (@NumToWork) s
		--select s.[QUESTIONRESULT_ID]
		FROM [QP_Prod].[dbo].[QuestionResult] s
		WHERE s.[QUESTIONRESULT_ID] IN (
						SELECT a.[QUESTIONRESULT_ID]
						FROM [ARCHIVE].[QuestionResult] a
						INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON a.QuestionForm_ID = qf.QuestionForm_ID
						INNER JOIN #tmpSP t ON t.SamplePop_ID = qf.SamplePop_ID)

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


