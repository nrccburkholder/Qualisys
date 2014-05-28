CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileOutgoType]
@VendorFileOutgoType_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileOutgoTypes
WHERE VendorFileOutgoType_ID = @VendorFileOutgoType_ID

SET NOCOUNT OFF


