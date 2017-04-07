
CREATE PROCEDURE [ETL].[FinalizeArchiveRun]
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
	WHERE TaskCode = 'F_AR' --Archive QuestionForm

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime, ArchiveStateID = @ArchiveStateID, EndDateTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
	WHERE ArchiveRunID = @ArchiveRunID

	UPDATE q
	SET Processed = 1, ProcessedDate = getdate()
	FROM [ETL].[ArchiveQueue] q
	WHERE ArchiveRunID = @ArchiveRunID

END


