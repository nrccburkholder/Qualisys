CREATE PROCEDURE [dbo].[QSL_DeleteVendorWebFile_Data]
@VendorWebFile_Data_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorWebFile_Data
WHERE VendorWebFile_Data_ID = @VendorWebFile_Data_ID

SET NOCOUNT OFF


