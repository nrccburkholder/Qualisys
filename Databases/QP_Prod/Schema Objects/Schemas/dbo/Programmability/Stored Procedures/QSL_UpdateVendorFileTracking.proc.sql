CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileTracking]
@VendorFileTracking_ID INT,
@Member_ID INT,
@ActionDesc VARCHAR(100),
@VendorFile_ID INT,
@ActionDate DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileTracking SET
	Member_ID = @Member_ID,
	ActionDesc = @ActionDesc,
	VendorFile_ID = @VendorFile_ID,
	ActionDate = @ActionDate
WHERE VendorFileTracking_ID = @VendorFileTracking_ID

SET NOCOUNT OFF


