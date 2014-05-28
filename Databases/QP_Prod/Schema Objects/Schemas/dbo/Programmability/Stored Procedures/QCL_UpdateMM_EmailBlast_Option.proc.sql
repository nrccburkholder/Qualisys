CREATE PROCEDURE [dbo].[QCL_UpdateMM_EmailBlast_Option]
@EmailBlast_ID INT,
@Value VARCHAR(42)
AS

SET NOCOUNT ON

UPDATE [dbo].MM_EmailBlast_Options SET
	Value = @Value
WHERE EmailBlast_ID = @EmailBlast_ID

SET NOCOUNT OFF


