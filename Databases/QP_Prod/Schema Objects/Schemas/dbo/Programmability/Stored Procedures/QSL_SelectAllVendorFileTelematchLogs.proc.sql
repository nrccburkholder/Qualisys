CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileTelematchLogs]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM [dbo].VendorFile_TelematchLog

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


