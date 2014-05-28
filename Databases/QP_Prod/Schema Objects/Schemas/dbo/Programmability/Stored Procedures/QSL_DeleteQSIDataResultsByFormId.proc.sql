CREATE PROCEDURE [dbo].[QSL_DeleteQSIDataResultsByFormId]
    @Form_ID  INT
AS

--Setup the environment
SET NOCOUNT ON

--Delete the result
DELETE [dbo].QSIDataResults
WHERE Form_ID = @Form_ID

--Reset the environment
SET NOCOUNT OFF


