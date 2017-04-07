CREATE PROCEDURE [ETL].[DeleteSamplingExclusionLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_SEL' --Delete SamplingExclusionLog

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
	FROM [QP_Prod].[dbo].[Sampling_ExclusionLog] s
	  INNER JOIN cteSP t ON t.SampleSet_ID = s.SampleSet_ID
	  INNER JOIN [ARCHIVE].[Sampling_ExclusionLog] a ON a.[SamplingExlusionLog_ID] = s.[SamplingExlusionLog_ID] 
	; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END


