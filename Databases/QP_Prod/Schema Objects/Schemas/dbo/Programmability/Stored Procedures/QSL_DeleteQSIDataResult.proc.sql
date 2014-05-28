CREATE PROCEDURE [dbo].[QSL_DeleteQSIDataResult]
    @Result_ID INT
AS

--Setup the environment
SET NOCOUNT ON

--Delete the result
DELETE [dbo].QSIDataResults
WHERE Result_ID = @Result_ID

--Reset the environment
SET NOCOUNT OFF


