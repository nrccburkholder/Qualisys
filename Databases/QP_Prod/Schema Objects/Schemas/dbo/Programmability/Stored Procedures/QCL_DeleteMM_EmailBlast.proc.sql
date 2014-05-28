CREATE PROCEDURE [dbo].[QCL_DeleteMM_EmailBlast]
@MM_EmailBlast_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].MM_EmailBlast
WHERE MM_EmailBlast_ID = @MM_EmailBlast_ID

SET NOCOUNT OFF


