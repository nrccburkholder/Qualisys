CREATE PROCEDURE DBO.SP_QDE_SelectFormData  
@Form_id INT  
AS  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
SET NOCOUNT ON    
  
SELECT *      
FROM QDEForm  
WHERE Form_id = @Form_id      

DECLARE @Survey_id INT

SELECT @Survey_id=Survey_id FROM QDEForm WHERE Form_id=@Form_id

EXEC SP_QDE_UnScaled_Questions @Survey_id
      
SELECT c.*, q.Label AS 'strQuestionText',    
 CASE WHEN datKeyed IS NULL THEN 0 ELSE 1 END AS bitKeyed,      
 CASE WHEN datKeyVerified IS NULL THEN 0 ELSE 1 END AS bitKeyVerified,      
 CASE WHEN datCoded IS NULL THEN 0 ELSE 1 END AS bitCoded,      
 CASE WHEN datCodeVerified IS NULL THEN 0 ELSE 1 END AS bitCodeVerified      
FROM QDEForm f, QDEComments c, Unscaled_Questions q    
WHERE f.Form_id = @Form_id      
AND f.Form_id = c.Form_id    
AND c.bitIgnore = 0
AND q.Survey_id = f.Survey_id    
AND q.QstnCore = c.QstnCore    
      
SELECT cc.*  
FROM QDEComments c, QDECommentSelCodes cc  
WHERE c.Form_id = @Form_id  
AND c.Cmnt_id = cc.Cmnt_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF


