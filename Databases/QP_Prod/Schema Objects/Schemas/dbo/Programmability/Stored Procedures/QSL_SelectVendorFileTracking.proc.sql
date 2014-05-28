CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTracking]
@VendorFileTracking_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileTracking_ID, Member_ID, ActionDesc, VendorFile_ID, ActionDate
FROM [dbo].VendorFileTracking
WHERE VendorFileTracking_ID = @VendorFileTracking_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


