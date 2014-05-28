CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileStatus]
@VendorFileStatus_ID INT,
@VendorFileStatus_nm VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileStatus SET
	VendorFileStatus_nm = @VendorFileStatus_nm
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF


