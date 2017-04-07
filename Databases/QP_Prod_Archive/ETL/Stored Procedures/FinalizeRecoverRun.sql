
CREATE PROCEDURE [ETL].[FinalizeRecoverRun]
	@ArchiveRunID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ArchiveStateID INT;
	SELECT @ArchiveStateID = [ArchiveStateID] FROM [ETL].[ArchiveState] WHERE [State] = 'Successful'

	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'F_RR' --Finalize Recover
		AND [Type] = 'R'

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime, ArchiveStateID = @ArchiveStateID, EndDateTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
	WHERE ArchiveRunID = @ArchiveRunID

	UPDATE sst
	SET RecoverDT = @CurrentDateTime
	--select *
	FROM [ARCHIVE].[SampleSet] sst
	INNER JOIN [ETL].[ArchiveQueue] q ON sst.SampleSet_ID = q.PKey1 AND q.EntityTypeID = 8
	WHERE q.ArchiveRunID = @ArchiveRunID  AND sst.Recover = 1 AND sst.RecoverDT IS NULL    

	UPDATE sp
	SET RecoverDT = @CurrentDateTime
	--select *
	FROM [ARCHIVE].[SamplePop] sp
	INNER JOIN [ETL].[ArchiveQueue] q ON sp.SamplePop_ID = q.PKey1 AND q.EntityTypeID = 7
	WHERE q.ArchiveRunID = @ArchiveRunID  AND sp.Recover = 1 AND sp.RecoverDT IS NULL  

	UPDATE q
	SET Processed = 1, ProcessedDate = getdate()
	FROM [ETL].[ArchiveQueue] q
	WHERE ArchiveRunID = @ArchiveRunID

END



