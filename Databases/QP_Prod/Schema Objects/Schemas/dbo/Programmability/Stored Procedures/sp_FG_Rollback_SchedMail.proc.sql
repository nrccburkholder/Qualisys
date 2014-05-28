/****** Object:  Stored Procedure dbo.sp_FG_Rollback_SchedMail    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/* Business Purpose: Deletes the next mailing steps that have been inserted into    */
/*         ScheduledMailing by the Form Gen batch.     */
/*            */
/* Modified by:  Dan Archuleta - 6/17/1999 - Changed the method of deletion by refering to the */
/*          batch time in the SentMailing table, instead of */        
/*          the records in MailingWork.   */
/************************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback_SchedMail
 @FrmGenDate varchar(22)
AS
 /* Insert the batch's scheduled mailing record into a temp table */
 SELECT SchM.SamplePop_id, SchM.MailingStep_id, NULL AS NextMailingStep_id
  INTO #Mailings
   FROM dbo.ScheduledMailing SCHM, dbo.SentMailing SM
    WHERE SchM.SentMail_id = SM.SentMail_id
    AND SM.datGenerated = @FrmGenDate 
 /* Update each record in the temp table with the next mailing step */
 UPDATE #Mailings
  SET NextMailingStep_id = MS2.MailingStep_id
   FROM dbo.MailingStep MS1, dbo.MailingStep MS2
    WHERE #Mailings.MailingStep_id = MS1.MailingStep_id
    AND MS1.Methodology_id = MS2.Methodology_id
    AND MS1.intSequence + 1 = ms2.intSequence 
 /* Delete the next mailing step from the scheduled mailing table */
 DELETE
  FROM dbo.ScheduledMailing
   FROM dbo.ScheduledMailing SchM, #Mailings M
    WHERE M.SamplePop_id = SchM.SamplePop_id
    AND M.NextMailingStep_id = SchM.MailingStep_id
 /* Drop the temp table */
 DROP TABLE #Mailings


