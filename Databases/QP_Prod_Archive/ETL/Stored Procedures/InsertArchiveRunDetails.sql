

CREATE PROCEDURE [ETL].[InsertArchiveRunDetails]
	@ArchiveRunID INT,
	@ArchiveTaskID INT,
	@StartTime [DATETIME],
	@ArchiveRunDetailsID INT OUTPUT
AS
BEGIN
	

	INSERT INTO [ETL].[ArchiveRunDetails]
			   ([ArchiveRunID]
			   ,[ArchiveTaskID]
			   ,[StartDateTime]
			   )
	SELECT
			@ArchiveRunID,
			@ArchiveTaskID,
			@StartTime
			;  
			SELECT @ArchiveRunDetailsID = @@IDENTITY

	RETURN 
END


