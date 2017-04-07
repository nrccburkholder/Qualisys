CREATE PROCEDURE [ETL].[ArchiveQuestionForm]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_QF' --Archive QuestionForm

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;



	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SAMPLEPOP_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



INSERT INTO [ARCHIVE].[QuestionForm]
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
		  ,[ArchiveRunID])
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
	  ,@ArchiveRunID
  FROM [QP_Prod].[dbo].[QuestionForm] s
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = s.[SAMPLEPOP_ID]
	  LEFT JOIN [ARCHIVE].[QuestionForm] a ON s.[QUESTIONFORM_ID] = a.[QUESTIONFORM_ID] 
	  WHERE a.[QUESTIONFORM_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT



	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

	

END

