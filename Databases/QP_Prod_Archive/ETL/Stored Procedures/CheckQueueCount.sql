
CREATE PROCEDURE [ETL].[CheckQueueCount]
	@Type CHAR(1) = 'A', @EntityTypeID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @QueueCount INT = 0

	SELECT @QueueCount = COUNT(*)
	FROM [ETL].[ArchiveRun] r
	INNER JOIN [ETL].[ArchiveQueue] q ON r.ArchiveRunID = q.ArchiveRunID AND q.EntityTypeID = @EntityTypeID
	WHERE r.ArchiveRunID IN (SELECT ArchiveRunID FROM [ETL].[ArchiveRun] WHERE [EndDateTime] IS NULL AND ArchiveStateID <> 5 AND [Type] = @Type)

	SELECT @QueueCount AS QueueCount
END

