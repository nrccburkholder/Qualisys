CREATE PROCEDURE [dbo].[QSL_UpdateDataLoad]
@DataLoad_ID INT,
@Vendor_ID INT,
@DisplayName VARCHAR(500),
@OrigFileName VARCHAR(500),
@CurrentFilePath VARCHAR(1000),
@DateLoaded DATETIME,
@bitShowInTree BIT,
@TotalRecordsLoaded INT,
@TotalDispositionUpdateRecords INT,
@DateCreated DATETIME, 
@TranslationModule_ID INT
AS

SET NOCOUNT ON

UPDATE [dbo].DL_DataLoad SET
	Vendor_ID = @Vendor_ID,
	DisplayName = @DisplayName,
	OrigFileName = @OrigFileName,
	CurrentFilePath = @CurrentFilePath,
	DateLoaded = @DateLoaded,
	bitShowInTree = @bitShowInTree,
	TotalRecordsLoaded = @TotalRecordsLoaded,
	TotalDispositionUpdateRecords = @TotalDispositionUpdateRecords,
	DateCreated = @DateCreated, 
	TranslationModule_ID = @TranslationModule_ID
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF


