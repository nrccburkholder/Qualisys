CREATE PROCEDURE SP_QDE_SelectFinalizationList  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON      
  
SELECT a.Batch_id, a.strBatchName --, a.datEntered, a.strTemplateName  
FROM (  
  SELECT b.Batch_id, b.strBatchName --, datEntered, strTemplateName   
  FROM QDEBatch b, QDEForm f   
  WHERE b.strFinalizedBy IS NULL   
  AND b.Batch_id=f.Batch_id   
  GROUP BY b.Batch_id, b.strBatchName --, datEntered, strTemplateName  
 ) a  
LEFT OUTER JOIN   
 (  
  SELECT f.Batch_id   
  FROM QDEForm f, QDEComments c   
  WHERE f.Form_id=c.Form_id   
  AND c.strCodeVerifiedBy IS NULL   
  AND c.bitIgnore=0  
  GROUP BY f.Batch_id  
 ) b  
ON a.Batch_id=b.Batch_id  
WHERE b.Batch_id IS NULL


