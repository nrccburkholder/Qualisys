---------------------------------------------------------------------------------------
--QSL_SelectVendorFileOutgoType
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileOutgoType]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileOutgoType]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileOutgoType]
@VendorFileOutgoType_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileOutgoType_ID, OutgoType_nm, OutgoType_desc, FileExtension
FROM [dbo].VendorFileOutgoTypes
WHERE VendorFileOutgoType_ID = @VendorFileOutgoType_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorFileOutgoTypes
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorFileOutgoTypes]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorFileOutgoTypes]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileOutgoTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileOutgoType_ID, OutgoType_nm, OutgoType_desc, FileExtension
FROM [dbo].VendorFileOutgoTypes

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorFileOutgoType
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorFileOutgoType]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorFileOutgoType]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorFileOutgoType]
@OutgoType_nm VARCHAR(50),
@OutgoType_desc VARCHAR(250),
@FileExtension VARCHAR(10)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileOutgoTypes (OutgoType_nm, OutgoType_desc, FileExtension)
VALUES (@OutgoType_nm, @OutgoType_desc, @FileExtension)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorFileOutgoType
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorFileOutgoType]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorFileOutgoType]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileOutgoType]
@VendorFileOutgoType_ID INT,
@OutgoType_nm VARCHAR(50),
@OutgoType_desc VARCHAR(250),
@FileExtension VARCHAR(10)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileOutgoTypes SET
	OutgoType_nm = @OutgoType_nm,
	OutgoType_desc = @OutgoType_desc,
	FileExtension = @FileExtension
WHERE VendorFileOutgoType_ID = @VendorFileOutgoType_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorFileOutgoType
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorFileOutgoType]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorFileOutgoType]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileOutgoType]
@VendorFileOutgoType_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileOutgoTypes
WHERE VendorFileOutgoType_ID = @VendorFileOutgoType_ID

SET NOCOUNT OFF
GO

