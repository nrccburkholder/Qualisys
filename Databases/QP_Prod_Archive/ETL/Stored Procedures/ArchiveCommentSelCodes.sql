CREATE PROCEDURE [ETL].[ArchiveCommentSelCodes]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_CSC' --Archive CommentSelCodes

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS SamplePop_ID
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



INSERT INTO [ARCHIVE].[CommentSelCodes]
           ([Cmnt_id],
			[CmntCode_id],
			[ArchiveRunID])
	SELECT DISTINCT
		  s.[Cmnt_id],
		  s.[CmntCode_id],
		  @ArchiveRunID
  FROM [QP_Prod].[dbo].[CommentSelCodes] s
	  INNER JOIN [QP_Prod].[dbo].[Comments] c ON c.[Cmnt_id] = s.[Cmnt_id]
	  INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON c.QuestionForm_ID = qf.QuestionForm_ID
	  INNER JOIN cteSP t ON t.SamplePop_ID = qf.SamplePop_ID
	  LEFT JOIN  [ARCHIVE].[CommentSelCodes] a ON s.[Cmnt_id] = a.[Cmnt_id] AND s.[CmntCode_id] = a.[CmntCode_id]
	  WHERE a.[Cmnt_id] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END
