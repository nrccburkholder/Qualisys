CREATE PROCEDURE [dbo].[sp_DeleteVendorContact]
@VendorContact_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorContacts
WHERE VendorContact_ID = @VendorContact_ID

SET NOCOUNT OFF


