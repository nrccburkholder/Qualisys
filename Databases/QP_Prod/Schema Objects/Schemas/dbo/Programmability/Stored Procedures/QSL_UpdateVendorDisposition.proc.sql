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


