/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_BubbleLoc    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes BubbleLoc data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Date Created:  7/1/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_BubbleLoc
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.BubbleLoc 
   FROM dbo.BubbleLoc BL, dbo.QuestionForm QF, dbo.SentMailing SM
    WHERE BL.QuestionForm_id = QF.QuestionForm_id 
    AND QF.SentMail_id = SM.SentMail_id
    AND SM.datgenerated = @FrmGenDate


