CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileTracking]
@VendorFileTracking_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileTracking
WHERE VendorFileTracking_ID = @VendorFileTracking_ID

SET NOCOUNT OFF


