CREATE PROCEDURE DBO.SP_QDE_SelectCommentValences  
  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON   
  
SELECT CmntValence_id, strCmntValence_nm  
FROM CommentValences  
WHERE bitRetired = 0  
ORDER BY CmntValence_id


