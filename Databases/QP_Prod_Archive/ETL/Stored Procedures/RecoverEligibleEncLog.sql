CREATE PROCEDURE [ETL].[RecoverEligibleEncLog]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'R_EEL' --Recover EligibleEncLog
		AND [Type] = 'R'

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;


	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SampleSet_id]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=8
		ORDER BY 1
	)



	INSERT INTO [QP_Prod].[dbo].[EligibleEncLog]
           ( [sampleset_id]
		  ,[sampleunit_id]
		  ,[pop_id]
		  ,[enc_id]
		  ,[SampleEncounterDate]
		  ,[SurveyType_id])
	SELECT DISTINCT
			 s.[sampleset_id]
			  ,s.[sampleunit_id]
			  ,s.[pop_id]
			  ,s.[enc_id]
			  ,s.[SampleEncounterDate]
			  ,s.[SurveyType_id]
	  FROM [ARCHIVE].[EligibleEncLog] s
	  INNER JOIN cteSP t ON t.[SampleSet_id] = s.[SampleSet_id]
	  LEFT JOIN [QP_Prod].[dbo].[EligibleEncLog] a 
	  ON s.[sampleset_id] = a.[sampleset_id] 
	  WHERE a.[sampleset_id] IS NULL; SELECT @TaskCount = @@ROWCOUNT

	

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount



END



