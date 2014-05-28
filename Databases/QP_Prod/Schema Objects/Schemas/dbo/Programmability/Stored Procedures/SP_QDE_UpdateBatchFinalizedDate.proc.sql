CREATE PROCEDURE DBO.SP_QDE_UpdateBatchFinalizedDate
@Batch_id INT,
@strUserName VARCHAR(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

UPDATE QDEBatch
SET datFinalized = GETDATE(), strFinalizedBy = @strUserName
WHERE Batch_id = @Batch_id


