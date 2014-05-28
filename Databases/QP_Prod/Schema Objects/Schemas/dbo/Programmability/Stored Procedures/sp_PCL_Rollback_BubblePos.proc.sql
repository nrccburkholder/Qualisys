/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_BubblePos    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes BubblePos data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:  Dan Archuleta - 7/1/1999 - Changed name from sp_FG_Rollback_BubblePos.  */
/*       - Modified to use joins instead of nested   */      
/*         non-correlated sub-queries.    */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_BubblePos
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.BubblePos 
   FROM dbo.BubblePos BP, dbo.QuestionForm QF, dbo.SentMailing SM
    WHERE BP.QuestionForm_id = QF.QuestionForm_id 
    AND QF.SentMail_id = SM.SentMail_id
    AND SM.datgenerated = @FrmGenDate


