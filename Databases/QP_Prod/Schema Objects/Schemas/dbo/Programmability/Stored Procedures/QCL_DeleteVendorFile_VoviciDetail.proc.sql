CREATE PROCEDURE [dbo].[QCL_DeleteVendorFile_VoviciDetail]
@VendorFile_VoviciDetail_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFile_VoviciDetails
WHERE VendorFile_VoviciDetail_ID = @VendorFile_VoviciDetail_ID

SET NOCOUNT OFF


