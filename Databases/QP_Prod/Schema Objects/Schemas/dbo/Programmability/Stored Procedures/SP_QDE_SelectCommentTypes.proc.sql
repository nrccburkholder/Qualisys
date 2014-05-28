CREATE PROCEDURE DBO.SP_QDE_SelectCommentTypes    
    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON     
    
SELECT CmntType_id, strCmntType_nm    
FROM CommentTypes    
WHERE bitRetired = 0    
ORDER BY CmntType_id


