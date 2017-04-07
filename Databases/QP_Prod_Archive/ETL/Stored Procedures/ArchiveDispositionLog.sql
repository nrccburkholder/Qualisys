CREATE PROCEDURE [ETL].[ArchiveDispositionLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_DL' --Archive DispositionLog

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SamplePop_id]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



	INSERT INTO [ARCHIVE].[DispositionLog]
           ([SentMail_id]
		  ,[SamplePop_id]
		  ,[Disposition_id]
		  ,[ReceiptType_id]
		  ,[datLogged]
		  ,[LoggedBy]
		  ,[DaysFromCurrent]
		  ,[DaysFromFirst]
		  ,[bitExtracted]
		  ,[ArchiveRunID])
	SELECT DISTINCT
			s.[SentMail_id]
		  ,s.[SamplePop_id]
		  ,s.[Disposition_id]
		  ,s.[ReceiptType_id]
		  ,s.[datLogged]
		  ,s.[LoggedBy]
		  ,s.[DaysFromCurrent]
		  ,s.[DaysFromFirst]
		  ,s.[bitExtracted]
		  ,@ArchiveRunID
	  FROM [QP_Prod].[dbo].[DispositionLog] s
	  INNER JOIN cteSP t ON t.[SamplePop_id] = s.[SamplePop_id]
	  LEFT JOIN [ARCHIVE].[DispositionLog] a 
	  ON s.[SamplePop_id] = a.[SamplePop_id] AND s.[Disposition_id] = a.[Disposition_id] 
			AND s.[datLogged] = a.[datLogged] AND s.[LoggedBy] = a.[LoggedBy] 
			AND s.[ReceiptType_id] = a.[ReceiptType_id]
	  WHERE a.[SamplePop_id] IS NULL; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount



END


