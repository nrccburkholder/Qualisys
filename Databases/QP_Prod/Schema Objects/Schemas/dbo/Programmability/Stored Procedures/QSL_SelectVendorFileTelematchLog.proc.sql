CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLog]
@VendorFile_TelematchLog_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM [dbo].VendorFile_TelematchLog
WHERE VendorFile_TelematchLog_ID = @VendorFile_TelematchLog_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


