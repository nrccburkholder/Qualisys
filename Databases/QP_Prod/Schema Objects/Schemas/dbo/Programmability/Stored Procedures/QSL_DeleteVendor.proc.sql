CREATE PROCEDURE [dbo].[QSL_DeleteVendor]
@Vendor_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].Vendors
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF


