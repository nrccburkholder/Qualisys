
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ETL].[FindSampleSetRecordsToRecover]
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
	WHERE TaskCode = 'SR_SST' --Search SampleSet Record 

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	--DECLARE @ArchiveRunID INT = -99; DECLARE @ActiveMonths INT = 64; DECLARE @NumToFind INT = 10;

	WITH cteSST AS
	(
		SELECT a.SampleSet_ID
		FROM [ARCHIVE].[SampleSet] a
		WHERE a.Recover = 1 AND a.RecoverDT IS NULL
	)

	INSERT INTO [ETL].[ArchiveQueue]
	(PKey1,EntityTypeID, CreateDate, ArchiveRunID)
	SELECT TOP (@NumToFind) sst.SampleSet_ID, @EntityTypeID, @CurrentDateTime, @ArchiveRunID
	FROM cteSST sst
	ORDER BY sst.SampleSet_ID ASC
	; SELECT @TaskCount = @@ROWCOUNT

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount


END




