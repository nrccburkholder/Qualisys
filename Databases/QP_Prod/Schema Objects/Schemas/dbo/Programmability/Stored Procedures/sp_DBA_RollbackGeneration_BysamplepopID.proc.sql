CREATE PROCEDURE sp_DBA_RollbackGeneration_BysamplepopID @samplepop_id INT,@Survey_id INT,@CurrentMailingStep INT=NULL, @intSequence INT=NULL,  @datGenerated DATETIME=NULL  ,  @datMailed DATETIME=NULL, @ScheduledToGenerate DATETIME=NULL  
AS        
-- 10/24/2011 - The old proc sp_DBA_RollbackGeneration_BySampleSetID_bkp has been updated with respect to the proc: "sp_DBA_RollbackGeneration".  
-- The proc has been changed to take sampleset_id and survey_id as variables.  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
-- Declare variable section        
DECLARE @NextMailingStep INT, @VendorFile_ID int  
--@CurrentMailingStep INT=NULL, @intSequence INT=NULL,    
--@datGenerated DATETIME=NULL  ,  @datMailed DATETIME=NULL,   
--@ScheduledToGenerate DATETIME=NULL  
  
    SET @NextMailingStep=0  
    --SET @CurrentMailingStep = NULL  
    --SET @intSequence = NULL  
    --SET @datGenerated = NULL  
    --SET @datMailed = NULL  
    --SET @ScheduledToGenerate = NULL      
  
IF @intSequence IS NULL               
BEGIN               
 SET @intSequence=0              
END              
              
            
IF @CurrentMailingStep IS NULL OR @datGenerated IS NULL              
 BEGIN              
 --Getting all generated steps.              
 SELECT  ms.MailingStep_id, intSequence, strMailingStep_nm,       
   CONVERT(VARCHAR(10),datGenerated,120) AS datgened,               
   CONVERT(VARCHAR(10),datprinted,120) AS datprinted,      
   CONVERT(VARCHAR(10),datMailed,120) AS datMailed,       
   CONVERT(VARCHAR(10),datGenerate,120) AS ScheduledGenerateDate,       
   COUNT(*) as GenCount              
 FROM  SentMailing sm (NOLOCK), ScheduledMailing schm (NOLOCK), MailingStep ms (NOLOCK), MailingMethodology mm              
 WHERE  sm.ScheduledMailing_id=schm.ScheduledMailing_id              
 AND  schm.MailingStep_id=ms.MailingStep_id              
 AND  sm.Methodology_id=mm.Methodology_id              
 AND  mm.Survey_id=@Survey_id              
 AND  mm.bitActiveMethodology=1              
 GROUP BY ms.MailingStep_id, intSequence, strMailingStep_nm,             
   CONVERT(VARCHAR(10),datGenerated,120),      
   CONVERT(VARCHAR(10),datprinted,120),             
   CONVERT(VARCHAR(10),datMailed,120), CONVERT(VARCHAR(10),datGenerate,120)               
 ORDER BY strMailingStep_nm, CONVERT(VARCHAR(10),datGenerated,120)              
              
 RETURN              
 END               
                       
PRINT @intSequence              
  
    
--Getting the next mailing step        
select @NextMailingStep = sm.mailingstep_id    
from samplepop sp inner join scheduledmailing sm    
 on sp.samplepop_id = sm.samplepop_id    
where sp.samplepop_id = @samplepop_id    
    
create table #bad_SentMail (SamplePop_ID int, SentMail_ID int)      
create table #bad_SchedMail (SamplePop_ID int, SentMail_ID int, ScheduledMailing_ID int)            
            
            
if @datMailed is null         
 begin            
  --Creating the Temp tables for the Rollbacks              
  insert into #bad_SentMail            
  SELECT schm.samplepop_id, sm.SentMail_id        
  FROM SentMailing sm, ScheduledMailing schm, samplepop sp              
  WHERE sm.scheduledmailing_Id=schm.scheduledmailing_Id     
  AND schm.samplepop_id = sp.samplepop_id           
  AND sm.datMailed IS NULL              
  AND CONVERT(VARCHAR(10),datGenerated,120)=@datGenerated               
  AND schm.MailingStep_id=@CurrentMailingStep          
  AND sp.samplepop_id = @samplepop_id  

select * from #bad_sentmail
  
  end              
else            
 begin  
  
