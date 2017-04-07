CREATE PROCEDURE [ETL].[DeleteEligibleEncLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN


	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_EEL' --Delete DeleteEligibleEncLog

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;	

	WITH cteSP AS
	(
		SELECT DISTINCT sst.SampleSet_ID
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SampleSet] sst ON sst.SampleSet_ID = q.Pkey1 AND sst.Recover = 0 AND EntityTypeID=8
		WHERE q.ArchiveRunID = @ArchiveRunID

	)


	DELETE s
	FROM [QP_Prod].[dbo].[EligibleEncLog] s
	INNER JOIN cteSP t ON t.SampleSet_ID = s.SampleSet_ID
	INNER JOIN [ARCHIVE].[EligibleEncLog] a ON s.[sampleset_id] = a.[sampleset_id] 
		  AND s.[sampleunit_id] = a.[sampleunit_id]
		  AND s.[pop_id] = a.[pop_id]
		  AND s.[enc_id] = a.[enc_id]

	; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount


END


