CREATE PROCEDURE [dbo].[QSL_DeleteVendorDisposition]
@VendorDisposition_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorDispositions
WHERE VendorDisposition_ID = @VendorDisposition_ID

SET NOCOUNT OFF


