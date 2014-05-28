CREATE PROCEDURE [dbo].[QSL_InsertDisposition]
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@DispositionDate DATETIME,
@VendorDispositionCode VARCHAR(5),
@IsFinal BIT
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_Dispositions (DL_LithoCode_ID, DL_Error_ID, DispositionDate, VendorDispositionCode, IsFinal)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @DispositionDate, @VendorDispositionCode, @IsFinal)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


