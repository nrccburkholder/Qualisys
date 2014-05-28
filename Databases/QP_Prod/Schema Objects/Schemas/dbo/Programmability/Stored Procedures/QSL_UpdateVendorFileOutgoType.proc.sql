CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileOutgoType]
@VendorFileOutgoType_ID INT,
@OutgoType_nm VARCHAR(50),
@OutgoType_desc VARCHAR(250),
@FileExtension VARCHAR(10)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileOutgoTypes SET
	OutgoType_nm = @OutgoType_nm,
	OutgoType_desc = @OutgoType_desc,
	FileExtension = @FileExtension
WHERE VendorFileOutgoType_ID = @VendorFileOutgoType_ID

SET NOCOUNT OFF


