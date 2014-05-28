/****** Object:  Stored Procedure dbo.sp_FG_Rollback_QuesForm    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes QuestionForm data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:            */
/************************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback_QuesForm
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.QuestionForm
   FROM dbo.QuestionForm QF, dbo.SentMailing SM
    WHERE QF.SentMail_id = SM.SentMail_id
    AND SM.datGenerated = @FrmGenDate


