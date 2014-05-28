/****** Object:  Stored Procedure dbo.sp_PCL_Clean_CommentLoc    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: Removes the data from the CommentLoc table on mailing items that were */
/*       generated but are in error.      */
/*            */
/* Date Created:  7/12/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Clean_CommentLoc
 @FrmGenDate varchar(22)
AS

if exists (select * from dbo.formgenerror where datgenerated = @frmgendate)
begin
 DELETE 
  FROM qp_scan.dbo.CommentLoc 
   FROM qp_scan.dbo.CommentLoc CL, dbo.QuestionForm QF, dbo.SentMailing SM, dbo.FormGenError FGE
    WHERE CL.QuestionForm_id = QF.QuestionForm_id 
    AND QF.SentMail_id = SM.SentMail_id
    AND SM.ScheduledMailing_id = FGE.ScheduledMailing_id
    AND FGE.datgenerated = @FrmGenDate
end


