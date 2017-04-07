CREATE PROCEDURE [ETL].[ArchiveSamplingExclusionLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_SEL' --Archive SamplingExclusionLog

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	;WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SampleSet_id]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=8
	)


	INSERT INTO [ARCHIVE].[Sampling_ExclusionLog]
           ([SamplingExlusionLog_ID]
		  ,[Survey_ID]
		  ,[Sampleset_ID]
		  ,[Sampleunit_ID]
		  ,[Pop_ID]
		  ,[Enc_ID]
		  ,[SamplingExclusionType_ID]
		  ,[DQ_BusRule_ID]
		  ,[DateCreated]
		  ,[ArchiveRunID])
	SELECT DISTINCT
			s.[SamplingExlusionLog_ID]
		  ,s.[Survey_ID]
		  ,s.[Sampleset_ID]
		  ,s.[Sampleunit_ID]
		  ,s.[Pop_ID]
		  ,s.[Enc_ID]
		  ,s.[SamplingExclusionType_ID]
		  ,s.[DQ_BusRule_ID]
		  ,s.[DateCreated]
		  ,@ArchiveRunID
	  FROM [QP_Prod].[dbo].[Sampling_ExclusionLog] s
	  INNER JOIN cteSP t ON t.[SampleSet_id] = s.[SampleSet_id]
	  LEFT JOIN [ARCHIVE].[Sampling_ExclusionLog] a ON a.[SamplingExlusionLog_ID] = s.[SamplingExlusionLog_ID] 
	WHERE a.[SamplingExlusionLog_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount

END

