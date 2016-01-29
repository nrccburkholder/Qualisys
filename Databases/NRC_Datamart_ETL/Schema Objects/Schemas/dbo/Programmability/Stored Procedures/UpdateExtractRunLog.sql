CREATE PROCEDURE [dbo].[UpdateExtractRunLog]
	@ExtractRunLogID INT,
	@EndTime DATETIME
AS
BEGIN

	UPDATE [dbo].[ExtractRunLog]
	SET		EndTime = @EndTime
	WHERE ExtractRunLogID = @ExtractRunLogID


END

GO


