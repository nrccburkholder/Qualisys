CREATE PROCEDURE [ETL].[ArchiveSamplePop]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_SP' --Archive SamplePopulation

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;



	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SamplePop_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



	INSERT INTO [ARCHIVE].[SamplePop]
           ([SAMPLEPOP_ID]
		  ,[SAMPLESET_ID]
		  ,[STUDY_ID]
		  ,[POP_ID]
		  ,[QPC_TIMESTAMP]
		  ,[bitBadAddress]
		  ,[bitBadPhone]
			   ,ArchiveRunID)
	SELECT DISTINCT
			s.[SAMPLEPOP_ID]
		  ,s.[SAMPLESET_ID]
		  ,s.[STUDY_ID]
		  ,s.[POP_ID]
		  ,s.[QPC_TIMESTAMP]
		  ,s.[bitBadAddress]
		  ,s.[bitBadPhone]
		  ,@ArchiveRunID
	  FROM [QP_Prod].[dbo].[SamplePop] s
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = s.[SAMPLEPOP_ID]
	  LEFT JOIN [ARCHIVE].[SamplePop] a ON s.[SAMPLEPOP_ID] = a.[SAMPLEPOP_ID] 
	  WHERE a.[SAMPLEPOP_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT



	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount

	IF OBJECT_ID('tempdb.dbo.#tmpDSK', 'U') IS NOT NULL
	  DROP TABLE #tmpDSK; 	

END


