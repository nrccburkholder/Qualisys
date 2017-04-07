CREATE PROCEDURE [ETL].[ArchiveComments]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_C' --Archive Comments

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT  Pkey1 AS SamplePop_ID
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7

	)


	INSERT INTO [ARCHIVE].[Comments]
           ([Cmnt_id]
		  ,[strCmntText]
		  ,[datEntered]
		  ,[datReported]
		  ,[bitSuppressed]
		  ,[CmntType_id]
		  ,[CmntValence_id]
		  ,[QuestionForm_id]
		  ,[SampleUnit_id]
		  ,[QstnCore]
		  ,[strVSTRBatchNumber]
		  ,[intVSTRLineNumber]
		  ,[strCmntOrHand]
		  ,[strCmntTextUM]
		  ,[ArchiveRunID])
	SELECT 
		  s.[Cmnt_id]
		  ,s.[strCmntText]
		  ,s.[datEntered]
		  ,s.[datReported]
		  ,s.[bitSuppressed]
		  ,s.[CmntType_id]
		  ,s.[CmntValence_id]
		  ,s.[QuestionForm_id]
		  ,s.[SampleUnit_id]
		  ,s.[QstnCore]
		  ,s.[strVSTRBatchNumber]
		  ,s.[intVSTRLineNumber]
		  ,s.[strCmntOrHand]
		  ,s.[strCmntTextUM]
		  ,@ArchiveRunID
  FROM [QP_Prod].[dbo].[Comments] s 
	  INNER JOIN [QP_Prod].[dbo].[QuestionForm] qf ON s.QuestionForm_ID = qf.QuestionForm_ID
	  INNER JOIN cteSP t ON t.SamplePop_ID = qf.SamplePop_ID
	  LEFT JOIN  [ARCHIVE].[Comments] a ON s.[Cmnt_id] = a.[Cmnt_id] 
	  WHERE a.[Cmnt_id] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END


