CREATE PROCEDURE [ETL].[RecoverQuestionResult]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'R_QR' --Recover QuestionResult
		AND [Type] = 'R'

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	SET IDENTITY_INSERT [QP_Prod].[dbo].[QuestionResult] ON;
	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS SamplePop_ID
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



	INSERT INTO [QP_Prod].[dbo].[QuestionResult]
           ([QUESTIONRESULT_ID]
		  ,[QUESTIONFORM_ID]
		  ,[SAMPLEUNIT_ID]
		  ,[QSTNCORE]
		  ,[INTRESPONSEVAL]
		  --,[QPC_TIMESTAMP]

		  )
	SELECT DISTINCT
		  s.[QUESTIONRESULT_ID]
		  ,s.[QUESTIONFORM_ID]
		  ,s.[SAMPLEUNIT_ID]
		  ,s.[QSTNCORE]
		  ,s.[INTRESPONSEVAL]
		  --,s.[QPC_TIMESTAMP]
	  FROM [ARCHIVE].[QuestionResult] s
	  INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON s.QuestionForm_ID = qf.QuestionForm_ID
	  INNER JOIN cteSP t ON t.SamplePop_ID = qf.SamplePop_ID
	  LEFT JOIN [QP_Prod].[dbo].[QuestionResult] a ON s.[QUESTIONRESULT_ID] = a.[QUESTIONRESULT_ID] 
	  WHERE a.[QUESTIONRESULT_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET IDENTITY_INSERT [QP_Prod].[dbo].[QuestionResult] OFF;
	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END



