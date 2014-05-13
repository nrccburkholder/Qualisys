---------------------------------------------------------------------------------------
--QSL_SelectVendorFileStatus
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileStatus]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileStatus]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileStatus]
@VendorFileStatus_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileStatus_ID, VendorFileStatus_nm
FROM [dbo].VendorFileStatus
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorFileStatus
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorFileStatus]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorFileStatus]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileStatus]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileStatus_ID, VendorFileStatus_nm
FROM [dbo].VendorFileStatus

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileStatusByVendorFileStatus_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileStatusById]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileStatusById]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileStatusById]
@VendorFileStatus_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileStatus_ID, VendorFileStatus_nm
FROM VendorFileStatus
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorFileStatus
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorFileStatus]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorFileStatus]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorFileStatus]
@VendorFileStatus_nm VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileStatus (VendorFileStatus_nm)
VALUES (@VendorFileStatus_nm)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorFileStatus
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorFileStatus]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorFileStatus]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileStatus]
@VendorFileStatus_ID INT,
@VendorFileStatus_nm VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileStatus SET
	VendorFileStatus_nm = @VendorFileStatus_nm
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorFileStatus
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorFileStatus]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorFileStatus]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileStatus]
@VendorFileStatus_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileStatus
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF
GO

