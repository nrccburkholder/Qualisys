CREATE PROCEDURE [ETL].[ArchiveSamplePlanWorksheet]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_SPW' --Archive SamplePlanWorksheet

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;


	SET IDENTITY_INSERT [QP_Prod].[dbo].[SamplePlanWorksheet] ON;
	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SampleSet_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=8
		ORDER BY 1
	)



INSERT INTO [ARCHIVE].[SamplePlanWorksheet]
           ([SamplePlanWorksheet_id]
		  ,[Sampleset_id]
		  ,[SampleUnit_id]
		  ,[strSampleUnit_nm]
		  ,[ParentSampleUnit_id]
		  ,[intTier]
		  ,[intUniverseCount]
		  ,[intDQ]
		  ,[intAvailableUniverse]
		  ,[intPeriodReturnTarget]
		  ,[numDefaultResponseRate]
		  ,[numHistoricResponseRate]
		  ,[intTotalPriorPeriodOutgo]
		  ,[intAnticipatedTPPOReturns]
		  ,[intAdditionalReturnsNeeded]
		  ,[intSamplesAlreadyPulled]
		  ,[intSamplesInPeriod]
		  ,[intSamplesLeftInPeriod]
		  ,[numAdditionalPeriodOutgoNeeded]
		  ,[intOutgoNeededNow]
		  ,[intSampledNow]
		  ,[intIndirectSampledNow]
		  ,[intShortfall]
		  ,[strCriteria]
		  ,[minenc_dt]
		  ,[maxenc_dt]
		  ,[badphonecount]
		  ,[BadAddressCount]
		  ,[HcahpsDirectSampledCount]
		  ,[HcahpsEligibleEncLogCount]
		  ,[ArchiveRunID])
	SELECT DISTINCT
	   s.[SamplePlanWorksheet_id]
      ,s.[Sampleset_id]
      ,s.[SampleUnit_id]
      ,s.[strSampleUnit_nm]
      ,s.[ParentSampleUnit_id]
      ,s.[intTier]
      ,s.[intUniverseCount]
      ,s.[intDQ]
      ,s.[intAvailableUniverse]
      ,s.[intPeriodReturnTarget]
      ,s.[numDefaultResponseRate]
      ,s.[numHistoricResponseRate]
      ,s.[intTotalPriorPeriodOutgo]
      ,s.[intAnticipatedTPPOReturns]
      ,s.[intAdditionalReturnsNeeded]
      ,s.[intSamplesAlreadyPulled]
      ,s.[intSamplesInPeriod]
      ,s.[intSamplesLeftInPeriod]
      ,s.[numAdditionalPeriodOutgoNeeded]
      ,s.[intOutgoNeededNow]
      ,s.[intSampledNow]
      ,s.[intIndirectSampledNow]
      ,s.[intShortfall]
      ,s.[strCriteria]
      ,s.[minenc_dt]
      ,s.[maxenc_dt]
      ,s.[badphonecount]
      ,s.[BadAddressCount]
      ,s.[HcahpsDirectSampledCount]
      ,s.[HcahpsEligibleEncLogCount]
	  ,@ArchiveRunID
  FROM [QP_Prod].[dbo].[SamplePlanWorksheet] s
	  INNER JOIN cteSP t ON t.[Sampleset_id] = s.[Sampleset_id]
	  LEFT JOIN [ARCHIVE].[SamplePlanWorksheet] a ON s.[SamplePlanWorksheet_id] = a.[SamplePlanWorksheet_id] 
	  WHERE a.[SamplePlanWorksheet_id] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET IDENTITY_INSERT [QP_Prod].[dbo].[SamplePlanWorksheet] OFF;
	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

	

END

