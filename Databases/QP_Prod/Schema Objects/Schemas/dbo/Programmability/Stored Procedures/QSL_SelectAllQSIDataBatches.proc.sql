CREATE PROCEDURE [dbo].[QSL_SelectAllQSIDataBatches]
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT Batch_ID, BatchName, Locked, DateEntered, EnteredBy, DateFinalized, FinalizedBy
FROM [dbo].QSIDataBatch

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


