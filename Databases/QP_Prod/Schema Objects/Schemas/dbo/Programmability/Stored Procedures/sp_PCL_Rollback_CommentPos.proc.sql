/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_CommentPos    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes CommentPos data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:  Dan Archuleta - 7/1/1999 - Changed name from sp_FG_Rollback_CmtPos.  */
/*       - Modified to use joins instead of nested   */      
/*         non-correlated sub-queries.    */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_CommentPos
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.CommentPos 
   FROM dbo.CommentPos CP, dbo.QuestionForm QF, dbo.SentMailing SM
    WHERE CP.QuestionForm_id = QF.QuestionForm_id 
    AND QF.SentMail_id = SM.SentMail_id 
    AND datGenerated = @FrmGenDate


