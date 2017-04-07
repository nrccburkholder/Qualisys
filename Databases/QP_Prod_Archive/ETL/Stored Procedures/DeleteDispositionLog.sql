CREATE PROCEDURE [ETL].[DeleteDispositionLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN


	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_DL' --Delete DispositionLog

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;	

	WITH cteSP AS
	(
		SELECT DISTINCT sp.SamplePop_ID
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SamplePop] sp ON sp.SamplePop_ID = q.Pkey1 AND sp.Recover = 0 AND EntityTypeID=7
		WHERE q.ArchiveRunID = @ArchiveRunID

	)


	DELETE s
	FROM [QP_Prod].[dbo].[DispositionLog] s
	INNER JOIN cteSP t ON t.SamplePop_ID = s.SamplePop_ID
	INNER JOIN [ARCHIVE].[DispositionLog] a 
	  ON s.SamplePop_ID = a.SamplePop_ID AND s.Disposition_ID = a.Disposition_ID 
			AND s.datLogged = a.[datLogged] AND s.[LoggedBy] = a.[LoggedBy] 
			AND s.ReceiptType_ID = a.ReceiptType_ID
	; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount


END


