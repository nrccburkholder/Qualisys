CREATE PROCEDURE [dbo].[QSL_DeleteVendorPhoneFile_Data]
@VendorFile_Data_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorPhoneFile_Data
WHERE VendorFile_Data_ID = @VendorFile_Data_ID

SET NOCOUNT OFF


