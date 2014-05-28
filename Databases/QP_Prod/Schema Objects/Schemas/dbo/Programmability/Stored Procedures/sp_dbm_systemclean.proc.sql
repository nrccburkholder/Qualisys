/* This stored procedure will delete records from the following tables once their mailing date              
** is eight weeks old.  These records are all related to the generation of a questionnaire              
** and required scanning information.  This means all returned questionnaires that had mailing              
** date more than eight weeks old will no be scanned, nor reprintable, and therefore will not              
** be reported.  The tables are...              
** Bubblepos, BubbleItemPos, PCLOutput, CommentLinePos, CommentPos              
**               
** Created by: Daniel Vansteenburg, 9/17/1999              
** Modified by:  Brian Dohmen, 4/27/00 to move entries to qp_scanner database prior to deleting and then dumping the qp_scanner database to disk              
** Modified by:  Michael Beltz 3/26/08 - Changed logic that inserts into #sm_All to use the DatExpire from the sentmailing table            
           rather than using the parameter from the QualPro_Params table.            
           This gives the flexiblity to extend survey's beyond 84 days at the Sentmail level             
           (as apposed to a global level)         
** Modified by:  Michael Beltz 11/19/08 - Added new Data load fields to the delete list.        
   These tables are used to hold temporary loaded data before they are submitted to Qualisys.        
   after the litho expires the specific responses are removed.  We keep the DL_Lithos table b/c        
   it is used to control rollbacks, which can occur at any time (even after the litho expires)        
** Modified by:  Michael Beltz 2/15/2010 - Removed manual backup to QP_Scanner backup device b/c  
   we now do this as part of the maintenance plan.  
*/              
CREATE PROCEDURE [dbo].[sp_dbm_systemclean]              
AS              
            
 DECLARE @batchsize INT              
 DECLARE @pcloexpiredays INT              
              
/* Get the expiration days from QualPro params.  Since we are expiring, we are going into              
** the past, the numparam_value is a positive number, do we need to turn it into a negative.              
*/              
            
              
/* Get the PCLOutput expiration days from QualPro params.  Since we are expiring, we are going into              
** the past, the numparam_value is a positive number, do we need to turn it into a negative.              
*/              
 SELECT @pcloexpiredays = numparam_value * -1              
 FROM dbo.qualpro_params              
 WHERE strparam_nm = 'PCLODaysToExpire'              
 AND strparam_grp = 'DBManager'              
            
/* Get the batch size */              
 SELECT @batchsize = numparam_value              
 FROM dbo.qualpro_params              
 WHERE strparam_nm = 'DBManagerBatch'              
 AND strparam_grp = 'DBManager'              
              
 print 'Truncate QP_Scanner tables'        
 TRUNCATE TABLE qp_scanner.dbo.bubbleitempos              
 TRUNCATE TABLE qp_scanner.dbo.commentlinepos              
 TRUNCATE TABLE qp_scanner.dbo.commentpos              
 TRUNCATE TABLE qp_scanner.dbo.bubblepos              
 TRUNCATE TABLE qp_scanner.dbo.pcloutput              
 TRUNCATE TABLE qp_scanner.dbo.HandWrittenPos              
              
/* Determine the sentmailings to be cleaned out.               
** We will do transactional batches of @batchsize records for each deleted, and              
** delete the records by sentmail or questionform.              
*/              
 CREATE TABLE #sentmailing (              
  sentmail_id INT,              
  questionform_id INT,        
  strLithoCode varchar(10)        
 )              
 CREATE TABLE #sm_All (              
  sentmail_id INT,              
  questionform_id INT,        
  strLithoCode varchar(10)              
 )              
    
 CREATE TABLE #DL_AllLithoCodeIDs (    
  DL_LithoCode_ID int    
 )    
    
 CREATE INDEX idx_sentmail ON #sentmailing (sentmail_id)              
 CREATE INDEX idx_qstnfrm ON #sentmailing (questionform_id)        
              
/* Get the sentmailing and questionform ids of the items we are going to delete.  Once              
** we get them, we will delete the records that match the criteria.  Since, not all mailing              
** items are associated with a QuestionForm, we need to LEFT OUTER JOIN in Questionform              
** to make sure we get the right information.              
*/              
            
            
/*            
            
OLD way of doing things before we switched to using the datExpire column in the SentMailing table            
            
 DECLARE @expiredays INT              
            
 SELECT @expiredays = numparam_value * -1              
 FROM dbo.qualpro_params              
 WHERE strparam_nm = 'DaysToExpire'              
 AND strparam_grp = 'DBManager'              
            
            
    INSERT INTO #sm_All (SentMail_id, QuestionForm_id)              
  SELECT DISTINCT sm.sentmail_id, qf.questionform_id              
 FROM dbo.sentmailing sm LEFT OUTER JOIN dbo.questionform qf              
  ON sm.sentmail_id = qf.sentmail_id              
 WHERE sm.datmailed <= dateadd(dd,@expiredays,getdate())              
 AND sm.datdeleted IS NULL              
*/            
            
 print 'Get All Records'        
 INSERT INTO #sm_All (SentMail_id, QuestionForm_id, strLithoCode)            
 SELECT DISTINCT sm.sentmail_id, qf.questionform_id, strLithoCode            
 FROM dbo.sentmailing sm LEFT OUTER JOIN dbo.questionform qf              
  ON sm.sentmail_id = qf.sentmail_id              
 WHERE getdate() >= sm.datexpire              
 AND sm.datdeleted IS NULL  and sm.datexpire is not null            
         
            
 SET ROWCOUNT @batchsize              
 INSERT INTO #sentmailing (sentmail_id, questionform_id, strlithocode)              
 SELECT sentmail_id, questionform_id, strlithocode              
 FROM #sm_All              
              
 WHILE @@ROWCOUNT > 0              
 BEGIN              
  SET ROWCOUNT 0              
  BEGIN TRANSACTION              
              
   DELETE a              
   FROM #SentMailing t, #sm_All a              
   WHERE a.SentMail_id=t.SentMail_id              
              
   print 'Insert into qp_scanner.dbo.bubbleitempos from qp_scan.dbo.bubbleitempos'        
   Insert into qp_scanner.dbo.bubbleitempos              
   select qp_scan.dbo.bubbleitempos.* from qp_scan.dbo.bubbleitempos, #sentmailing               
   where qp_scan.dbo.BubbleItemPos.questionform_id = #sentmailing.questionform_id              
              
   print 'Delete qp_scan.dbo.BubbleItemPos'        
   DELETE qp_scan.dbo.BubbleItemPos              
   FROM #sentmailing              
   WHERE qp_scan.dbo.BubbleItemPos.questionform_id = #sentmailing.questionform_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
   print 'Insert into qp_scanner.dbo.commentlinepos from qp_scan.dbo.commentlinepos'        
   Insert into qp_scanner.dbo.commentlinepos              
   select qp_scan.dbo.commentlinepos.* from qp_scan.dbo.commentlinepos, #sentmailing               
   where qp_scan.dbo.CommentLinePos.questionform_id = #sentmailing.questionform_id              
              
   print 'Delete from qp_scan.dbo.CommentLinePos'        
   DELETE qp_scan.dbo.CommentLinePos              
   FROM #sentmailing              
   WHERE qp_scan.dbo.CommentLinePos.questionform_id = #sentmailing.questionform_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
   print 'Insert into qp_scanner.dbo.commentpos from qp_scan.dbo.commentpos'        
   Insert into qp_scanner.dbo.commentpos              
   select qp_scan.dbo.commentpos.* from qp_scan.dbo.commentpos, #sentmailing               
   where qp_scan.dbo.CommentPos.questionform_id = #sentmailing.questionform_id              
              
   print 'Delete from qp_scan.dbo.CommentPos'        
   DELETE qp_scan.dbo.CommentPos              
   FROM #sentmailing              
   WHERE qp_scan.dbo.CommentPos.questionform_id = #sentmailing.questionform_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
   print 'Insert into qp_scanner.dbo.bubblepos from qp_scan.dbo.bubblepos'        
   Insert into qp_scanner.dbo.bubblepos              
   select qp_scan.dbo.bubblepos.* from qp_scan.dbo.bubblepos, #sentmailing               
   where qp_scan.dbo.BubblePos.questionform_id = #sentmailing.questionform_id              
              
   print 'Delete from qp_scan.dbo.BubblePos'        
   DELETE qp_scan.dbo.BubblePos              
   FROM #sentmailing              
   WHERE qp_scan.dbo.BubblePos.questionform_id = #sentmailing.questionform_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
   print 'Insert into QP_Scanner.dbo.HandWrittenPos from QP_Scan.dbo.HandWrittenPos'        
   INSERT INTO QP_Scanner.dbo.HandWrittenPos (QuestionForm_id,intPage_num,QstnCore,              
     Item,SampleUnit_id,Line_id,X_Pos,Y_Pos,intWidth)              
   SELECT QP_Scan.dbo.HandWrittenPos.QuestionForm_id,intPage_num,QstnCore,              
     Item,SampleUnit_id,Line_id,X_Pos,Y_Pos,intWidth              
   FROM QP_Scan.dbo.HandWrittenPos, #sentmailing               
   WHERE QP_Scan.dbo.HandWrittenPos.questionform_id = #sentmailing.questionform_id              
              
   print 'Delete from qp_scan.dbo.HandWrittenPos'        
   DELETE qp_scan.dbo.HandWrittenPos              
   FROM #sentmailing              
   WHERE qp_scan.dbo.HandWrittenPos.questionform_id = #sentmailing.questionform_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
/*                 
   Insert into qp_scanner.dbo.pcloutput              
   select dbo.pcloutput.* from dbo.pcloutput, #sentmailing               
   where dbo.PCLOutput.sentmail_id = #sentmailing.sentmail_id              
*/              
   print 'Delete qp_prod.dbo.PCLOutput'        
   DELETE qp_prod.dbo.PCLOutput              
   FROM #sentmailing              
   WHERE qp_prod.dbo.PCLOutput.sentmail_id = #sentmailing.sentmail_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
