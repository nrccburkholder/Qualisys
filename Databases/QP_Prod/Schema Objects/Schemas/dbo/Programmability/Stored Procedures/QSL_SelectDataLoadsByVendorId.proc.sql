CREATE PROCEDURE [dbo].[QSL_SelectDataLoadsByVendorId]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DataLoad_ID, Vendor_ID, DisplayName, OrigFileName, CurrentFilePath, DateLoaded, bitShowInTree, TotalRecordsLoaded, TotalDispositionUpdateRecords, DateCreated, TranslationModule_ID
FROM DL_DataLoad
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


