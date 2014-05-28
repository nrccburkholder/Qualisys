CREATE PROCEDURE [dbo].[QCL_DeleteDisposition]
@Disposition_id INT
AS

SET NOCOUNT ON

DELETE [dbo].Disposition
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF


