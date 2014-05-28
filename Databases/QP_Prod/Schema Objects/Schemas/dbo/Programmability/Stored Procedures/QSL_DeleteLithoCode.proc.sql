CREATE PROCEDURE [dbo].[QSL_DeleteLithoCode]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_LithoCodes
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF


