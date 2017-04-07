
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ETL].[FindSamplePopRecordsToArchive]
	@ArchiveRunID INT,
	@ActiveMonths INT,
	@NumToFind INT
AS
BEGIN


	DECLARE @EntityTypeID INT = 7 --SamplePop
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SET @ActiveMonths = @ActiveMonths * -1;
	DECLARE @CurrentDate DATE = CAST(@CurrentDateTime AS DATE);
	DECLARE @MinDate DATE = DATEADD(MONTH, @ActiveMonths, @CurrentDate);

	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'S_SP' --Search Samplepop Record 

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	--DECLARE @ArchiveRunID INT = -99; DECLARE @ActiveMonths INT = 64; DECLARE @NumToFind INT = 10;



	INSERT INTO [ETL].[ArchiveQueue]
	(PKey1,EntityTypeID, CreateDate, ArchiveRunID)
	SELECT TOP (@NumToFind) sp.SamplePop_ID, @EntityTypeID, @CurrentDateTime, @ArchiveRunID
	FROM [QP_Prod].[dbo].[SampleSet] sst
	INNER JOIN [QP_Prod].[dbo].[SamplePop] sp ON sst.SampleSet_ID = sp.SampleSet_ID --AND sst.SampleSet_ID = 557601
	LEFT JOIN [ARCHIVE].[SamplePop] a ON sp.SamplePop_ID = a.SamplePop_ID AND a.Recover = 1
	WHERE sst.datDateRange_ToDate < @MinDate AND a.SamplePop_ID IS NULL
	ORDER BY sst.SampleSet_ID ASC
	--ORDER BY sp.SamplePop_ID ASC
	; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount


END



