CREATE PROCEDURE DBO.SP_QDE_InsertBatch  
@strUserName VARCHAR(50),  
@BatchType_id INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON      
  
INSERT INTO QDEBatch (datEntered, strEnteredBy, BatchType_id)  
SELECT GETDATE(), @strUserName, @BatchType_id  
  

SELECT Batch_id, strBatchName, BatchType_id, datEntered, strEnteredBy, datFinalized, strFinalizedBy
FROM QDEBatch
WHERE Batch_id = SCOPE_IDENTITY()


