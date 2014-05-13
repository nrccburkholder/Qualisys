---------------------------------------------------------------------------------------
--QSL_SelectTranslationModule
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectTranslationModule]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectTranslationModule]
GO
CREATE PROCEDURE [dbo].[QSL_SelectTranslationModule]
@TranslationModule_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT TranslationModule_ID, Vendor_ID, ModuleName, WatchedFolderPath, FileType
FROM [dbo].DL_TranslationModules
WHERE TranslationModule_ID = @TranslationModule_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllTranslationModules
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllTranslationModules]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllTranslationModules]
GO
---------------------------------------------------------------------------------------
--QSL_SelectTranslationModulesByVendor_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectTranslationModulesByVendorId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectTranslationModulesByVendorId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectTranslationModulesByVendorId]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT TranslationModule_ID, Vendor_ID, ModuleName, WatchedFolderPath, FileType
FROM DL_TranslationModules
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertTranslationModule
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertTranslationModule]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertTranslationModule]
GO
CREATE PROCEDURE [dbo].[QSL_InsertTranslationModule]
@Vendor_ID INT,
@ModuleName VARCHAR(150),
@WatchedFolderPath VARCHAR(1000),
@FileType VARCHAR(5)
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_TranslationModules (Vendor_ID, ModuleName, WatchedFolderPath, FileType)
VALUES (@Vendor_ID, @ModuleName, @WatchedFolderPath, @FileType)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateTranslationModule
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateTranslationModule]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateTranslationModule]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateTranslationModule]
@TranslationModule_ID INT,
@Vendor_ID INT,
@ModuleName VARCHAR(150),
@WatchedFolderPath VARCHAR(1000),
@FileType VARCHAR(5)
AS

SET NOCOUNT ON

UPDATE [dbo].DL_TranslationModules SET
	Vendor_ID = @Vendor_ID,
	ModuleName = @ModuleName,
	WatchedFolderPath = @WatchedFolderPath,
	FileType = @FileType
WHERE TranslationModule_ID = @TranslationModule_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteTranslationModule
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteTranslationModule]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteTranslationModule]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteTranslationModule]
@TranslationModule_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_TranslationModules
WHERE TranslationModule_ID = @TranslationModule_ID

SET NOCOUNT OFF
GO

