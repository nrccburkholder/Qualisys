CREATE PROCEDURE [ETL].[ArchiveEligibleEncLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_EEL' --Archive EligibleEncLog

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SampleSet_id]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=8
		ORDER BY 1
	)



	INSERT INTO [ARCHIVE].[EligibleEncLog]
           ( [sampleset_id]
		  ,[sampleunit_id]
		  ,[pop_id]
		  ,[enc_id]
		  ,[SampleEncounterDate]
		  ,[SurveyType_id]
		  ,[ArchiveRunID])
	SELECT DISTINCT
			 s.[sampleset_id]
			  ,s.[sampleunit_id]
			  ,s.[pop_id]
			  ,s.[enc_id]
			  ,s.[SampleEncounterDate]
			  ,s.[SurveyType_id]
		  ,@ArchiveRunID
	  FROM [QP_Prod].[dbo].[EligibleEncLog] s
	  INNER JOIN cteSP t ON t.[SampleSet_id] = s.[SampleSet_id]
	  LEFT JOIN [ARCHIVE].[EligibleEncLog] a 
	  ON s.[sampleset_id] = a.[sampleset_id] 
	  WHERE a.[sampleset_id] IS NULL; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount



END


