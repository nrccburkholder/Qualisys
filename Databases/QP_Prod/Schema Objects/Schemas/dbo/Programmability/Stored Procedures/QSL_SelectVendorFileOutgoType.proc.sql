CREATE PROCEDURE [dbo].[QSL_SelectVendorFileOutgoType]
@VendorFileOutgoType_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileOutgoType_ID, OutgoType_nm, OutgoType_desc, FileExtension
FROM [dbo].VendorFileOutgoTypes
WHERE VendorFileOutgoType_ID = @VendorFileOutgoType_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


