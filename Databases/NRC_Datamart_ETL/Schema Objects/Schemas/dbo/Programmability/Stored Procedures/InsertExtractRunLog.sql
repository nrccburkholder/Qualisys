CREATE PROCEDURE [dbo].[InsertExtractRunLog]
	@ExtractFileID INT,
	@Task VARCHAR(200),
	@StartTime [DATETIME],
	@ExtractRunLogID INT OUTPUT
AS
BEGIN
	

	INSERT INTO [dbo].[ExtractRunLog]
			   ([ExtractFileID]
			   ,[Task]
			   ,[StartTime]
			   ,[EndTime])
	SELECT
			@ExtractFileID,
			@Task,
			@StartTime,
			NULL;  SELECT @ExtractRunLogID = @@IDENTITY;

	RETURN 
END

GO

