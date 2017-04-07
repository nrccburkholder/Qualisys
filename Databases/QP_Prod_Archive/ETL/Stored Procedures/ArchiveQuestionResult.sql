CREATE PROCEDURE [ETL].[ArchiveQuestionResult]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_QR' --Archive QuestionResult

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT Pkey1 AS SamplePop_ID
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7

	), cteQR AS
	(
	  SELECT s.[QUESTIONRESULT_ID]
	  FROM [QP_Prod].[dbo].[QuestionResult] s
	  INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON s.QuestionForm_ID = qf.QuestionForm_ID
	  INNER JOIN cteSP t ON t.SamplePop_ID = qf.SamplePop_ID
	  LEFT JOIN [ARCHIVE].[QuestionResult] a ON s.[QUESTIONRESULT_ID] = a.[QUESTIONRESULT_ID] 
	  WHERE a.[QUESTIONRESULT_ID] IS NULL
	)



	INSERT INTO [ARCHIVE].[QuestionResult]
           ([QUESTIONRESULT_ID]
		  ,[QUESTIONFORM_ID]
		  ,[SAMPLEUNIT_ID]
		  ,[QSTNCORE]
		  ,[INTRESPONSEVAL]
		  ,[QPC_TIMESTAMP]
		  ,[ArchiveRunID]
		  )
	SELECT DISTINCT
		  s.[QUESTIONRESULT_ID]
		  ,s.[QUESTIONFORM_ID]
		  ,s.[SAMPLEUNIT_ID]
		  ,s.[QSTNCORE]
		  ,s.[INTRESPONSEVAL]
		  ,s.[QPC_TIMESTAMP]
		  ,@ArchiveRunID
	  	  FROM [QP_Prod].[dbo].[QuestionResult] s
	  INNER JOIN cteQR a ON s.[QUESTIONRESULT_ID] = a.[QUESTIONRESULT_ID] ;  
	  SELECT @TaskCount = @@ROWCOUNT


	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END
