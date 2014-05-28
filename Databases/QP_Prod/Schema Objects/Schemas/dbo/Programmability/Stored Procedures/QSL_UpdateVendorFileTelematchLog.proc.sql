CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileTelematchLog]
@VendorFile_TelematchLog_ID INT,
@VendorFile_ID INT,
@datSent DATETIME,
@datReturned DATETIME,
@intRecordsReturned INT,
@datOverdueNoticeSent DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFile_TelematchLog SET
	VendorFile_ID = @VendorFile_ID,
	datSent = @datSent,
	datReturned = @datReturned,
	intRecordsReturned = @intRecordsReturned,
	datOverdueNoticeSent = @datOverdueNoticeSent
WHERE VendorFile_TelematchLog_ID = @VendorFile_TelematchLog_ID

SET NOCOUNT OFF


