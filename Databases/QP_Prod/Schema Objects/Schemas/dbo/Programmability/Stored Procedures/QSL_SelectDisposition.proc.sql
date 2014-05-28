CREATE PROCEDURE [dbo].[QSL_SelectDisposition]
@DL_Disposition_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Disposition_ID, DL_LithoCode_ID, DL_Error_ID, DispositionDate, VendorDispositionCode, IsFinal
FROM [dbo].DL_Dispositions
WHERE DL_Disposition_ID = @DL_Disposition_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


