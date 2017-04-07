

CREATE PROCEDURE [ETL].[UpdateArchiveRunDetails]
	@ArchiveRunDetailsID INT,
	@EndTime DATETIME,
	@TaskCount INT
AS
BEGIN

	UPDATE [ETL].[ArchiveRunDetails]
	SET		EndDateTime = @EndTime, TaskCount = @TaskCount
	WHERE ArchiveRunDetailsID = @ArchiveRunDetailsID


END


