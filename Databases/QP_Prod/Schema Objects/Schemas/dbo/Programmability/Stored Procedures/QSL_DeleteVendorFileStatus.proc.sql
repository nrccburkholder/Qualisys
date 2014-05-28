CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileStatus]
@VendorFileStatus_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileStatus
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF


