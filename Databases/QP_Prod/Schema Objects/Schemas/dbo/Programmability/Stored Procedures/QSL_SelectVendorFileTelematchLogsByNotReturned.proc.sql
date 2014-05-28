CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLogsByNotReturned]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM [dbo].VendorFile_TelematchLog
WHERE datSent IS NOT NULL
  AND datReturned IS NULL
  
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


