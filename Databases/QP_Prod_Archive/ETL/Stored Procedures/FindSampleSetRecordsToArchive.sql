
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ETL].[FindSampleSetRecordsToArchive]
	@ArchiveRunID INT,
	@ActiveMonths INT,
	@NumToFind INT
AS
BEGIN


	DECLARE @EntityTypeID INT = 8 --SampleSet
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SET @ActiveMonths = @ActiveMonths * -1;
	DECLARE @CurrentDate DATE = CAST(@CurrentDateTime AS DATE);
	DECLARE @MinDate DATE = DATEADD(MONTH, @ActiveMonths, @CurrentDate);

	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'S_SST' --Search SampleSet Record 

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	--DECLARE @ArchiveRunID INT = -99; DECLARE @ActiveMonths INT = 64; DECLARE @NumToFind INT = 10;

	WITH cteSST AS
	(

		SELECT DISTINCT TOP (@NumToFind) sst.SampleSet_ID
		FROM [QP_Prod].[dbo].[SampleSet] sst
		INNER JOIN [QP_Prod].[dbo].EligibleEncLog e ON sst.SampleSet_ID = e.SampleSet_ID
		WHERE sst.datDateRange_ToDate < @MinDate 
		UNION
		SELECT DISTINCT TOP (@NumToFind) sst.SampleSet_ID
		FROM [QP_Prod].[dbo].[SampleSet] sst
		INNER JOIN [QP_Prod].[dbo].SamplePlanWorksheet e ON sst.SampleSet_ID = e.SampleSet_ID
		WHERE sst.datDateRange_ToDate < @MinDate 
		UNION
		SELECT DISTINCT TOP (@NumToFind) sst.SampleSet_ID
		FROM [QP_Prod].[dbo].[SampleSet] sst
		INNER JOIN [QP_Prod].[dbo].Sampling_ExclusionLog e ON sst.SampleSet_ID = e.SampleSet_ID
		WHERE sst.datDateRange_ToDate < @MinDate 
		--SELECT DISTINCT TOP (@NumToFind) sst.SampleSet_ID
		--FROM [QP_Prod].[dbo].[SampleSet] sst
		--LEFT JOIN [ARCHIVE].[SampleSet] a ON sst.SampleSet_ID = a.SampleSet_ID 
		--WHERE sst.datDateRange_ToDate < @MinDate AND a.SampleSet_ID IS NULL
		--AND sst.SampleSet_ID = 557601

	), cteSST2 AS
	(
		SELECT DISTINCT  sst.SampleSet_ID
		FROM cteSST sst
		LEFT JOIN [QP_Prod].dbo.[SamplePop] a ON sst.SampleSet_ID = a.SampleSet_ID 
		WHERE a.SampleSet_ID IS NULL
		--SELECT DISTINCT t.SampleSet_ID
		--FROM cteSST t
		--INNER JOIN [QP_Prod].[dbo].EligibleEncLog e ON t.SampleSet_ID = e.SampleSet_ID
		--UNION
		--SELECT DISTINCT t.SampleSet_ID
		--FROM cteSST t
		--INNER JOIN [QP_Prod].[dbo].SamplePlanWorksheet e ON t.SampleSet_ID = e.SampleSet_ID
		--UNION
		--SELECT DISTINCT t.SampleSet_ID
		--FROM cteSST t
		--INNER JOIN [QP_Prod].[dbo].Sampling_ExclusionLog e ON t.SampleSet_ID = e.SampleSet_ID
	)

	INSERT INTO [ETL].[ArchiveQueue]
	(PKey1,EntityTypeID, CreateDate, ArchiveRunID)
	SELECT TOP (@NumToFind) sst.SampleSet_ID, @EntityTypeID, @CurrentDateTime, @ArchiveRunID
	FROM cteSST2 sst
	ORDER BY sst.SampleSet_ID ASC
	; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount


END



