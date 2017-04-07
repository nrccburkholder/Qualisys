CREATE PROCEDURE [ETL].[RecoverSamplePop]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'R_SP' --Recover SamplePop
		AND [Type] = 'R'

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;


	SET IDENTITY_INSERT [QP_Prod].[dbo].[SamplePop] ON;
	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SamplePop_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)


	INSERT INTO [QP_Prod].[dbo].[SamplePop]
           ([SAMPLEPOP_ID]
		  ,[SAMPLESET_ID]
		  ,[STUDY_ID]
		  ,[POP_ID]
		  
		  ,[bitBadAddress]
		  ,[bitBadPhone]
			)
	SELECT DISTINCT
			s.[SAMPLEPOP_ID]
		  ,s.[SAMPLESET_ID]
		  ,s.[STUDY_ID]
		  ,s.[POP_ID]

		  ,s.[bitBadAddress]
		  ,s.[bitBadPhone]
		  
	  FROM [ARCHIVE].[SamplePop] s
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = s.[SAMPLEPOP_ID]
	  LEFT JOIN [QP_Prod].[dbo].[SamplePop] a ON s.[SAMPLEPOP_ID] = a.[SAMPLEPOP_ID] 
	  WHERE a.[SAMPLEPOP_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET IDENTITY_INSERT [QP_Prod].[dbo].[SamplePop] OFF;
	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount


END

