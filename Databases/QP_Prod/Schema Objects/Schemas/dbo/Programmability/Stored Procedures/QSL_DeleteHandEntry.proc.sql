CREATE PROCEDURE [dbo].[QSL_DeleteHandEntry]
@DL_HandEntry_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_HandEntry
WHERE DL_HandEntry_ID = @DL_HandEntry_ID

SET NOCOUNT OFF