insert into #bad_SentMail      
select sm.samplepop_id, sm.sentmail_id    
from samplepop sp inner join scheduledmailing sm    
 on sp.samplepop_id = sm.samplepop_id    
where sp.samplepop_id = @samplepop_id 

select * from #bad_sentmail   
  END  
if @ScheduledToGenerate is not null            
 begin            
  --mb 4/1/09            
  --add any possible records that may not have generated the first time.            
  --TOCL records might have a sentmail_ID of -1 in hte scheduledmailing table            
  --and no record in the sentmail table.  We still want to reset these in the             
  --scheduledmailing table.            
  insert into #bad_SchedMail            
   SELECT schm.samplepop_id, schm.SentMail_id, schm.scheduledmailing_ID              
  FROM ScheduledMailing schm, mailingmethodology mm, samplepop sp            
  WHERE schm.methodology_ID = mm.methodology_ID            
  AND schm.samplepop_id = sp.samplepop_id   
  AND mm.survey_ID = @Survey_id            
  AND CONVERT(VARCHAR(10),datGenerate,120)=@ScheduledToGenerate               
  AND schm.MailingStep_id=@CurrentMailingStep             
  AND schm.sentmail_ID = -1  
  AND sp.samplepop_id = @samplepop_id            
 end   
  
    
SELECT QuestionForm_id         
INTO #bad_QuestionForm         
FROM QuestionForm qf, #bad_SentMail bsm        
WHERE qf.SentMail_id=bsm.SentMail_id        
        
SELECT *    
FROM QuestionForm qf, #bad_SentMail bsm              
WHERE qf.SentMail_id=bsm.SentMail_id    
        
