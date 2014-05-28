--** 3/16/09.  - v1.0.1 - Michael Beltz	 
--**Added as debuging to see why some questionforms are not being populated.  
--**Code below logs when the questionform is deleted.

CREATE PROCEDURE dbo.sp_pcl_clean_loc_tables    
AS    
 DECLARE @batch_id INT    
 CHECKPOINT    
 SELECT COUNT(DISTINCT Batch_id) FROM qp_scan.dbo.PCLQuestionForm WHERE bitIsProcessed=1  
 WHILE EXISTS (SELECT batch_id    
   FROM qp_scan.dbo.PCLQuestionForm    
   WHERE bitIsProcessed = 1)    
 BEGIN    
  SELECT @batch_id = MIN(batch_id)    
  FROM qp_scan.dbo.PCLQuestionForm    
  WHERE bitIsProcessed = 1    
  BEGIN TRANSACTION    
  SELECT GETDATE()  

INSERT INTO QuestionForm_DeleteLog (QuestionForm_id, Batch_id, Survey_id, paper_type, language)
SELECT	QuestionForm_id, Batch_id, Survey_id, paper_type, language
FROM	qp_scan.dbo.PCLQuestionForm pclqf  
WHERE	pclqf.bitIsProcessed = 1  
		AND pclqf.batch_id = @batch_id  

/* Now, we will delete the records from the tables that we used. */    
  DELETE qp_scan.dbo.BubbleLoc    
  FROM qp_scan.dbo.PCLQuestionForm pclqf,    
--    qp_scan.dbo.PCLResults pclr,    
   qp_scan.dbo.BubbleLoc bl    
   WHERE pclqf.QuestionForm_id=bl.QuestionForm_id    
--   WHERE pclqf.questionform_id = pclr.questionform_id    
--   AND pclr.questionform_id = bl.questionform_id    
--   AND pclr.selqstns_id = bl.selqstns_id    
--   AND pclr.sampleunit_id = bl.sampleunit_id    
  AND pclqf.bitIsProcessed = 1    
  AND pclqf.batch_id = @batch_id    
  if @@error <> 0    
  begin    
   ROLLBACK TRANSACTION    
   return    
  end    
  DELETE qp_scan.dbo.CommentLoc    
  FROM qp_scan.dbo.PCLQuestionForm pclqf,    
--    qp_scan.dbo.PCLResults pclr,    
   qp_scan.dbo.CommentLoc cl    
  WHERE pclqf.questionform_id=cl.QuestionForm_id    
--   WHERE pclqf.questionform_id = pclr.questionform_id    
--   AND pclr.questionform_id = cl.questionform_id    
--   AND pclr.selqstns_id = cl.selqstns_id    
--   AND pclr.sampleunit_id = cl.sampleunit_id    
  AND pclqf.bitIsProcessed = 1    
  AND pclqf.batch_id = @batch_id    
  if @@error <> 0    
  begin    
   ROLLBACK TRANSACTION    
   return    
  end    
  DELETE qp_scan.dbo.HandWrittenLoc    
  FROM qp_scan.dbo.PCLQuestionForm pclqf,    
--    qp_scan.dbo.PCLResults pclr,    
   qp_scan.dbo.HandWrittenLoc bl    
  WHERE pclqf.questionform_id=bl.questionform_id    
--   WHERE pclqf.questionform_id = pclr.questionform_id    
--   AND pclr.questionform_id = bl.questionform_id    
--   AND pclr.selqstns_id = bl.selqstns_id    
--   AND pclr.sampleunit_id = bl.sampleunit_id    
  AND pclqf.bitIsProcessed = 1    
  AND pclqf.batch_id = @batch_id    
  if @@error <> 0    
  begin    
   ROLLBACK TRANSACTION    
   return    
  end    
  DELETE qp_scan.dbo.PCLResults    
  FROM qp_scan.dbo.PCLQuestionForm pclqf,    
   qp_scan.dbo.PCLResults pclr    
  WHERE pclqf.questionform_id = pclr.questionform_id    
  AND pclqf.bitIsProcessed = 1    
  AND pclqf.batch_id = @batch_id    
  if @@error <> 0    
  begin    
   ROLLBACK TRANSACTION    
   return    
  end    
  DELETE FROM qp_scan.dbo.PCLQuestionForm    
  WHERE bitIsProcessed = 1    
  AND batch_id = @batch_id    
  if @@error <> 0    
  begin    
   ROLLBACK TRANSACTION    
   return    
  end    
  COMMIT TRANSACTION    
  if @@error <> 0    
   return    
  CHECKPOINT    
 end


