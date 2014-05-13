---------------------------------------------------------------------------------------
--LD_SelectUploadFilePackage
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadFilePackagesByUploadFileID]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadFilePackagesByUploadFileID]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadFilePackagesByUploadFileID]
@UploadFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadFilePackage_ID, UploadFile_id, Package_id
FROM [dbo].UploadFilePackage
WHERE UploadFile_ID = @UploadFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_SelectUploadFilePackage
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadFilePackage]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadFilePackage]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadFilePackage]
@UploadFilePackage_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadFilePackage_ID, UploadFile_id, Package_id
FROM [dbo].UploadFilePackage
WHERE UploadFilePackage_ID = @UploadFilePackage_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

---------------------------------------------------------------------------------------
--LD_DeleteUploadFilePackage
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_DeleteUploadFilePackage]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_DeleteUploadFilePackage]
GO
CREATE PROCEDURE [dbo].[LD_DeleteUploadFilePackage]
@UploadFilePackage_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].UploadFilePackage
WHERE UploadFilePackage_ID = @UploadFilePackage_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--LD_DeleteByUploadFile
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_DeleteByUploadFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_DeleteByUploadFile]
GO
CREATE PROCEDURE [dbo].[LD_DeleteByUploadFile]
@UploadFile_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].UploadFilePackage
WHERE UploadFile_ID = @UploadFile_ID

SET NOCOUNT OFF
GO
