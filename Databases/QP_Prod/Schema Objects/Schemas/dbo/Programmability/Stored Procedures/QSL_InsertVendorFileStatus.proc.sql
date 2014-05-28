CREATE PROCEDURE [dbo].[QSL_InsertVendorFileStatus]
@VendorFileStatus_nm VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileStatus (VendorFileStatus_nm)
VALUES (@VendorFileStatus_nm)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


