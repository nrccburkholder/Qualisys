CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileTelematchLog]
@VendorFile_TelematchLog_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFile_TelematchLog
WHERE VendorFile_TelematchLog_ID = @VendorFile_TelematchLog_ID

SET NOCOUNT OFF


