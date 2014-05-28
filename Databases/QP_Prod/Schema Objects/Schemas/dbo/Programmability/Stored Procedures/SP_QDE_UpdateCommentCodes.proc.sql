CREATE PROCEDURE DBO.SP_QDE_UpdateCommentCodes  
@Cmnt_id INT,  
@strCmntCodes VARCHAR(1000)  
  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

IF @strCmntCodes = ''
BEGIN
  SET @strCmntCodes = '-98765'
END
  
DECLARE @SQL VARCHAR(1200)  

DELETE QDECommentSelCodes
WHERE Cmnt_id = @Cmnt_id 
  
SET @SQL = 'INSERT INTO QDECommentSelCodes (Cmnt_id, CmntCode_id)  
SELECT ' + CONVERT(VARCHAR, @Cmnt_id) + ', cc.CmntCode_id  
FROM CommentCodes cc
WHERE cc.CmntCode_id IN (' + @strCmntCodes +')'
  
EXEC (@SQL)


