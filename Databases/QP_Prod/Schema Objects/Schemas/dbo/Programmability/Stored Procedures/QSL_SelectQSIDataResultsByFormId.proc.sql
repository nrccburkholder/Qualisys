CREATE PROCEDURE [dbo].[QSL_SelectQSIDataResultsByFormId]
    @Form_ID INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT Result_ID, Form_ID, QstnCore, ResponseValue
FROM QSIDataResults
WHERE Form_ID = @Form_ID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


