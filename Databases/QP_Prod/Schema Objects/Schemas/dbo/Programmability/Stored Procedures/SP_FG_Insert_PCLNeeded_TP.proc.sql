/* This stored procedure will update the mailing work table and */  
/* insert new rows into the PCLNeeded row with unique batch ids */  
/* for each batch. */  
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */  
/*  7/28/1999 DV - Fixed bug with calculating new batch ids. */  
/*  9/22/1999 DV - Changed to do as much of the changes outside of the transactional scope */  
/*   as possible.  This will reduce the contention on all out tables. */  
/* Adapted from sp_FG_InsertPCLNeede 1/20/04 SS */

CREATE PROCEDURE SP_FG_Insert_PCLNeeded_TP
AS  
 DECLARE @new_batch_id INT, @cnt_batch INT 

-- Not Applicable 1/20/04 SS
	-- DECLARE @batch_size INT  @sentmail_id INT, @questionform_id INT  

-- Not Applicable 1/20/04 SS
	--  CREATE TABLE #updtcur ( updtcur_id int identity (0,1),  scheduledmailing_id int,  sentmail_id int,  questionform_id int )  

	/* Log end time of batch in QualPro Params */  
	
	--  UPDATE qualpro_params SET datparam_value = GETDATE() WHERE strparam_nm = 'Last FormGen_TP Run'  
	-- select * from qualpro_params where strparam_nm = 'Last FormGen_TP Run'
	-- select * from qualpro_params where strparam_nm = 'Last FormGen Run'
	
	-- Not Applicable 1/20/04 ss
			/* Get the BatchSize stored in QualPro Params, outside of the transaction */  
			--  SELECT @batch_size=numparam_value FROM dbo.qualpro_params WHERE strparam_nm = 'PCLGenBatchsize'  
	
	/* Populate #updtcur with the items to update and the values to update with */  
	/* We will do this outside of the transaction.  Using LOJ because SQL 7.0 does it nicely and */  
	/* we want to eliminate the NOT IN (SQL 7.0 not doing this nicely now). */  

-- Not Applicable 1/20/04 ss
		--  INSERT INTO #updtcur (  
		--  scheduledmailing_id, sentmail_id, questionform_id ) 
		--  SELECT  mw.scheduledmailing_id, sm.sentmail_id, qf.questionform_id  
		--  FROM dbo.FG_MailingWork mw, dbo.SentMailing sm LEFT OUTER JOIN dbo.QuestionForm qf  
		--   ON sm.sentmail_id = qf.sentmail_id  
		--   WHERE mw.scheduledmailing_id = sm.scheduledmailing_id  
		--   AND mw.Batch_id is null  
		-- 
		--  if @@error <> 0  
		--  begin  
		--   DROP TABLE #updtcur  
		--   return -1  
		--  end  

		-- /* Count the number of records we have genenerated */  
		--  SELECT @cnt_batch = COUNT(*) FROM #updtcur  

		/* If there are no records in #updtcur, we will exit */  
		--  IF @cnt_batch IS NULL OR @cnt_batch = 0  
		--  BEGIN  
		--   DROP TABLE #updtcur  
		--   RETURN 0  
		--  END  

 BEGIN TRANSACTION  
	/* Get the next BatchID stored in Qualpro Params */  
	 SELECT @new_batch_id = numparam_value  
	 FROM dbo.qualpro_params (UPDLOCK)  
	 WHERE strParam_nm='PCLGenBatchID_TP'  

	 IF @new_batch_id is null  
	 BEGIN  
	  /* Insert the new batch_id into QualPro params, if missing */  
	  SELECT @new_batch_id = 0

	  INSERT INTO dbo.qualpro_params (strparam_nm, strParam_type, strParam_grp, numparam_value, comments) 
		VALUES ('PCLGenBatchID_TP','N','PCLGen_TP',@new_batch_id + 1, 'The last Test Print (TP) Batch ID processed by PCLGen')  

	  IF @@ERROR <> 0  
	  BEGIN  
	   ROLLBACK TRANSACTION  
	   --DROP TABLE #updtcur   -- Not Applicable 1/20/04 SS
	   RETURN -1  
	  END  
	 END  
	 ELSE  
	 BEGIN  


	  /* Update QualPro params to move the PCL Batch ID */  
	  UPDATE dbo.qualpro_params  SET numparam_value = @new_batch_id + 1  WHERE strParam_nm='PCLGenBatchID_TP'  

	  IF @@ERROR <> 0   
	  BEGIN  
	   ROLLBACK TRANSACTION  
	   -- DROP TABLE #updtcur  -- Not Applicable 1/20/04 SS
	   RETURN -1  
	  END  
	 END  


	/* Update MailingWork with the correct pieces of information */  
	/* Since we know that the batch_id will already be null, we won't worry about that check */  
	 UPDATE #FG_MailingWork  
	 SET Batch_id = @new_batch_id + 1, bitDone = 0 -- @new_batch_id + (uc.updtcur_id / @batch_size),  -- Adapted 1/20/04 SS
		/*,SentMail_id = uc.sentmail_id,  QuestionForm_id = uc.questionform_id*/ 
	 FROM #FG_MailingWork mw	--, #updtcur uc  				 -- Adapted 1/20/04 SS
	 --	 WHERE mw.scheduledmailing_id = uc.scheduledmailing_id  -- Adapted 1/20/04 SS

	 IF @@ERROR <> 0  
	 BEGIN  
	  ROLLBACK TRANSACTION  
	  -- DROP TABLE #updtcur  -- Not Applicable 1/20/04 SS
	  RETURN -1  
	 END  

	/* Only insert into PCLNeeded where we set the batch_id */  
	--Modified 8/16/2 BD Need to order the insertion into PCLNeeded so they are PCLGen'd in SamplePop order  

	 INSERT INTO dbo.PCLNeeded_TP (SamplePop_id, Survey_id, SelCover_id, Language, TP_id, /*QuestionForm_id,*/  Batch_id, bitDone, Priority_Flg, strEmail, employee_id, bitMockup)  
	 SELECT SamplePop_id, Survey_id, SelCover_id, LangID, ScheduledMailing_id, /*QuestionForm_id,*/ Batch_id, bitDone, Priority_Flg, strEmail, employee_id, bitMockup 
	 FROM #FG_MailingWork  
	 WHERE Batch_id IS NOT NULL  
	 ORDER BY SamplePop_id, ScheduledMailing_id /* SentMail_id */

	 IF @@ERROR <> 0   
	 BEGIN  
	  ROLLBACK TRANSACTION  
	--  DROP TABLE #updtcur  
	  RETURN -1  
	 END  

 COMMIT TRANSACTION  

 RETURN 0


