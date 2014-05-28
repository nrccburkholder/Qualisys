CREATE PROCEDURE [dbo].[QSL_SelectQSIDataBatch]
    @Batch_ID INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT Batch_ID, BatchName, Locked, DateEntered, EnteredBy, DateFinalized, FinalizedBy
FROM [dbo].QSIDataBatch
WHERE Batch_ID = @Batch_ID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


