CREATE PROCEDURE [dbo].[QSL_InsertTranslationModule]
    @Vendor_ID          INT,
    @ModuleName         VARCHAR(150),
    @WatchedFolderPath  VARCHAR(1000),
    @FileType           VARCHAR(5),
    @Study_ID           INT,
    @Survey_ID          INT, 
    @LithoLookupType_ID INT
AS

--Setup environment
SET NOCOUNT ON

--Insert the record
INSERT INTO [dbo].DL_TranslationModules (Vendor_ID, ModuleName, WatchedFolderPath, FileType, Study_ID, Survey_ID, LithoLookupType_ID)
VALUES (@Vendor_ID, @ModuleName, @WatchedFolderPath, @FileType, @Study_ID, @Survey_ID, @LithoLookupType_ID)

--Return the ID
SELECT SCOPE_IDENTITY()

--Reset the environment
SET NOCOUNT OFF


