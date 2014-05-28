CREATE PROCEDURE [dbo].[QSL_SelectDataLoad]
@DataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DataLoad_ID, Vendor_ID, DisplayName, OrigFileName, CurrentFilePath, DateLoaded, bitShowInTree, TotalRecordsLoaded, TotalDispositionUpdateRecords, DateCreated, TranslationModule_ID
FROM [dbo].DL_DataLoad
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


