/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_CommentLoc    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes CommentLoc data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Date Created:  7/1/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_CommentLoc
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.CommentLoc 
   FROM dbo.CommentLoc CL, dbo.QuestionForm QF, dbo.SentMailing SM
    WHERE CL.QuestionForm_id = QF.QuestionForm_id 
    AND QF.SentMail_id = SM.SentMail_id
    AND SM.datgenerated = @FrmGenDate


