CREATE PROCEDURE [dbo].[QSL_DeleteBadLitho]
@BadLitho_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_BadLithos
WHERE BadLitho_ID = @BadLitho_ID

SET NOCOUNT OFF


