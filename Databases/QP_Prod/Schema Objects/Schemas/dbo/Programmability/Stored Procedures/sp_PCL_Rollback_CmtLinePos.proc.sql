/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_CmtLinePos    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes CmtLinePos data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:  Dan Archuleta - 7/1/1999 - Changed name from sp_FG_Rollback_CmtLinePos. */
/*       - Modified to use joins instead of nested   */      
/*         non-correlated sub-queries.    */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_CmtLinePos
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.CommentLinePos 
   FROM dbo.CommentLinePos CLP, dbo.QuestionForm QF, dbo.SentMailing SM
    WHERE CLP.QuestionForm_id = QF.QuestionForm_id 
    AND QF.SentMail_id = SM.SentMail_id 
    AND SM.datGenerated = @FrmGenDate


