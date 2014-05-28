CREATE PROCEDURE [dbo].[QSL_UpdateDisposition]
@DL_Disposition_ID INT,
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@DispositionDate DATETIME,
@VendorDispositionCode VARCHAR(5),
@IsFinal BIT
AS

SET NOCOUNT ON

UPDATE [dbo].DL_Dispositions SET
        DL_LithoCode_ID = @DL_LithoCode_ID,
        DL_Error_ID = @DL_Error_ID,
        DispositionDate = @DispositionDate,
        VendorDispositionCode = @VendorDispositionCode,
        IsFinal = @IsFinal
WHERE DL_Disposition_ID = @DL_Disposition_ID

SET NOCOUNT OFF


