--sp_helptext sp_queue_GenerationRollback

 CREATE PROCEDURE sp_queue_GenerationRollback @survey_id INT, @datBundled DATETIME, @paperconfig_id INT, @bundlecode VARCHAR(10) = NULL, @who VARCHAR(60)    
 -- Future possible development to allow using sentmailing rather than npsentmailing if DBA needs to rollback something not in npsentmailing anymore.    
 --, @sentmail VARCHAR(13) = 'npsentmailing'    
AS                
            
/*                
Purpose - This stored procedure is to be used in the Queue Manager application.                
   It will allow the print operator to rollback a generation of a specific bundle.                
                
Pramaters - This procedure requires the Survey_id, StrPostalBundle, datBundled, AND the User_id of the operator.                
Create date - 12/6/2004 Ron Niewohner                
Modified date - 1/12/2005 Steve Spicka - Added code to handle MMMailinsteps, error trapping, and conversion of hh:mm:ss.ms sql time to VB time of hh:mm:ss.      

8/18/09 MWB: Added check to VendorFileCreationQueue to make sure this isn't a non-mail generation that has
already been sent to the vendor.  If so, we need them to unsend the non-mail file then they can rollback the
generation.

8/24/09 MWB: Added delete of all Vendor File Information if rollback occurs.

*/                
DECLARE @Rollback_id INT, @cntr INT, @ErrorSave INT, @RBC INT, @VendorFile_ID int          
SET @errorsave = 0            
            
--Creating temp table will hold all mail steps for given survey.                
CREATE TABLE #MailingStep                
(MailingStep_id INT,              
 intSequence INT,              
 MMMailingStep_id INT)                
                
CREATE TABLE #Bad_SentMailWork(                
 SamplePop_id INT,                
 SentMail_id INT,                
 intSequence INT,                
 MailingStep_id INT)                
            
CREATE TABLE #Bad_SentMail(                
 SamplePop_id INT,                
 SentMail_id INT,                
 intSequence INT,                
 MailingStep_id INT)                
                
CREATE TABLE #Bad_QuestionForm(                
 QuestionForm_id INT)                
                
--INSERT INTO the Generation_Rollback table. This is all wraped in a transaction                
--to prevent more then one rollback getting INTO the table before the SELECT                
BEGIN TRAN                
 INSERT INTO Generation_Rollbacks(Survey_id, datBundled, PaperConfig_id, strPostalBundle, Who, datRollback_start)                
 SELECT DISTINCT @survey_id, datBundled, @paperconfig_id, @bundlecode, @who, GETDATE()      
  FROM npsentmailing sm, scheduledmailing sc, mailingstep ms       
  WHERE ms.survey_id = @survey_id      
  AND ABS(DATEDIFF(SECOND,datBundled,@DatBundled))<=1      
  AND paperconfig_id = @paperconfig_id    
  AND strPostalBundle = ISNULL(@BundleCode,RTRIM(sm.strPostalBundle))    
  AND sm.sentmail_id = sc.sentmail_id and sc.mailingstep_Id = ms.mailingstep_id    
      
 -- Get the rowcount and any error code      
 SELECT @RBC = @@ROWCOUNT, @ErrorSave = @@ERROR       
      
 -- IF we have no rows or more than one row inserted then error and rollback tran      
 IF (@RBC <> 1)            
 BEGIN            
   SET @ErrorSave = -1       
   ROLLBACK TRAN             
   RETURN @ErrorSave            
 END            
      
 IF (@ErrorSave <> 0)            
 BEGIN            
   ROLLBACK TRAN             
   RETURN @ErrorSave            
 END            
      
 -- Get the rollback id if we have NO errors and have only one record inserted.              
 SELECT @rollback_id = SCOPE_IDENTITY()          
              
 IF (@@Error = 0)      
 BEGIN                 
COMMIT TRAN                
 END                
 ELSE                
   BEGIN                
   SET @ErrorSave = @@ERROR            
   ROLLBACK TRAN             
   RETURN @ErrorSave            
 END                
                
--INSERTing INTO the #MailingStep table. We are assuming that the sequences do not have gaps....                
INSERT INTO #MailingStep (MailingStep_id, intSequence, MMMailingStep_id)                
SELECT MailingStep_id, intSequence, MMMailingstep_Id                
FROM MailingStep ms, Generation_Rollbacks gr                
WHERE ms.Survey_id = gr.Survey_id                
AND   gr.Rollback_id =  @rollback_id                
ORDER BY intSequence, MailingStep_id                
              
