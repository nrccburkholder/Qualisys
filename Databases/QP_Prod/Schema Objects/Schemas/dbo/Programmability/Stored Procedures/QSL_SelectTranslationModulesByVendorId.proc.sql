CREATE PROCEDURE [dbo].[QSL_SelectTranslationModulesByVendorId]
    @Vendor_ID INT
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT TranslationModule_ID, Vendor_ID, ModuleName, WatchedFolderPath, FileType, Study_ID, Survey_ID, LithoLookupType_ID
FROM DL_TranslationModules
WHERE Vendor_ID = @Vendor_ID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