--If either of the next two queries RETURN values, DO NOT continue        
IF EXISTS (SELECT * FROM #bad_QuestionForm b, QuestionResult qr WHERE b.QuestionForm_id=qr.QuestionForm_id)        
   BEGIN        
 PRINT 'Unable to Rollback Survey! Error 01'        
 RETURN        
   END        
        
If EXISTS (SELECT * FROM #bad_QuestionForm b, QuestionResult qr, QuestionForm qf WHERE b.QuestionForm_id=qr.QuestionForm_id AND datReturned IS NOT NULL AND qf.QuestionForm_id=qr.QuestionForm_id)        
   BEGIN        
 PRINT 'Unable to Rollback Survey! Error 02'        
 RETURN        
   END        
  
--MWB 8/18/09 check to see if non mail generation has been sent to vendor.          
--if so we should not roll back the generation as the vendor would/could already be processing this sampleset.              
If EXISTS ( Select 'x'          
   from Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc          
   where sp.samplepop_ID = bsm.samplepop_ID and          
     vfc.sampleset_ID = sp.sampleset_ID and          
     vfc.MailingStep_Id = @CurrentMailingStep and          
     vfc.vendorfilestatus_ID = 5 and          
     vfc.DateFileCreated is not null and  
     sp.samplepop_id = @samplepop_id        
    )          
 BEGIN          
  PRINT 'There is a non-mail generation that has been sent to the vendor.  Please roll this back before rolling back the generation.'          
  RETURN          
 END           
        
--Now the actual Rollback...        
BEGIN TRAN        
 PRINT 'inserted row INTO Rollbacks table'        

 INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, Rollbacktype, cnt, datSampleCreate_dt, MailingStep_id)        
 SELECT ms.Survey_id, sp.Study_id, getdate(), 'Generation', COUNT(*), ss.datSampleCreate_dt, schm.MailingStep_id        
 FROM #bad_SentMail b(NOLOCK), ScheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK), Survey_def sd(NOLOCK), samplepop sp(NOLOCK), sampleset ss(NOLOCK)
 WHERE b.SentMail_id=schm.SentMail_id        
 AND schm.MailingStep_id=ms.MailingStep_id        
 AND ms.Survey_id=sd.Survey_id        
 AND schm.samplepop_id=sp.samplepop_id        
 and sp.sampleset_id = ss.sampleset_id
 AND sp.samplepop_id=@samplepop_id
 GROUP BY ms.Survey_id, sp.Study_id, ss.datSampleCreate_dt, schm.MailingStep_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'FormGenError'        
 DELETE FormGenError        
  FROM FormGenError fge, ScheduledMailing schm, #bad_SentMail bsm        
  WHERE fge.ScheduledMailing_id=schm.ScheduledMailing_id        
  AND schm.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'pcloutput'        
 DELETE pcloutput        
  FROM pcloutput po, #bad_SentMail bsm        
  WHERE po.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_queue.dbo.pcloutput'        
 DELETE qp_queue.dbo.pcloutput        
  FROM qp_queue.dbo.pcloutput po, #bad_SentMail bsm        
  WHERE po.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'pcloutput2'        
 DELETE pcloutput2        
  FROM pcloutput2 po, #bad_SentMail bsm        
  WHERE po.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'pclneeded'        
 DELETE pclneeded        
  FROM pclneeded pn, #bad_SentMail bsm        
  WHERE pn.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.bubbleloc'        
 DELETE qp_scan.dbo.bubbleloc        
  FROM qp_scan.dbo.bubbleloc bl, #bad_QuestionForm bqf        
  WHERE bl.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.commentloc'        
 DELETE qp_scan.dbo.commentloc        
  FROM qp_scan.dbo.commentloc cl, #bad_QuestionForm bqf        
  WHERE cl.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.bubblepos'        
 DELETE qp_scan.dbo.bubblepos        
  FROM qp_scan.dbo.bubblepos bp, #bad_QuestionForm bqf        
  WHERE bp.QuestionForm_id=bqf.QuestionForm_id       
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.pclQuestionForm'        
 DELETE qp_scan.dbo.pclQuestionForm        
  FROM qp_scan.dbo.pclQuestionForm pqf, #bad_QuestionForm bqf        
  WHERE pqf.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.pclResults'        
 DELETE qp_scan.dbo.pclResults        
  FROM qp_scan.dbo.pclResults pr, #bad_QuestionForm bqf        
  WHERE pr.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.bubbleitempos'        
 DELETE qp_scan.dbo.bubbleitempos        
  FROM qp_scan.dbo.bubbleitempos bip, #bad_QuestionForm bqf        
  WHERE bip.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.commentpos'        
 DELETE qp_scan.dbo.commentpos        
  FROM qp_scan.dbo.commentpos cp, #bad_QuestionForm bqf        
  WHERE cp.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.commentlinepos'        
 DELETE qp_scan.dbo.commentlinepos        
  FROM qp_scan.dbo.commentlinepos clp, #bad_QuestionForm bqf        
  WHERE clp.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.handwrittenpos'        
 DELETE qp_scan.dbo.handwrittenpos        
  FROM qp_scan.dbo.handwrittenpos hrp, #bad_QuestionForm bqf        
  WHERE hrp.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'qp_scan.dbo.handwrittenloc'        
 DELETE qp_scan.dbo.handwrittenloc        
  FROM qp_scan.dbo.handwrittenloc hrl, #bad_QuestionForm bqf        
  WHERE hrl.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
--Skiping this step if no next mailing step        
If @NextMailingStep=0         
   BEGIN         
 GOTO SCHM        
   end        
        
   BEGIN TRAN        
 PRINT 'DELETE next ScheduledMailing'        
 --!!!!!!!!!!!!!!!!!!!!!!!  DELETE NEXT MAILING STEP HERE  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!        
 DELETE ScheduledMailing        
  FROM ScheduledMailing schm        
  WHERE  MailingStep_id=@nextMailingStep AND          
  samplepop_id in (SELECT samplepop_id FROM #bad_SentMail)        
          
  
PRINT 'DELETE next ScheduledMailing with -1 Sentmail_IDs'             
 DELETE ScheduledMailing              
  FROM ScheduledMailing schm inner join samplepop sp           
  ON schm.samplepop_id = sp.samplepop_id WHERE  
  MailingStep_id=@nextMailingStep AND            
  sp.samplepop_id = @samplepop_id AND      
  SP.samplepop_id in (SELECT samplepop_id FROM #bad_SchedMail)   
COMMIT TRAN        
     
SCHM:        
BEGIN TRAN        
 PRINT 'Update current ScheduledMailing'        
 update ScheduledMailing set SentMail_id=null        
  FROM ScheduledMailing schm, #bad_SentMail bsm        
  WHERE schm.SentMail_id=bsm.SentMail_id        
       
     
PRINT 'Update current ScheduledMailing with -1 Sentmail_IDs'              
 update ScheduledMailing set SentMail_id=null              
  FROM ScheduledMailing schm, #bad_SchedMail bsm              
  WHERE schm.ScheduledMailing_ID=bsm.ScheduledMailing_ID     
COMMIT TRAN      
  
BEGIN TRAN        
 PRINT 'pclgenlog'        
 DELETE pclgenlog        
  FROM pclgenlog pcl, #bad_SentMail bsm        
  WHERE pcl.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'QuestionForm'        
 DELETE QuestionForm        
  FROM QuestionForm qf, #bad_SentMail bsm        
  WHERE qf.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'QuestionForm_extract'        
 DELETE QuestionForm_extract        
  FROM QuestionForm_extract qfe, #bad_QuestionForm bqf        
  WHERE qfe.QuestionForm_id=bqf.QuestionForm_id        
COMMIT TRAN        
        
BEGIN TRAN        
 PRINT 'SentMailing'        
 DELETE SentMailing        
  FROM SentMailing sm, #bad_SentMail bsm        
  WHERE sm.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
    
BEGIN TRAN        
 PRINT 'NPSentMailing'        
 DELETE NPSentMailing        
  FROM NPSentMailing sm, #bad_SentMail bsm        
  WHERE sm.SentMail_id=bsm.SentMail_id        
COMMIT TRAN        
  
/********************************************************************************************/          
--MWB 8/24/09          
--If a sampleset was rolled back we want to delete all of the non-mail generation data as well.          
        
if exists ( select 'x'         
   from MAILINGSTEP ms, MAILINGSTEPMETHOD msm        
   where ms.MailingStepMethod_id = msm.MailingStepMethod_id and        
     ms.MAILINGSTEP_ID = @CurrentMailingStep and        
     msm.IsNonMailGeneration = 1        
     )        
BEGIN        
        
    set @VendorFile_ID = 0        
        
 Select distinct vfc.VendorFile_ID          
 into #vendorFileIDs        
 from Samplepop sp, #bad_SentMail bsm, vendorfileCreationQueue vfc          
 where sp.samplepop_ID = bsm.samplepop_ID and          
   vfc.sampleset_ID = sp.sampleset_ID and          
   vfc.MailingStep_Id = @CurrentMailingStep AND  
   sp.samplepop_id = @samplepop_id         
          
  IF (select COUNT(*) from #vendorFileIDs) = 1        
  BEGIN        
   select top 1 @VendorFile_ID = vendorfile_ID from #vendorFileIDs        
  END        
  ELSE        
  BEGIN        
   print 'Mulitple Non Mail Generation VendorFileID values returned'        
   print 'Only the first value was rolled back.'        
   print 'Table has been selected to show other values.'        
   print 'use sp_DBA_RollbackVendorFile to manually rollback these files.'        
   select * from #vendorFileIDs        
  END        
          
  if isnull(@VendorFile_ID, 0) = 0        
  BEGIN        
   print 'Non Mail Generation rolled back but no VendorFile_ID was found to roll back.'        
   print 'Non Mail Generation will need to be manually rolled back from VendorFile tables.'        
  END        
 ELSE        
  BEGIN        
              
   BEGIN TRAN              
     PRINT 'VendorFile_Freqs'              
     DELETE VendorFile_Freqs                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN              
             
   BEGIN TRAN              
     PRINT 'VendorFile_nullCounts'              
     DELETE VendorFile_nullCounts                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN              
             
   BEGIN TRAN              
     PRINT 'VendorPhoneFile_data'              
     DELETE VendorPhoneFile_data                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN              
                 
   BEGIN TRAN              
     PRINT 'VendorWebFile_data'              
     DELETE VendorWebFile_data                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN              
             
  BEGIN TRAN              
     PRINT 'VendorFile_Messages'              
     DELETE VendorFile_Messages                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN              
             
   BEGIN TRAN              
     PRINT 'VendorFileTracking'              
     DELETE VendorFileTracking                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN          
             
   BEGIN TRAN              
     PRINT 'VendorFile_TelematchLog'              
     DELETE VendorFile_TelematchLog                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN             
             
   BEGIN TRAN              
     PRINT 'VendorFileCreationQueue'              
     DELETE VendorFileCreationQueue                
     WHERE vendorFile_ID = @VendorFile_ID               
   COMMIT TRAN             
  END         
END        
          
/********************************************************************************************/              
              
--Droping all temp table        
DROP TABLE #Bad_SentMail        
DROP TABLE #Bad_QuestionForm


