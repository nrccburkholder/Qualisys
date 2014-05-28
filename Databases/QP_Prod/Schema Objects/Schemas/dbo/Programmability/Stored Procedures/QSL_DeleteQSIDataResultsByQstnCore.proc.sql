CREATE PROCEDURE [dbo].[QSL_DeleteQSIDataResultsByQstnCore]
    @Form_ID  INT,
    @QstnCore INT
AS

--Setup the environment
SET NOCOUNT ON

--Delete the result
DELETE [dbo].QSIDataResults
WHERE Form_ID = @Form_ID
  AND QstnCore = @QstnCore

--Reset the environment
SET NOCOUNT OFF


