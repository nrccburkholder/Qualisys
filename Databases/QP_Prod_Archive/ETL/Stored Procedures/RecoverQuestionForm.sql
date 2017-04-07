CREATE PROCEDURE [ETL].[RecoverQuestionForm]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'R_QF' --Recover QuestionForm
		AND [Type] = 'R'

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;


	SET IDENTITY_INSERT [QP_Prod].[dbo].[QuestionForm] ON;
	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SAMPLEPOP_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



INSERT INTO [QP_Prod].[dbo].[QuestionForm]
           ([QUESTIONFORM_ID]
		  ,[SENTMAIL_ID]
		  ,[SAMPLEPOP_ID]
		  ,[CUTOFF_ID]
		  ,[DATRETURNED]
		  ,[SURVEY_ID]
		  ,[UnusedReturn_id]
		  ,[datUnusedReturn]
		  ,[datResultsImported]
		  ,[strSTRBatchNumber]
		  ,[intSTRLineNumber]
		  ,[intPhoneAttempts]
		  ,[bitComplete]
		  ,[ReceiptType_id]
		  ,[strScanBatch]
		  ,[BubbleCnt]
		  ,[QstnCoreCnt]
		  ,[bitExported]
		  ,[numCAHPSSupplemental]
		  )
SELECT DISTINCT
	  s.[QUESTIONFORM_ID]
      ,s.[SENTMAIL_ID]
      ,s.[SAMPLEPOP_ID]
      ,s.[CUTOFF_ID]
      ,s.[DATRETURNED]
      ,s.[SURVEY_ID]
      ,s.[UnusedReturn_id]
      ,s.[datUnusedReturn]
      ,s.[datResultsImported]
      ,s.[strSTRBatchNumber]
      ,s.[intSTRLineNumber]
      ,s.[intPhoneAttempts]
      ,s.[bitComplete]
      ,s.[ReceiptType_id]
      ,s.[strScanBatch]
      ,s.[BubbleCnt]
      ,s.[QstnCoreCnt]
      ,s.[bitExported]
      ,s.[numCAHPSSupplemental]

  FROM [ARCHIVE].[QuestionForm] s
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = s.[SAMPLEPOP_ID]
	  LEFT JOIN [QP_Prod].[dbo].[QuestionForm] a ON s.[QUESTIONFORM_ID] = a.[QUESTIONFORM_ID] 
	  WHERE a.[QUESTIONFORM_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET IDENTITY_INSERT [QP_Prod].[dbo].[QuestionForm] OFF;
	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

	

END


