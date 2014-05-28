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


