CREATE PROCEDURE DBO.SP_QDE_SelectCommentCodes  
@Cmnt_id INT  
  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
SELECT Cmnt_id, CmntCode_id
FROM QDECommentSelCodes  
WHERE Cmnt_id = @Cmnt_id