--Added to delete records from the QP_Queue database            
   print 'Delete qp_queue.dbo.PCLOutput'           
   DELETE qp_queue.dbo.PCLOutput              
   FROM #sentmailing              
   WHERE qp_queue.dbo.PCLOutput.sentmail_id = #sentmailing.sentmail_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
              
   print 'update sentmailing.datdeleted'        
   UPDATE dbo.sentmailing              
   SET datdeleted = getdate()              
   FROM #sentmailing              
   WHERE dbo.sentmailing.sentmail_id = #sentmailing.sentmail_id              
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #sentmailing              
    return              
   end              
  COMMIT TRANSACTION              
              
    
--11/19/08 mb.        
--adding the deletes from all new Data load tables.        
--once the litho is expired returns cannot be accepted and any loaded data will be removed.            
    
Truncate table #DL_AllLithoCodeIDs    
    
print 'Get Data load lithos to delete'        
Insert into #DL_AllLithoCodeIDs (DL_LithoCode_ID)    
Select lc.DL_LithoCode_ID         
from DL_LithoCodes lc, #sentmailing sm        
where lc.strlithocode = sm.strlithocode      
      
        
print 'Delete DL_Comments'        
Delete c        
from DL_Comments C, #DL_AllLithoCodeIDs A        
where C.DL_LithoCode_ID = A.DL_LithoCode_ID        
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #DL_AllLithoCodeIDs              
    return              
   end              
        
print 'Delete DL_Dispositions'        
Delete D        
from DL_Dispositions D, #DL_AllLithoCodeIDs A        
where D.DL_LithoCode_ID = A.DL_LithoCode_ID        
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #DL_AllLithoCodeIDs              
    return              
   end              
        
print 'Delete DL_HandEntry'        
Delete H        
from DL_HandEntry H, #DL_AllLithoCodeIDs A        
where H.DL_LithoCode_ID = A.DL_LithoCode_ID        
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #DL_AllLithoCodeIDs              
    return              
   end         
        
print 'Delete DL_QuestionResults'        
Delete Q        
from DL_QuestionResults Q, #DL_AllLithoCodeIDs A        
where Q.DL_LithoCode_ID = A.DL_LithoCode_ID        
   if @@error <> 0              
   begin              
    ROLLBACK TRANSACTION              
    DROP TABLE #DL_AllLithoCodeIDs              
    return              
   end         
        
/** END 11/19/08 new delete tables ***********/        
        
  TRUNCATE TABLE #sentmailing              
  if @@error <> 0              
  begin              
   DROP TABLE #sentmailing              
   return              
  end              
  SET ROWCOUNT @batchsize              
  INSERT INTO #sentmailing (sentmail_id, questionform_id)              
  SELECT sentmail_id, questionform_id              
  FROM #sm_All         END              
 SET ROWCOUNT 0              
 DROP TABLE #sentmailing              
              
/* Next, we will trim up PCLOutput by removing the Image data by setting the              
** image field to NULL.  We will do this as one batch, since it won't be too large.              
*/              
/*              
 Insert into qp_scanner.dbo.pcloutput              
 select dbo.pcloutput.*               
 from dbo.pcloutput, dbo.sentmailing              
 WHERE dbo.PCLOutput.sentmail_id = dbo.sentmailing.sentmail_id              
 AND dbo.sentmailing.datmailed <= dateadd(dd,@pcloexpiredays,getdate())              
 AND dbo.sentmailing.datdeleted IS NULL              
*/              
 DELETE dbo.PCLOutput              
 FROM dbo.sentmailing              
 WHERE dbo.PCLOutput.sentmail_id = dbo.sentmailing.sentmail_id              
 AND dbo.sentmailing.datmailed <= dateadd(dd,@pcloexpiredays,getdate())              
 AND dbo.sentmailing.datdeleted IS NULL              
              
 DELETE qp_queue.dbo.PCLOutput              
 FROM dbo.sentmailing              
 WHERE qp_queue.dbo.PCLOutput.sentmail_id = dbo.sentmailing.sentmail_id              
 AND dbo.sentmailing.datmailed <= dateadd(dd,@pcloexpiredays,getdate())              
 AND dbo.sentmailing.datdeleted IS NULL              
              
select pclgenrun_id              
into #p              
from pclgenrun              
where start_dt < dateadd(day,@pcloexpiredays,getdate())              
              
delete pgl              
from pclgenlog pgl, #p p              
where p.pclgenrun_id = pgl.pclgenrun_id              
              
delete pgr              
from pclgenrun pgr, #p p              
where p.pclgenrun_id = pgr.pclgenrun_id              
              
drop table #p              
              
--BACKUP DATABASE [QP_Scanner] TO [QP_Scanner] WITH  INIT ,  NOUNLOAD ,  NAME = N'QP_Scanner backup',  SKIP ,  STATS = 10,  NOFORMAT              
--commented out MWB 2/15/10.  
--With new SQL 2008 backup plan we backup this database to \\Helios\BUTD along with all other DBs.    
              
/* This backup is written to NRC10\d\sql7\backkup\qp_scanner.bak              
*/