--Getting the information for the rollback.                
INSERT INTO #Bad_SentMailWork (Samplepop_id, SentMail_id, intSequence, MailingStep_id)             
SELECT schm.samplepop_id, sm.sentmail_id, ms.intsequence, ms.MailingStep_id                
FROM npsentmailing sm, scheduledmailing schm, MailingStep ms, Generation_Rollbacks gr                
WHERE ms.Survey_id = gr.survey_id                 
AND sm.datBundled = gr.datBundled                
AND sm.paperconfig_id = gr.paperconfig_id    
AND RTRIM(sm.strPostalBundle) = ISNULL(gr.strPostalBundle,RTRIM(sm.strPostalBundle))    
AND schm.mailingstep_id = ms.mailingstep_id                
AND schm.sentmail_id = sm.sentmail_id                
AND gr.Rollback_id = @rollback_id                
              
/******* Added 1/7/04 SS *********************/              
    
-- Find all mmmailingsteps that are related.              
SELECT Mailingstep_id, MMMailingstep_id, intSequence     
INTO #mmms    
FROM #mailingstep     
 WHERE mmmailingstep_id IN     
 (SELECT DISTINCT ms.mmmailingstep_id FROM #bad_sentmailwork BSM, #mailingstep ms WHERE bsm.mailingstep_Id = ms.mailingstep_id)    
    
-- Find any addtional mmmailingstep generations AND add to the #bad_sentmail table              
INSERT INTO #Bad_SentMailWork (Samplepop_id, SentMail_id, intSequence, MailingStep_id)                
    
SELECT sc.samplepop_id, sc.sentmail_id, mmms.intSequence, mmms.mailingstep_id --, mms.mmmailingstep_id, datBundled, @BundleCode AS strPostalBundle               
FROM scheduledmailing sc, npsentmailing sm, #bad_sentmailwork bsm, #mmms mmms, Generation_Rollbacks gr    
WHERE sc.sentmail_id = sm.sentmail_id AND sc.mailingstep_id = mmms.mailingstep_id     
AND sm.datBundled = gr.datBundled     
AND sm.paperconfig_id = gr.paperconfig_id     
AND RTRIM(sm.strPostalBundle) = ISNULL(gr.strPostalBundle,RTRIM(sm.strPostalBundle))     
AND sc.samplepop_id = bsm.samplepop_id              
    
-- Lets exclude what we already have in #BSM              
AND NOT EXISTS (SELECT * FROM #Bad_SentmailWork bsm WHERE SC.sentmail_id = bsm.sentmail_id)              
            
/******* END Added 1/7/04 SS ******************/              
                
--Looping threw the mailing steps                 
SELECT @Cntr = MAX(intSequence) FROM #Bad_SentMailWork            
            
WHILE @Cntr >= (SELECT MIN(intSequence) FROM #Bad_SentMailWork)                
   BEGIN --Rollback loop                
             
  -- Getting the bad_SentMail for this Loop            
   TRUNCATE TABLE #Bad_SentMail            
              
   INSERT INTO #Bad_SentMail (Samplepop_id, SentMail_id, intSequence, MailingStep_id)              
   SELECT samplepop_id, sentmail_id, intsequence, MailingStep_id FROM #Bad_SentMailWork WHERE intSequence = @Cntr            
            
   --Getting the bad_questionform id's for this Loop            
   TRUNCATE TABLE #Bad_Questionform            
              
   INSERT INTO #Bad_QuestionForm (QuestionForm_id)              
   SELECT qf.questionform_id            
   FROM questionform qf, #bad_sentmail bsm              
   WHERE qf.sentmail_id = bsm.sentmail_id              


    
If EXISTS (SELECT * FROM #bad_QuestionForm b, QuestionResult qr, QuestionForm qf WHERE b.QuestionForm_id=qr.QuestionForm_id AND datReturned IS NOT NULL AND qf.QuestionForm_id=qr.QuestionForm_id)    
   BEGIN    
	--PRINT 'Unable to Rollback Survey! Returns have already came back in for this survey.'    
	RAISERROR (N'Unable to Rollback Survey! Returns have already came back in for this survey.', -- Message text.
           10, -- Severity,
           1, -- State,
           N'number', -- First argument.
           5); -- Second argument.
	RETURN    
   END    

--MWB 8/18/09 check to see if non mail generation has been sent to vendor.
--if so we should not roll back the generation as the vendor would/could already be processing this sampleset.    
If EXISTS ( Select	'x'
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID and
					vfc.vendorfilestatus_ID = 5 and
					vfc.DateFileCreated is not null    
		  )
	BEGIN
	 --PRINT 'Unable to Rollback Survey!  There is a non-mail generation that has been sent to the vendor.  Please unsend this file before rolling back the generation.'
	 RAISERROR (N'Unable to Rollback Survey!  There is a non-mail generation that has been sent to the vendor.  Please unsend this file before rolling back the generation.', -- Message text.
           10, -- Severity,
           1, -- State,
           N'number', -- First argument.
           5); -- Second argument.
	 RETURN
	END		  

/********************************************************************************************/
--MWB 8/24/09
--If a sampleset was rolled back we want to delete all of the non-mail generation data as well.
--select top 1 @VendorFile_ID = vfc.VendorFile_ID
--from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
--where	sp.samplepop_ID = bsm.samplepop_ID and
--		vfc.sampleset_ID = sp.sampleset_ID and
--		vfc.MailingStep_Id = @CurrentMailingStep

--if isnull(@VendorFile_ID, 0) > 0
begin
	BEGIN TRAN    
	 --PRINT 'VendorFile_Freqs'    
	 DELETE VendorFile_Freqs      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )     
	COMMIT TRAN    

	BEGIN TRAN    
	 --PRINT 'VendorFile_nullCounts'    
	 DELETE VendorFile_nullCounts      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )          
	COMMIT TRAN    

	BEGIN TRAN    
	 --PRINT 'VendorPhoneFile_data'    
	 DELETE VendorPhoneFile_data      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )        
	COMMIT TRAN    
	    
	BEGIN TRAN    
	 --PRINT 'VendorWebFile_data'    
	 DELETE VendorWebFile_data      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )      
	COMMIT TRAN    

	BEGIN TRAN    
	 --PRINT 'VendorFile_Messages'    
	 DELETE VendorFile_Messages      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )         
	COMMIT TRAN    

	BEGIN TRAN    
	  --PRINT 'VendorFileTracking'    
	  DELETE VendorFileTracking      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )      
	COMMIT TRAN    

	BEGIN TRAN    
	  --PRINT 'VendorFile_TelematchLog'    
	  DELETE VendorFile_TelematchLog      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )          
	COMMIT TRAN   

	BEGIN TRAN    
	 --PRINT 'VendorFileCreationQueue'    
	 DELETE VendorFileCreationQueue      
	  WHERE vendorFile_ID in ( 
			Select	VendorFile_ID
			from	Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc
			where	sp.samplepop_ID = bsm.samplepop_ID and
					vfc.sampleset_ID = sp.sampleset_ID and
					vfc.MailingStep_ID = bsm.MailingStep_ID
		  )         
	COMMIT TRAN    
