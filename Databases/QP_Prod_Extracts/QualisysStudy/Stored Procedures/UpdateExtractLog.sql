CREATE PROCEDURE [QualisysStudy].[UpdateExtractLog]
  @ExtractLogID INT, @ProcessingQueueID INT, @SamplePopCount INT, @ResponseDataCount INT
 
AS
 SET NOCOUNT ON
 BEGIN 
 
	UPDATE [QualisysStudy].[ExtractLog]
	SET SamplePopCount = @SamplePopCount
		, ResponseDataCount = @ResponseDataCount
		, ProcessingEndDT = GETDATE()
		, Success = 1
	WHERE ExtractLogID = @ExtractLogID

	UPDATE [QualisysStudy].[ProcessingQueue]
	SET Processed = 1, ProcessedDate=GETDATE()
	WHERE ProcessingQueueID = @ProcessingQueueID
    

END
