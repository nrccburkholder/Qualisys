CREATE PROCEDURE [ETL].[DeleteComment]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_C' --Deleted Comment

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT DISTINCT q.Pkey1 AS SamplePop_ID
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SamplePop] sp ON sp.SamplePop_ID = q.Pkey1 AND sp.Recover = 0 AND EntityTypeID=7
		WHERE q.ArchiveRunID = @ArchiveRunID

	)



	DELETE s
	FROM [QP_Prod].[dbo].[Comments] s
	INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON s.QuestionForm_ID = qf.QuestionForm_ID
	INNER JOIN cteSP t ON t.SamplePop_ID = qf.SamplePop_ID
	INNER JOIN [ARCHIVE].[Comments] a ON s.[Cmnt_id] = a.[Cmnt_id] 
	; SELECT @TaskCount = @@ROWCOUNT


	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount 

END


