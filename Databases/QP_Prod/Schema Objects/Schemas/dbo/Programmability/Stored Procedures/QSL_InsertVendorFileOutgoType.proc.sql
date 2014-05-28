CREATE PROCEDURE [dbo].[QSL_InsertVendorFileOutgoType]
@OutgoType_nm VARCHAR(50),
@OutgoType_desc VARCHAR(250),
@FileExtension VARCHAR(10)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileOutgoTypes (OutgoType_nm, OutgoType_desc, FileExtension)
VALUES (@OutgoType_nm, @OutgoType_desc, @FileExtension)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


