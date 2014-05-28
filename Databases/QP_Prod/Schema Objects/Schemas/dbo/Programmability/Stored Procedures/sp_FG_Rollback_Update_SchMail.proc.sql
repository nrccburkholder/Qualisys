/****** Object:  Stored Procedure dbo.sp_FG_Rollback_Update_SchMail    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure removes the reference to a SentMailing record in    */
/*       each ScheduledMailing that is related to a Form Gen batch that is  */
/*       rolled back.        */
/*            */
/* Modified by:            */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback_Update_SchMail
 @FrmGenDate varchar(22)
AS
 
 UPDATE dbo.ScheduledMailing
  SET SentMail_id = NULL
   FROM dbo.ScheduledMailing SchM, dbo.SentMailing SM
    WHERE SchM.ScheduledMailing_id = SM.ScheduledMailing_id 
          AND SM.datGenerated = @FrmGenDate


