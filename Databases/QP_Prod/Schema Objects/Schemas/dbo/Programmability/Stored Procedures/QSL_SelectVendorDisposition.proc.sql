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


