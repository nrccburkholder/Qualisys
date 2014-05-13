---------------------------------------------------------------------------------------
--QSL_SelectDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectDataLoad]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllDataLoads
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllDataLoads]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllDataLoads]
GO
---------------------------------------------------------------------------------------
--QSL_SelectDataLoadsByVendor_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectDataLoadsByVendorId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectDataLoadsByVendorId]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_InsertDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertDataLoad]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_UpdateDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateDataLoad]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_DeleteDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteDataLoad]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteDataLoad]
@DataLoad_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_DataLoad
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF
GO

