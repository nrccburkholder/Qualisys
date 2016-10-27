CREATE PROCEDURE [QualisysStudy].[UpdateExtractLogErrorMsg]
  @ExtractLogID INT, @ErrorMsg VARCHAR(200)
 
AS
 SET NOCOUNT ON
 BEGIN 
 
	UPDATE [QualisysStudy].[ExtractLog]
	SET ErrorMsg = @ErrorMsg
	WHERE ExtractLogID = @ExtractLogID

END
