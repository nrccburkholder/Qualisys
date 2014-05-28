/* This stored procedure will update the mailing work table and */
/* insert new rows into the PCLNeeded row with unique batch ids */
/* for each batch. */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
/*  7/28/1999 DV - Fixed bug with calculating new batch ids. */
/*  9/22/1999 DV - Changed to do as much of the changes outside of the transactional scope */
/*   as possible.  This will reduce the contention on all out tables. */
CREATE PROCEDURE SP_FG_Insert_PCLNeeded
AS
 declare @new_batch_id int, @cnt_batch int
 declare @batch_size int
 declare @sentmail_id int, @questionform_id int
 create table #updtcur (
  updtcur_id int identity (0,1),
  scheduledmailing_id int,
  sentmail_id int,
  questionform_id int
 )
/* Log end time of batch in QualPro Params */
 update qualpro_params set datparam_value = getdate() where strparam_nm = 'Last FormGen Run'
/* Get the BatchSize stored in QualPro Params, outside of the transaction */
 select @batch_size=numparam_value
 from dbo.qualpro_params
 where strparam_nm = 'PCLGenBatchsize'
/* Populate #updtcur with the items to update and the values to update with */
/* We will do this outside of the transaction.  Using LOJ because SQL 7.0 does it nicely and */
/* we want to eliminate the NOT IN (SQL 7.0 not doing this nicely now). */
 insert into #updtcur (
  scheduledmailing_id, sentmail_id, questionform_id
 ) SELECT
  mw.scheduledmailing_id, sm.sentmail_id, qf.questionform_id
 FROM #FG_MailingWork mw, dbo.SentMailing sm LEFT OUTER JOIN dbo.QuestionForm qf
  ON sm.sentmail_id = qf.sentmail_id
 WHERE mw.scheduledmailing_id = sm.scheduledmailing_id
 AND mw.Batch_id is null
 if @@error <> 0
 begin
  DROP TABLE #updtcur
  return -1
 end
/* Count the number of records we have genenerated */
 select @cnt_batch = count(*)
 from #updtcur
/* If there are no records in #updtcur, we will exit */
 if @cnt_batch is null OR @cnt_batch = 0
 begin
  DROP TABLE #updtcur
  return 0
 end
 BEGIN TRANSACTION
/* Get the next BatchID stored in Qualpro Params */
 select @new_batch_id = numparam_value
 from dbo.qualpro_params (UPDLOCK)
 where strParam_nm='PCLGenBatchID'
 if @new_batch_id is null
 begin
  /* Insert the new batch_id into QualPro params, if missing */
  select @new_batch_id = 1
  insert into dbo.qualpro_params (
   strparam_nm, strParam_type, strParam_grp,
   numparam_value, comments
  ) values (
   'PCLGenBatchID','N','PCLGen',(@cnt_batch / @batch_size) + @new_batch_id + 1,
   'The last Batch ID processed by PCLGen'
  )
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   DROP TABLE #updtcur
   return -1
  end
 end
 else
 begin
  /* Update QualPro params to move the PCL Batch ID */
  update dbo.qualpro_params
  set numparam_value=(@cnt_batch / @batch_size) + @new_batch_id + 1
  where strParam_nm='PCLGenBatchID'
  if @@error <> 0 
  begin
   ROLLBACK TRANSACTION
   DROP TABLE #updtcur
   return -1
  end
 end
/* Update MailingWork with the correct pieces of information */
/* Since we know that the batch_id will already be null, we won't worry about that check */
 UPDATE #FG_MailingWork
 SET SentMail_id = uc.sentmail_id,
     QuestionForm_id = uc.questionform_id,
     Batch_id = @new_batch_id + (uc.updtcur_id / @batch_size),
     bitDone = 0
 FROM #FG_MailingWork mw, #updtcur uc
 WHERE mw.scheduledmailing_id = uc.scheduledmailing_id
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  DROP TABLE #updtcur
  return -1
 end
/* Only insert into PCLNeeded where we set the batch_id */
--Modified 8/16/2 BD Need to order the insertion into PCLNeeded so they are PCLGen'd in SamplePop order
 INSERT INTO dbo.PCLNeeded (SamplePop_id, Survey_id, SelCover_id, Language, SentMail_id, QuestionForm_id, Batch_id, bitDone, Priority_Flg)
 SELECT SamplePop_id, Survey_id, SelCover_id, LangID,
        SentMail_id, QuestionForm_id, Batch_id, bitDone, Priority_Flg
 FROM #FG_MailingWork
 WHERE Batch_id IS NOT NULL
 ORDER BY SamplePop_id, SentMail_id
 if @@error <> 0 
 begin
  ROLLBACK TRANSACTION
  DROP TABLE #updtcur
  return -1
 end
 COMMIT TRANSACTION
 return 0


