CREATE PROCEDURE [dbo].[QSL_SelectLithoCodePrevFinalDispoCount]
@DL_LithoCode_ID INT,
@LithoCode VARCHAR(50)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Count(*) AS QtyRec
FROM DL_LithoCodes lc, DL_Dispositions ds
WHERE lc.DL_LithoCode_ID = ds.DL_LithoCode_ID
  AND ds.IsFinal = 1
  AND lc.bitSubmitted = 1
  AND lc.strLithoCode = @LithoCode
  AND lc.DL_LithoCode_ID <> @DL_LithoCode_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


