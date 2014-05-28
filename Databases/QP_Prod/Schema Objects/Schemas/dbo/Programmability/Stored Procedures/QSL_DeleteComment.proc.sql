CREATE PROCEDURE [dbo].[QSL_DeleteComment]
@DataLoadCmnt_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_Comments
WHERE DataLoadCmnt_ID = @DataLoadCmnt_ID

SET NOCOUNT OFF


