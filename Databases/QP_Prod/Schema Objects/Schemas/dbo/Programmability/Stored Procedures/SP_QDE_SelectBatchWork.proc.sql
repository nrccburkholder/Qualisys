CREATE PROCEDURE DBO.SP_QDE_SelectBatchWork      
@StageID   INT,  
@strLogin_nm  VARCHAR(42)      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
SET NOCOUNT ON      
/*      
StageID Determines what work should be selected      
1 = To be keyed      
2 = To be key verified      
3 = To be coded      
4 = To be code verified      
5 = To be hand entered      
6 = To be hand entry verified      
*/      
      
DECLARE @tblForms TABLE (  
 Batch_id   INT,   
 strBatchName  VARCHAR(100),   
 strTemplateName VARCHAR(100),   
 Form_id   INT,   
 Cmnt_id   INT,   
 StageID   INT,   
 WhoDidIt   VARCHAR(42)  
)      
DECLARE @Form_id INT      
      
INSERT INTO @tblForms      
SELECT b.Batch_id, strBatchName, f.strTemplateName, f.Form_id, c.Cmnt_id,      
  CASE       
    WHEN datKeyed IS NULL THEN 1       
    WHEN datKeyVerified IS NULL THEN 2      
    WHEN datCoded IS NULL THEN 3      
    WHEN datCodeVerified IS NULL THEN 4      
  END AS StageID,  
  CASE   
 WHEN datKeyed IS NULL THEN NULL  
 WHEN datKeyVerified IS NULL THEN strKeyedBy  
 WHEN datCoded IS NULL THEN  strKeyVerifiedBy  
 WHEN datCodeVerified IS NULL THEN strCodedBy   
  END AS WhoDidIt  
FROM QDEBatch b, QDEForm f, QDEComments c      
WHERE b.datFinalized IS NULL      
AND b.Batch_id = f.Batch_id      
AND f.Form_id = c.Form_id      
AND f.bitLocked = 0    
AND c.bitIgnore = 0      
      
IF @StageID IN (2,4)
SELECT Batch_id, strBatchName, strTemplateName, COUNT(*) AS 'Count', strTemplateName + ' (' + CONVERT(VARCHAR, COUNT(*)) + ')' AS 'Label',  
 SUM(CASE WHEN WhoDidIt=@strLogin_nm THEN 0 ELSE 1 END) Available  
FROM @tblForms      
WHERE StageID = @StageID      
GROUP BY Batch_id, strBatchName, strTemplateName      
ORDER BY Batch_id, strBatchName, strTemplateName      
ELSE
SELECT Batch_id, strBatchName, strTemplateName, COUNT(*) AS 'Count', strTemplateName + ' (' + CONVERT(VARCHAR, COUNT(*)) + ')' AS 'Label',  
 COUNT(*) Available  
FROM @tblForms      
WHERE StageID = @StageID      
GROUP BY Batch_id, strBatchName, strTemplateName      
ORDER BY Batch_id, strBatchName, strTemplateName


