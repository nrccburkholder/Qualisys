CREATE PROCEDURE [dbo].[QCL_DeleteMM_EmailBlast_Option]
@EmailBlast_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].MM_EmailBlast_Options
WHERE EmailBlast_ID = @EmailBlast_ID

SET NOCOUNT OFF


