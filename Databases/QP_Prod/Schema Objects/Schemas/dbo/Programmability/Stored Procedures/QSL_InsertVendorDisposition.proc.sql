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


