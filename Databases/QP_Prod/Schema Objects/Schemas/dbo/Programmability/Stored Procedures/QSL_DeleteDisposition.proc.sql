CREATE PROCEDURE [dbo].[QSL_DeleteDisposition]
@DL_Disposition_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_Dispositions
WHERE DL_Disposition_ID = @DL_Disposition_ID

SET NOCOUNT OFF


