﻿/****** Object:  Stored Procedure dbo.sp_PCL_Clean_BubbleItemPos    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: Removes the data from the BubbleItemPos table on mailing items that were */
/*       generated but are in error.      */
/*            */
/* Date Created:  7/12/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Clean_BubbleItemPos
 @FrmGenDate varchar(22)
AS
 
 DELETE 
  FROM qp_scan.dbo.BubbleItemPos   
   FROM qp_scan.dbo.BubbleItemPos BIP, dbo.QuestionForm QF, dbo.SentMailing SM, dbo.FormGenError FGE
    WHERE BIP.QuestionForm_id = QF.QuestionForm_id
    AND QF.SentMail_id = SM.SentMail_id
    AND SM.ScheduledMailing_id = FGE.ScheduledMailing_id
    AND FGE.datGenerated = @FrmGenDate