end

/********************************************************************************************/    
   

            
 --deleting FROM FormGenError                
  BEGIN TRAN                 
      INSERT INTO Rollback_FormGenError(Rollback_id, FormGenError_id, ScheduledMailing_id, datGenerated, FGErrorType_id)                
      SELECT @Rollback_id, fge.FormGenError_id, fge.ScheduledMailing_id, fge.datGenerated, fge.FGErrorType_id                
      FROM formgenerror fge, scheduledmailing schm, #bad_sentmail bsm                
      WHERE fge.scheduledmailing_id = schm.scheduledmailing_id                
      AND   schm.sentmail_id = bsm.sentmail_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                    
      DELETE formgenerror                
      FROM formgenerror fge, scheduledmailing schm, #bad_sentmail bsm                
      WHERE fge.scheduledmailing_id = schm.scheduledmailing_id                
      AND   schm.sentmail_id = bsm.sentmail_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE         
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END                
                   
 -- deleting FROM qp_queue.dbo.pcloutput                
  BEGIN TRAN                
      INSERT INTO qp_prod.dbo.Rollback_pcloutput(Rollback_id,SENTMAIL_ID,INTSHEET_NUM,PAPERSIZE_ID,INTPA,INTPB,INTPC,INTPD,PCLSTREAM,BITCOVER)                
      SELECT @Rollback_id,po.SENTMAIL_ID,po.INTSHEET_NUM,po.PAPERSIZE_ID,po.INTPA,po.INTPB,po.INTPC,po.INTPD,po.PCLSTREAM,po.BITCOVER                
      FROM qp_queue.dbo.pcloutput po, #bad_sentmail bsm                
      WHERE po.sentmail_id = bsm.sentmail_id                
                  
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
            
      DELETE qp_queue.dbo.pcloutput                
      FROM qp_queue.dbo.pcloutput po, #bad_sentmail bsm                
      WHERE po.sentmail_id = bsm.sentmail_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
                       
 -- deleting FROM pcloutput2                
            
  BEGIN TRAN                
         INSERT INTO qp_prod.dbo.Rollback_pcloutput2(Rollback_id,SENTMAIL_ID,INTSHEET_NUM,PAPERSIZE_ID,INTPA,INTPB,INTPC,INTPD,PCLSTREAM,BITCOVER)                
      SELECT @Rollback_id, po.SENTMAIL_ID,po.INTSHEET_NUM,po.PAPERSIZE_ID,po.INTPA,po.INTPB,po.INTPC,po.INTPD,po.PCLSTREAM,po.BITCOVER                
      FROM qp_queue.dbo.pcloutput po, #bad_sentmail bsm                
      WHERE po.sentmail_id = bsm.sentmail_id                
                  
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE pcloutput2                
      FROM pcloutput2 po, #bad_sentmail bsm                
      WHERE po.sentmail_id = bsm.sentmail_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
            
 --deleting FROM pclneeded                
  BEGIN TRAN                
     INSERT INTO Rollback_PCLNeeded(Rollback_id,SamplePop_id,Survey_id,SelCover_id,Language,SentMail_id,QuestionForm_id,Batch_id,bitDone,Priority_Flg)                
      SELECT @Rollback_id,pn.SamplePop_id,pn.Survey_id,pn.SelCover_id,pn.Language,pn.SentMail_id,pn.QuestionForm_id,pn.Batch_id,pn.bitDone,pn.Priority_Flg                
         FROM pclneeded pn, #bad_sentmail bsm                
      WHERE pn.sentmail_id = bsm.sentmail_id                
                  
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE pclneeded                
      FROM pclneeded pn, #bad_sentmail bsm                
      WHERE pn.sentmail_id = bsm.sentmail_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
            
 -- Deleteing FROM qp_scan.dbo.bubbleloc                
  BEGIN TRAN                
      INSERT INTO Rollback_BubbleLoc(Rollback_id,QuestionForm_id,SelQstns_id,Item,SampleUnit_id,CharSet,Val,intRespType,RelX,RelY)                
      SELECT @Rollback_id,bl.QuestionForm_id,bl.SelQstns_id,bl.Item,bl.SampleUnit_id,bl.CharSet,bl.Val,bl.intRespType,bl.RelX,bl.RelY                
      FROM qp_scan.dbo.bubbleloc bl, #bad_questionform bqf                
      WHERE bl.questionform_id = bqf.questionform_id                
                  
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.bubbleloc                
      FROM qp_scan.dbo.bubbleloc bl, #bad_questionform bqf                
      WHERE bl.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
                   
 -- deleting FROM qp_scan.dbo.commentloc                
  BEGIN TRAN                
      INSERT INTO Rollback_CommentLoc(Rollback_id,QuestionForm_id,SelQstns_id,Line,SampleUnit_id,RelX,RelY,Width,Height)                
      SELECT @rollback_id,cl.QuestionForm_id,cl.SelQstns_id,cl.Line,cl.SampleUnit_id,cl.RelX,cl.RelY,cl.Width,cl.Height                
      FROM qp_scan.dbo.commentloc cl, #bad_questionform bqf                
      WHERE cl.questionform_id = bqf.questionform_id                   
                  
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.commentloc                
      FROM qp_scan.dbo.commentloc cl, #bad_questionform bqf                
      WHERE cl.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END             
                  
 --deleting FROM qp_scan.dbo.bubblepos                
  BEGIN TRAN                
      INSERT INTO Rollback_BubblePos(Rollback_id,QUESTIONFORM_ID,SAMPLEUNIT_ID,INTPAGE_NUM,QSTNCORE,INTBEGCOLUMN,READMETHOD_ID,INTRESPCOL)                
      SELECT @Rollback_id,bp.QUESTIONFORM_ID,bp.SAMPLEUNIT_ID,bp.INTPAGE_NUM,bp.QSTNCORE,bp.INTBEGCOLUMN,bp.READMETHOD_ID,bp.INTRESPCOL                
      FROM qp_scan.dbo.bubblepos bp, #bad_questionform bqf                
      WHERE bp.questionform_id = bqf.questionform_id                
                  
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.bubblepos                
      FROM qp_scan.dbo.bubblepos bp, #bad_questionform bqf                
      WHERE bp.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
            
 --Deleting FROM qp_scan.dbo.pclquestionform                
  BEGIN TRAN             
 INSERT INTO Rollback_pclquestionform(Rollback_id,QuestionForm_id,Batch_id,Survey_id,paper_type,language,bitIsProcessed)                
      SELECT @Rollback_id,pqf.QuestionForm_id,pqf.Batch_id,pqf.Survey_id,pqf.paper_type,pqf.language,pqf.bitIsProcessed                
      FROM qp_scan.dbo.pclquestionform pqf, #bad_questionform bqf                
      WHERE pqf.questionform_id = bqf.questionform_id                
                  
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.pclquestionform                
      FROM qp_scan.dbo.pclquestionform pqf, #bad_questionform bqf                
      WHERE pqf.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END             
                 
 --deleting FROM qp_scan.dbo.pclresults                
  BEGIN TRAN                
      INSERT INTO Rollback_PCLResults(Rollback_id,QuestionForm_id,PCLResults_id,QstnCore,X,Y,Height,Width,PageNum,Side,Sheet,SelQstns_id,BegColumn,ReadMethod,intRespCol,SampleUnit_id)                
      SELECT @Rollback_id,pr.QuestionForm_id,pr.PCLResults_id,pr.QstnCore,pr.X,pr.Y,pr.Height,pr.Width,pr.PageNum,pr.Side,pr.Sheet,pr.SelQstns_id,pr.BegColumn,pr.ReadMethod,pr.intRespCol,pr.SampleUnit_id                
      FROM qp_scan.dbo.pclresults pr, #bad_questionform bqf                
      WHERE pr.questionform_id = bqf.questionform_id                
                  
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
            
      DELETE qp_scan.dbo.pclresults                
      FROM qp_scan.dbo.pclresults pr, #bad_questionform bqf                
      WHERE pr.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END             
            
 -- deleting deom qp_scan.dbo.bubbleitempos                
  BEGIN TRAN                
      INSERT INTO Rollback_BubbleItemPos(Rollback_id,QUESTIONFORM_ID,INTPAGE_NUM,QSTNCORE,SURVEY_ID,ITEM,SAMPLEUNIT_ID,VAL,X_POS,Y_POS)                
      SELECT @Rollback_id,bip.QUESTIONFORM_ID,bip.INTPAGE_NUM,bip.QSTNCORE,bip.SURVEY_ID,bip.ITEM,bip.SAMPLEUNIT_ID,bip.VAL,bip.X_POS,bip.Y_POS                
      FROM qp_scan.dbo.bubbleitempos bip, #bad_questionform bqf                
      WHERE bip.questionform_id = bqf.questionform_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.bubbleitempos                
      FROM qp_scan.dbo.bubbleitempos bip, #bad_questionform bqf                
      WHERE bip.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
                   
 --deleting FROM qp_scan.dbo.commentpos                
  BEGIN TRAN                
  INSERT INTO Rollback_CommentPos(Rollback_id,QUESTIONFORM_ID,INTPAGE_NUM,CMNTBOX_ID,SAMPLEUNIT_ID,X_POS,Y_POS,INTWIDTH,INTHEIGHT)                
   SELECT @Rollback_id,cp.QUESTIONFORM_ID,cp.INTPAGE_NUM,cp.CMNTBOX_ID,cp.SAMPLEUNIT_ID,cp.X_POS,cp.Y_POS,cp.INTWIDTH,cp.INTHEIGHT                
      FROM qp_scan.dbo.commentpos cp, #bad_questionform bqf                
      WHERE cp.questionform_id = bqf.questionform_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.commentpos                
      FROM qp_scan.dbo.commentpos cp, #bad_questionform bqf                
      WHERE cp.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
    SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
   RETURN @ErrorSave            
    END            
                   
 --deleting FROM qp_scan.dbo.commentlinepos                
  BEGIN TRAN                
      INSERT INTO Rollback_COMMENTLINEPOS(Rollback_id,QUESTIONFORM_ID,INTPAGE_NUM,CMNTBOX_ID,INTLINE_NUM,SAMPLEUNIT_ID,X_POS,Y_POS,INTWIDTH,INTHEIGHT)                
      SELECT @Rollback_id,clp.QUESTIONFORM_ID,clp.INTPAGE_NUM,clp.CMNTBOX_ID,clp.INTLINE_NUM,clp.SAMPLEUNIT_ID,clp.X_POS,clp.Y_POS,clp.INTWIDTH,clp.INTHEIGHT                
      FROM qp_scan.dbo.commentlinepos clp, #bad_questionform bqf                
      WHERE clp.questionform_id = bqf.questionform_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.commentlinepos                
      FROM qp_scan.dbo.commentlinepos clp, #bad_questionform bqf                
      WHERE clp.questionform_id = bqf.questionform_id                
            
   IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
   ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
    END            
                   
 --deleting form qp_scan.dbo.hANDwrittenpos                
  BEGIN TRAN                
      INSERT INTO Rollback_HANDWrittenPos(Rollback_id,QuestionForm_id,intPage_num,QstnCore,Item,SampleUnit_id,Line_id,X_Pos,Y_Pos,intWidth)                
      SELECT @Rollback_id,hrp.QuestionForm_id,hrp.intPage_num,hrp.QstnCore,hrp.Item,hrp.SampleUnit_id,hrp.Line_id,hrp.X_Pos,hrp.Y_Pos,hrp.intWidth                
      FROM qp_scan.dbo.hANDwrittenpos hrp, #bad_questionform bqf                
      WHERE hrp.questionform_id = bqf.questionform_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.hANDwrittenpos                
      FROM qp_scan.dbo.hANDwrittenpos hrp, #bad_questionform bqf                
      WHERE hrp.questionform_id = bqf.questionform_id                
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
      END            
                   
 --deleting FROM p_scan.dbo.hANDwrittenloc                
  BEGIN TRAN                
      INSERT INTO Rollback_HANDWrittenLoc(Rollback_id,QuestionForm_id,SelQstns_id,Item,SampleUnit_id,Line_id,RelX,RelY,intWidth)                
      SELECT @Rollback_id,hrl.QuestionForm_id,hrl.SelQstns_id,hrl.Item,hrl.SampleUnit_id,hrl.Line_id,hrl.RelX,hrl.RelY,hrl.intWidth                
      FROM qp_scan.dbo.hANDwrittenloc hrl, #bad_questionform bqf                
      WHERE hrl.questionform_id = bqf.questionform_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE qp_scan.dbo.hANDwrittenloc                
      FROM qp_scan.dbo.hANDwrittenloc hrl, #bad_questionform bqf                
      WHERE hrl.questionform_id = bqf.questionform_id                
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
    BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
      END            
            
   /********************************************************************************************************************************/                  
  /*The next section is removing any furture mailing step (sentmail_id IS NULL).                
 --deleting the next mailing step.        
   */                
   IF @cntr < (SELECT MAX(intsequence) FROM #MailingStep)                
   BEGIN                
    BEGIN TRAN                
      INSERT INTO Rollback_ScheduledMailing(Rollback_id,SCHEDULEDMAILING_ID,MAILINGSTEP_ID,SAMPLEPOP_ID,OVERRIDEITEM_ID,SENTMAIL_ID,METHODOLOGY_ID,DATGENERATE)                
      SELECT @Rollback_id,schm.SCHEDULEDMAILING_ID,schm.MAILINGSTEP_ID,schm.SAMPLEPOP_ID,schm.OVERRIDEITEM_ID,schm.SENTMAIL_ID,schm.METHODOLOGY_ID,schm.DATGENERATE                
      FROM scheduledmailing schm, #Bad_SentMail bsm                
      WHERE  schm.mailingstep_id IN (SELECT mailingstep_id FROM #MailingStep WHERE intSequence = @cntr+1)                
      AND    schm.samplepop_id  = bsm.samplepop_id                
      AND    schm.SentMail_id is NULL                 
              
     IF (@@ERROR <> 0)            
     BEGIN            
      SET @ErrorSave = @@ERROR            
      ROLLBACK TRAN             
      RETURN @ErrorSave            
     END            
                      
      DELETE scheduledmailing                
      FROM scheduledmailing schm, #Bad_SentMail bsm                
      WHERE  schm.mailingstep_id IN (SELECT mailingstep_id FROM #MailingStep WHERE intSequence = @cntr+1)                
      AND    schm.samplepop_id  = bsm.samplepop_id                 
      AND    schm.SentMail_id is NULL                
             
     IF @@ERROR = 0                 
     BEGIN                 
   COMMIT TRAN                
     END                
     ELSE                
     BEGIN                
      SET @ErrorSave = @@ERROR            
      ROLLBACK TRAN             
      RETURN @ErrorSave            
       END            
  END                
               
 /********************************************************************************************************************************/                  
                   
  --Updating the sentmail_id column to NULL in SentMailing / or deleting the secondary mailingstep for a "double stuff" methodology               
  BEGIN TRAN                
      INSERT INTO Rollback_ScheduledMailing(Rollback_id,SCHEDULEDMAILING_ID,MAILINGSTEP_ID,SAMPLEPOP_ID,OVERRIDEITEM_ID,SENTMAIL_ID,METHODOLOGY_ID,DATGENERATE)                
      SELECT @Rollback_id,schm.SCHEDULEDMAILING_ID,schm.MAILINGSTEP_ID,schm.SAMPLEPOP_ID,schm.OVERRIDEITEM_ID,schm.SENTMAIL_ID,schm.METHODOLOGY_ID,schm.DATGENERATE                
         FROM scheduledmailing schm, #bad_sentmail bsm                
      WHERE schm.sentmail_id = bsm.sentmail_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
                  
 -- delete from scheduledmailing if the mailingstep is NOT the primary mailingstep for a mutiple mailing step.            
   --PRINT 'DELETE'            
   DELETE scheduledmailing              
   FROM scheduledmailing schm, #Bad_SentMail bsm, #mailingstep ms             
   WHERE schm.sentmail_id = bsm.sentmail_id AND schm.mailingstep_id = ms.mailingstep_id AND ms.mailingstep_id <> ms.mmmailingstep_id            
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
              
 -- now update any remaining sentmail_id to NULL if the mailingstep is the primary of a mutiple mailing step / or the mailingstep is not part of a mutiplemailingmethodology.            
   --PRINT 'UPDATE'            
   UPDATE scheduledmailing set sentmail_id = NULL              
   FROM scheduledmailing schm, #bad_sentmail bsm WHERE schm.sentmail_id = bsm.sentmail_id            
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN         
    END                
    ELSE                
       BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
       END                
                       
            
 --Deleting FROM PCLGenLog                
  BEGIN TRAN                
      INSERT INTO Rollback_PCLGenLog(Rollback_id,PCLGENLOG_ID,PCLGENRUN_ID,SURVEY_ID,SENTMAIL_ID,LOGENTRY,DATLOGGED)                
      SELECT @Rollback_id,pcl.PCLGENLOG_ID,pcl.PCLGENRUN_ID,pcl.SURVEY_ID,pcl.SENTMAIL_ID,pcl.LOGENTRY,pcl.DATLOGGED                
         FROM pclgenlog pcl, #bad_sentmail bsm                
      WHERE pcl.sentmail_id = bsm.sentmail_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE pclgenlog                
      FROM pclgenlog pcl, #bad_sentmail bsm                
      WHERE pcl.sentmail_id = bsm.sentmail_id                
             
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
       BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
       END                
             
                   
 --deleting FROM questionform                 
  BEGIN TRAN                
      INSERT INTO Rollback_QuestionForm(Rollback_id,QUESTIONFORM_ID,SENTMAIL_ID,SAMPLEPOP_ID,CUTOFF_ID,DATRETURNED,SURVEY_ID,UnusedReturn_id,datUnusedReturn,datResultsImported,              
          strSTRBatchNumber,intSTRLineNumber,intPhoneAttempts)                
      SELECT @Rollback_id,qf.QUESTIONFORM_ID,qf.SENTMAIL_ID,qf.SAMPLEPOP_ID,qf.CUTOFF_ID,qf.DATRETURNED,qf.SURVEY_ID,qf.UnusedReturn_id,qf.datUnusedReturn,qf.datResultsImported,              
    qf.strSTRBatchNumber,qf.intSTRLineNumber,qf.intPhoneAttempts                
      FROM questionform qf, #bad_sentmail bsm                
      WHERE qf.sentmail_id = bsm.sentmail_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN       
    RETURN @ErrorSave            
   END            
                  
      DELETE questionform                
      FROM questionform qf, #bad_sentmail bsm                
      WHERE qf.sentmail_id = bsm.sentmail_id                
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
       BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
       END                
                  
 --deleting FROM questionform_extract                
  BEGIN TRAN                
      INSERT INTO Rollback_questionform_extract(Rollback_id,QFExtract_ID,QuestionForm_ID,tiExtracted,datExtracted_DT,Study_ID)                
      SELECT @Rollback_id,qfe.QFExtract_ID,qfe.QuestionForm_ID,qfe.tiExtracted,qfe.datExtracted_DT,qfe.Study_ID                
      FROM questionform_extract qfe, #bad_questionform bqf                
      WHERE qfe.questionform_id = bqf.questionform_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE questionform_extract                
      FROM questionform_extract qfe, #bad_questionform bqf                
      WHERE qfe.questionform_id = bqf.questionform_id                
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
       BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
       END                
                  
 --deleting FROM sentmailing                 
  BEGIN TRAN                
      INSERT INTO Rollback_SentMailing(Rollback_id,SENTMAIL_ID,SCHEDULEDMAILING_ID,DATGENERATED,DATPRINTED,DATMAILED,METHODOLOGY_ID,PAPERCONFIG_ID,STRLITHOCODE,              
          STRPOSTALBUNDLE,INTPAGES,DATUNDELIVERABLE,INTRESPONSESHAPE,STRGROUPDEST,datDELETEd,datBundled,intReprinted,datReprinted,LangID,datExpire)                
      SELECT @Rollback_id,sm.SENTMAIL_ID,sm.SCHEDULEDMAILING_ID,sm.DATGENERATED,sm.DATPRINTED,sm.DATMAILED,sm.METHODOLOGY_ID,sm.PAPERCONFIG_ID,sm.STRLITHOCODE,           
    sm.STRPOSTALBUNDLE,sm.INTPAGES,sm.DATUNDELIVERABLE,sm.INTRESPONSESHAPE,sm.STRGROUPDEST, sm.datDELETEd,sm.datBundled,sm.intReprinted,sm.datReprinted,sm.LangID,sm.datExpire                
      FROM sentmailing sm, #bad_sentmail bsm                
      WHERE sm.sentmail_id = bsm.sentmail_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE sentmailing                
      FROM sentmailing sm, #bad_sentmail bsm                
      WHERE sm.sentmail_id = bsm.sentmail_id                
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
       BEGIN                
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
       END                
                    
 --deleting FROM NPSentMailing                
  BEGIN TRAN                
      INSERT INTO Rollback_NPSentMailing(Rollback_id,SENTMAIL_ID,SCHEDULEDMAILING_ID,DATGENERATED,DATPRINTED,DATMAILED,METHODOLOGY_ID,PAPERCONFIG_ID,STRLITHOCODE,STRPOSTALBUNDLE,              
          INTPAGES,DATUNDELIVERABLE,INTRESPONSESHAPE,STRGROUPDEST,datDELETEd,datBundled, intReprinted,datReprinted)                
      SELECT @Rollback_id,sm.SENTMAIL_ID,sm.SCHEDULEDMAILING_ID,sm.DATGENERATED,sm.DATPRINTED,sm.DATMAILED,sm.METHODOLOGY_ID,sm.PAPERCONFIG_ID,sm.STRLITHOCODE,sm.STRPOSTALBUNDLE,              
     sm.INTPAGES,sm.DATUNDELIVERABLE,sm.INTRESPONSESHAPE,sm.STRGROUPDEST, sm.datDELETEd,sm.datBundled,sm.intReprinted,sm.datReprinted                
      FROM NPsentmailing sm, #bad_sentmail bsm                
      WHERE sm.sentmail_id = bsm.sentmail_id                
            
   IF (@@ERROR <> 0)            
   BEGIN            
    SET @ErrorSave = @@ERROR            
    ROLLBACK TRAN             
    RETURN @ErrorSave            
   END            
                  
      DELETE NPsentmailing                
      FROM NPsentmailing sm, #bad_sentmail bsm                
      WHERE sm.sentmail_id = bsm.sentmail_id                
            
    IF @@ERROR = 0                 
    BEGIN                 
  COMMIT TRAN                
    END                
    ELSE                
       BEGIN      
     SET @ErrorSave = @@ERROR            
     ROLLBACK TRAN             
     RETURN @ErrorSave            
       END                
                   
 --decreasing the @cntr by one. This will roll back any addition step included in the bundle.                
 SELECT @cntr = @cntr - 1                
 END --ENDing the rollback loop                
        
-- Now update the end time for the rollback record only if the badsentmail records no longer exist in npsentmailing.      
-- That way we know we actually rolled something back, not an empty set.      
IF NOT EXISTS (SELECT * FROM NPsentmailing sm, #bad_sentmail bsm WHERE sm.sentmail_id = bsm.sentmail_id)      
 UPDATE Generation_Rollbacks  SET datRollback_end = GETDATE() WHERE rollback_id = @rollback_id        
                
--Cleaning up all the temp work tables                
DROP TABLE #mailingstep                
DROP TABLE #mmms    
DROP TABLE #bad_sentmailwork            
DROP TABLE #bad_sentmail                
DROP TABLE #bad_questionform


