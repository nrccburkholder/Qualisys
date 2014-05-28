CREATE PROCEDURE [dbo].[QSL_UpdateTranslationModule]
    @TranslationModule_ID INT,
    @Vendor_ID            INT,
    @ModuleName           VARCHAR(150),
    @WatchedFolderPath    VARCHAR(1000),
    @FileType             VARCHAR(5),
    @Study_ID             INT,
    @Survey_ID            INT, 
    @LithoLookupType_ID   INT
AS

--Setup environment
SET NOCOUNT ON

--Update the record
UPDATE [dbo].DL_TranslationModules SET
	Vendor_ID = @Vendor_ID,
	ModuleName = @ModuleName,
	WatchedFolderPath = @WatchedFolderPath,
	FileType = @FileType,
	Study_ID = @Study_ID,
	Survey_ID = @Survey_ID, 
	LithoLookupType_ID = @LithoLookupType_ID
WHERE TranslationModule_ID = @TranslationModule_ID

--Reset the environment
SET NOCOUNT OFF


