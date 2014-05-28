CREATE PROCEDURE [dbo].[QSL_InsertVendorFileTelematchLog]
@VendorFile_ID INT,
@datSent DATETIME,
@datReturned DATETIME,
@intRecordsReturned INT,
@datOverdueNoticeSent DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFile_TelematchLog (VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent)
VALUES (@VendorFile_ID, @datSent, @datReturned, @intRecordsReturned, @datOverdueNoticeSent)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


