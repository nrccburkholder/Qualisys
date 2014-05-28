CREATE PROCEDURE [dbo].[QSL_InsertDataLoad]
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

INSERT INTO [dbo].DL_DataLoad (Vendor_ID, DisplayName, OrigFileName, CurrentFilePath, DateLoaded, bitShowInTree, TotalRecordsLoaded, TotalDispositionUpdateRecords, DateCreated, TranslationModule_ID)
VALUES (@Vendor_ID, @DisplayName, @OrigFileName, @CurrentFilePath, @DateLoaded, @bitShowInTree, @TotalRecordsLoaded, @TotalDispositionUpdateRecords, @DateCreated, @TranslationModule_ID)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


