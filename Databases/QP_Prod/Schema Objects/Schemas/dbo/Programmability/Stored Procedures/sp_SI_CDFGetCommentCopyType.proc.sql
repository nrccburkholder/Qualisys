-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the comment copy type
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetCommentCopyType] 
    @QuestionFormID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT sd.strCmntCopyType 
FROM Survey_Def sd, QuestionForm qf 
WHERE qf.Survey_id = sd.Survey_Id 
  AND qf.QuestionForm_Id = @QuestionFormID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


