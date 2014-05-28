CREATE PROCEDURE [dbo].[QSL_DeleteQSIDataForm]
    @Form_ID INT
AS

--Setup the environment
SET NOCOUNT ON

--Delete the form
DELETE [dbo].QSIDataForm
WHERE Form_ID = @Form_ID

--Reset the environment
SET NOCOUNT OFF


