CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLogsByVendorFileId]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM VendorFile_TelematchLog
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


