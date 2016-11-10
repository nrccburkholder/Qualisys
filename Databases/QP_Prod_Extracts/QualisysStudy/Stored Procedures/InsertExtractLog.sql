CREATE PROCEDURE [QualisysStudy].[InsertExtractLog]
  @ProcessingQueueID INT, @ExtractClientStudyID INT, @RunTypeID INT,@StartDate VARCHAR(20),@EndDate VARCHAR(20), @Study_ID VARCHAR(20)

 
AS
 SET NOCOUNT ON
 BEGIN 
 
    DECLARE @ExtractLogID INT;
	DECLARE @ProcessingStartDT DATETIME;

	INSERT INTO [QualisysStudy].[ExtractLog]
           ([ProcessingQueueID]
           ,[ExtractClientStudyID]
		   ,[Study_ID]
           ,[RunTypeID]
           ,[StartDate]
           ,[EndDate]
           ,[ProcessingStartDT]
			)
    SELECT  @ProcessingQueueID
			,@ExtractClientStudyID
			,CAST(@Study_ID AS INT) 
			,@RunTypeID
			,@StartDate
			,@EndDate
			,GETDATE();
    
    SET @ExtractLogID = @@IDENTITY 
    SELECT @ExtractLogID AS ExtractLogID;
END
