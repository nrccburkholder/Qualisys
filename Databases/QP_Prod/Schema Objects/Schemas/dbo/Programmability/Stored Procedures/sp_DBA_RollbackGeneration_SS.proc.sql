CREATE PROCEDURE sp_DBA_RollbackGeneration_SS @Survey_id INT, @CurrentMailingStep INT=NULL, @intSequence INT=NULL,  @datGenerated DATETIME=NULL  
AS  
/*  
This procedure has been created to act with an interface. It's is to display all the generations AND the user will then specify   
the generation by Survey, mailing step AND date generated.  
*/  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
-- Declare variable section  
DECLARE @NextMailingStep INT  
    SET @NextMailingStep=0  
IF @intSequence IS NULL   
   BEGIN   
 SET @intSequence=0  
   END  
  
IF @CurrentMailingStep IS NULL OR @datGenerated IS NULL  
 BEGIN  
 --Getting all generated steps.  
 SELECT ms.MailingStep_id, intSequence, strMailingStep_nm, CONVERT(VARCHAR(10),datGenerated,120) AS datgened,   
 CONVERT(VARCHAR(10),datMailed,120) AS datMailed, COUNT(*)   
 FROM SentMailing sm (NOLOCK), ScheduledMailing schm (NOLOCK), MailingStep ms (NOLOCK), MailingMethodology mm  
 WHERE sm.ScheduledMailing_id=schm.ScheduledMailing_id  
 AND schm.MailingStep_id=ms.MailingStep_id  
 AND sm.Methodology_id=mm.Methodology_id  
 AND mm.Survey_id=@Survey_id  
 AND mm.bitActiveMethodology=0
 GROUP BY ms.MailingStep_id, intSequence, strMailingStep_nm, CONVERT(VARCHAR(10),datGenerated,120), CONVERT(VARCHAR(10),datMailed,120)  
 ORDER BY strMailingStep_nm, CONVERT(VARCHAR(10),datGenerated,120)  
  
 RETURN  
 END   
  
PRINT @intSequence  
  
--Getting the next mailing step  
SELECT @NextMailingStep=ms.MailingStep_id  
FROM MailingMethodology mm (NOLOCK), MailingStep ms (NOLOCK)  
WHERE mm.Survey_id=@Survey_id  
AND   ms.intSequence=(@intSequence+1)  
AND   mm.Methodology_id =ms.Methodology_id  
AND   mm.bitActiveMethodology=0
  
--Creating the Temp tables for the Rollbacks  
SELECT schm.samplepop_id, sm.SentMail_id  
INTO #bad_SentMail   
FROM SentMailing sm, ScheduledMailing schm  
WHERE sm.SentMail_id=schm.SentMail_id  
AND sm.datMailed IS NULL  
AND CONVERT(VARCHAR(10),datGenerated,120)=@datGenerated   
AND schm.MailingStep_id=@CurrentMailingStep  
  
SELECT QuestionForm_id   
INTO #bad_QuestionForm   
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
  
--Now the actual Rollback...  
BEGIN TRAN  
 PRINT 'inserted row INTO Rollbacks table'  
 INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, Rollbacktype, cnt, datSampleCreate_dt, MailingStep_id)  
 SELECT ms.Survey_id, sp.Study_id, getdate(), 'Generation', COUNT(*), datSampleCreate_dt, schm.MailingStep_id  
 FROM #bad_SentMail b(NOLOCK), ScheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK), Survey_def sd(NOLOCK), samplepop sp(NOLOCK), sampleset ss(NOLOCK)  
 WHERE b.SentMail_id=schm.SentMail_id  
 AND schm.MailingStep_id=ms.MailingStep_id  
 AND ms.Survey_id=sd.Survey_id  
 AND schm.samplepop_id=sp.samplepop_id  
 AND sp.sampleset_id=ss.sampleset_id  
 GROUP BY ms.Survey_id, sp.Study_id, datSampleCreate_dt, schm.MailingStep_id  
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
   COMMIT TRAN  
    
SCHM:  
BEGIN TRAN  
 PRINT 'Update current ScheduledMailing'  
 update ScheduledMailing set SentMail_id=null  
  FROM ScheduledMailing schm, #bad_SentMail bsm  
  WHERE schm.SentMail_id=bsm.SentMail_id  
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
  
--Droping all temp table  
DROP TABLE #Bad_SentMail  
DROP TABLE #Bad_QuestionForm


