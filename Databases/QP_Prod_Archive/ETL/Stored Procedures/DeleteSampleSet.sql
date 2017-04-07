CREATE PROCEDURE [ETL].[DeleteSampleSet]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_SST' --Delete SampleSet

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT DISTINCT sp.SampleSet_ID
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SampleSet] sp ON sp.SampleSet_ID = q.Pkey1 AND sp.Recover = 0 AND EntityTypeID=8
		WHERE q.ArchiveRunID = @ArchiveRunID

	)

	  DELETE s
	  FROM [QP_Prod].[dbo].[SampleSet] s
	  INNER JOIN cteSP t ON t.SampleSet_ID = s.SampleSet_ID
	  LEFT JOIN [ARCHIVE].[SampleSet] a ON a.[SAMPLESET_ID] = s.[SAMPLESET_ID] 

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END

