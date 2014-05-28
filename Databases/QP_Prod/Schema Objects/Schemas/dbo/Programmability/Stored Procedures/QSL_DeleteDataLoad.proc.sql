CREATE PROCEDURE [dbo].[QSL_DeleteDataLoad]
@DataLoad_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_DataLoad
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF


