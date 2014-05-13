--Mods to remove HCHAPS field

---------------------------------------------------------------------------------------
--QSL_InsertVendorDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorDisposition]
@Vendor_ID INT,
@Disposition_ID INT,
@VendorDispositionCode VARCHAR(5),
@VendorDispositionLabel VARCHAR(50),
@VendorDispositionDesc VARCHAR(200),
@DateCreated DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorDispositions (Vendor_ID, Disposition_ID, VendorDispositionCode, VendorDispositionLabel, VendorDispositionDesc, DateCreated)
VALUES (@Vendor_ID, @Disposition_ID, @VendorDispositionCode, @VendorDispositionLabel, @VendorDispositionDesc, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorDisposition]
@VendorDisposition_ID INT,
@Vendor_ID INT,
@Disposition_ID INT,
@VendorDispositionCode VARCHAR(5),
@VendorDispositionLabel VARCHAR(50),
@VendorDispositionDesc VARCHAR(200),
@DateCreated DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].VendorDispositions SET
	Vendor_ID = @Vendor_ID,
	Disposition_ID = @Disposition_ID,
	VendorDispositionCode = @VendorDispositionCode,
	VendorDispositionLabel = @VendorDispositionLabel,
	VendorDispositionDesc = @VendorDispositionDesc,
	DateCreated = @DateCreated
WHERE VendorDisposition_ID = @VendorDisposition_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorDisposition]
@VendorDisposition_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorDisposition_ID, Vendor_ID, Disposition_ID, VendorDispositionCode, VendorDispositionLabel, VendorDispositionDesc, DateCreated
FROM [dbo].VendorDispositions
WHERE VendorDisposition_ID = @VendorDisposition_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorDispositionsByVendorId
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorDispositionsByVendorId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorDispositionsByVendorId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorDispositionsByVendorId]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorDisposition_ID, Vendor_ID, Disposition_ID, VendorDispositionCode, VendorDispositionLabel, VendorDispositionDesc, DateCreated
FROM VendorDispositions
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
