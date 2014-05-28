CREATE PROCEDURE [dbo].[QSL_IsQSIDataBatchComplete]
    @Batch_ID INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @OpenFormCount INT

--Get the quantity of open forms
SELECT @OpenFormCount = Count(*)
FROM QSIDataForm
WHERE Batch_ID = @Batch_ID
  AND (DateKeyed IS NULL OR DateVerified IS NULL)

--Get the resultset
IF @OpenFormCount = 0
BEGIN
    --There are no open forms so the batch is complete
    SELECT 1
END
ELSE
BEGIN
    --There are open forms still so the batch is not complete
    SELECT 0
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


