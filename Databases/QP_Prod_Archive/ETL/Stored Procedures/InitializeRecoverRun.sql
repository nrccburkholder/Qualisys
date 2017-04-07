
CREATE PROCEDURE [ETL].[InitializeRecoverRun]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ArchiveStateID INT;
	DECLARE @TaskCode VARCHAR(20) = 'SR_SP';
	DECLARE @ArchiveTaskID INT;
	DECLARE @ArchiveRunID INT;
	DECLARE @Type CHAR(1) = 'R';
	SELECT @ArchiveStateID = [ArchiveStateID] FROM [ETL].[ArchiveState] WHERE [State] = 'Running';
	SELECT @TaskCode = [ArchiveTaskID] FROM  [ETL].[ArchiveTask] WHERE TaskCode =  'SR_SP' AND [Type] = @Type;

	INSERT INTO [ETL].[ArchiveRun]
			   ([StartDateTime]
			   ,[EndDateTime]
			   ,[ArchiveStateID]
			   ,[ArchiveTaskID]
			   ,[TaskCompleteTime]
			   ,[Type])
	SELECT GETDATE(), NULL, @ArchiveStateID, @ArchiveTaskID, NULL,@Type;

	SELECT @ArchiveRunID = @@IDENTITY;

	SELECT @ArchiveRunID AS ArchiveRunID;



END

