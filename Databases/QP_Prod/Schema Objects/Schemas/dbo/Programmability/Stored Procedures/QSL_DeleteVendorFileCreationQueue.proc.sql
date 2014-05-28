CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileCreationQueue]
@VendorFile_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileCreationQueue
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF


