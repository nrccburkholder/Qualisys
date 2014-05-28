CREATE PROCEDURE DBO.SP_QDE_SelectNextForm          
@Batch_id INT,      
@strTemplateName VARCHAR(10),          
@StageID INT,  
@strUser VARCHAR(100)       
AS          
          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
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
          
BEGIN TRAN          
          
DECLARE @tblForms TABLE (Form_id INT, StageID INT, Exclude VARCHAR(100))          
DECLARE @Form_id INT          
DECLARE @Found INT          
SET @Found = 0          
          
WHILE @Found = 0          
BEGIN          
          
 DELETE @tblForms          
          
 INSERT INTO @tblForms          
 SELECT f.Form_id,           
   CASE           
     WHEN datKeyed IS NULL THEN 1           
     WHEN datKeyVerified IS NULL THEN 2          
     WHEN datCoded IS NULL THEN 3          
     WHEN datCodeVerified IS NULL THEN 4          
     ELSE -1  
   END AS StageID,  
   CASE   
     WHEN datKeyed IS NOT NULL AND datKeyVerified IS NULL THEN strKeyedBy  
     WHEN datCoded IS NOT NULL AND datCodeVerified IS NULL THEN strCodedBy    
     ELSE ''  
   END AS Exclude  
 FROM QDEBatch b, QDEForm f, QDEComments c          
 WHERE b.Batch_id = f.Batch_id      
 AND b.Batch_id = @Batch_id      
 AND f.Form_id = c.Form_id          
 AND f.strTemplateName = @strTemplateName          
 AND f.bitLocked = 0      
 AND c.bitIgnore = 0        
          
 SELECT TOP 1 @Form_id = f.Form_id          
 FROM @tblForms t, QDEForm f          
 WHERE t.Form_id = f.Form_id          
 AND t.StageID = @StageID          
 AND t.Exclude <> @strUser  
          
 IF @@ROWCOUNT=0          
 GOTO Completed          
          
 UPDATE QDEForm          
 SET bitLocked = 1          
 WHERE Form_id = @Form_id          
 AND bitLocked = 0          
          
 SELECT @Found = @@RowCount          
END          
          
EXEC DBO.SP_QDE_SelectFormData @Form_id      
      
COMPLETED:          
          
COMMIT TRAN


