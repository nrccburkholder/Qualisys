
CREATE PROCEDURE [ETL].[RecoverSelectedSample]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'R_SS' --Recover SelectedSample
		AND [Type] = 'R'

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	SET IDENTITY_INSERT [QP_Prod].[dbo].[SelectedSample] ON;
	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS SamplePop_ID
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
	)


	INSERT INTO [QP_Prod].[dbo].[SelectedSample]
           ([SELECTEDSAMPLE_ID]
		  ,[SAMPLESET_ID]
		  ,[STUDY_ID]
		  ,[POP_ID]
		  ,[SAMPLEUNIT_ID]
		  ,[STRUNITSELECTTYPE]
		  ,[intExtracted_flg]
		  ,[enc_id]
		  ,[ReportDate]
		  ,[SampleEncounterDate]
		  )
	SELECT DISTINCT
			s.[SELECTEDSAMPLE_ID]
		  ,s.[SAMPLESET_ID]
		  ,s.[STUDY_ID]
		  ,s.[POP_ID]
		  ,s.[SAMPLEUNIT_ID]
		  ,s.[STRUNITSELECTTYPE]
		  ,s.[intExtracted_flg]
		  ,s.[enc_id]
		  ,s.[ReportDate]
		  ,s.[SampleEncounterDate]
		  
	  FROM [ARCHIVE].[SelectedSample] s
	  INNER JOIN [QP_Prod].[dbo].[SamplePop] sp ON s.Study_ID = sp.Study_ID AND s.Pop_ID = sp.Pop_ID AND s.SampleSet_ID = sp.SampleSet_ID
	  INNER JOIN cteSP t ON t.SamplePop_ID = sp.SamplePop_ID
	  LEFT JOIN [QP_Prod].[dbo].[SelectedSample] a ON  s.[SELECTEDSAMPLE_ID] = a.[SELECTEDSAMPLE_ID]
	  WHERE a.[SELECTEDSAMPLE_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT

	SET IDENTITY_INSERT [QP_Prod].[dbo].[SelectedSample] OFF;
	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount

END


