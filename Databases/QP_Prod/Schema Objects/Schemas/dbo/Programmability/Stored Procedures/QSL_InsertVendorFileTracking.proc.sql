CREATE PROCEDURE [dbo].[QSL_InsertVendorFileTracking]
@Member_ID INT,
@ActionDesc VARCHAR(100),
@VendorFile_ID INT,
@ActionDate DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileTracking (Member_ID, ActionDesc, VendorFile_ID, ActionDate)
VALUES (@Member_ID, @ActionDesc, @VendorFile_ID, @ActionDate)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


