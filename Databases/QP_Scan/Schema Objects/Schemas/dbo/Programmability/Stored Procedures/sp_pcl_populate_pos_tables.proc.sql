if object_id('qp_scan.dbo.sp_pcl_populate_pos_tables','p') is not null 
	drop procedure dbo.sp_pcl_populate_pos_tables
/*
/* This stored procedure will populate the bubblepos, bublbleitempos, commentpos, and  
** commentlinepos tables.  This is because we can populate these tables quickly in  
** SQL vs. having Delphi (PCLGen) pass all the information via insert statements.  
** This procedure will be called by an automated agent that will watch a batch table  
** for work to do.  This will do all the work in one transaction because of the potential  
** conflicts.  
** Created: Daniel Vansteenburg, Cap Gemini America, LLC  
** Date:  5/20/1999  
** Notes:  Paper_type = 5 is so that we can do special stuff with double-legal paper  
** CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END  
**  Gives us the right Page Numbering scheme based on the paper type.  
** CASE WHEN pclr.X + bl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END &  
** CASE WHEN pclr.X + pclr.BegColumn >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END &  
** CASE WHEN pclr.X + cl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END  
**  For Double-Legal, they are perforated so they can be torn apart and scanned  
**  one side per scan-pass, Unlike Tabloids that can be scanned whole.  So, we need  
**  to fix the X position by subtracting 5100 pixels if it is the other page and it is  
**  double-legal.  
** Modifications:  
** 7/12/1999 - Daniel Vansteenburg, CGA - Once this procedure is complete, we will delete  
**                                        the records that we used from the LOC tables.  
** 7/23/1999 - Daniel Vansteenburg, CGA - Added call to delay our process, and exit nicely,   
**                                        if the PCLGen is paused.  
** 7/27/1999 - Daniel Vansteenburg, CGA - Moved the deletion to a scheduled task, will update  
**                                        PCLQuestionForm's bitIsProcessed to a 1 to  
**                                        indicate that it was successfully processed.  Those  
**                                        will then be the records we will trim out.  
** 7/28/1999 - Daniel Vansteenburg, CGA - Created a loop that will allow us to process this  
**                                        procedure in batch size chunks using temp tables.  
** 7/28/1999 - Daniel Vansteenburg, CGA - Setup QualPro params with its own set of start and  
**                                        stop dates & times.  
** 8/02/1999 - Daniel Vansteenburg, CGA - Modified to run as a single batch, instead of one for  
**                                        each completed PCLGen batch.  Removed the DELETE for  
**                                        the LOC tables, this is in a different batch now.  
** 2/17/2000 - v2.0.1 - Dave Gilsdorf - Removed CAHPS-specific insert command  
** 2/04/2004 - v2.0.2 - Dave Gilsdorf - Added INSERT INTO HandwrittenPos  
** 3/16/2009 - v2.0.3 - Michael Beltz	 Added as debuging to see why some questionforms are not being populated.  

*/  
CREATE procedure dbo.sp_pcl_populate_pos_tables  
 @batch_id int  
as  
 declare @name varchar(255), @batch_size int, @err int  
/* WE DO NOT HAVE QUALPRO_PARAMS IN THE QP_SCAN DATABASE  
 select @batch_size = numParam_value  
 from dbo.qualpro_params  
 where strParam_nm = 'PCLGenPosBatch' and strParam_grp = 'PCLGen'  
 select @batch_size = isnull(@batch_size,20)  
*/  
 select @batch_size = 10  
/* 7/27/99 DV - Now, we will break the transaction loop into smaller batches */  
 CREATE TABLE #MyQuestionForm (  
  questionform_id int,  
  batch_id int,  
  survey_id int,  
  paper_type int,  
  language int,  
  bitIsProcessed bit  
 )  
 WHILE EXISTS (SELECT questionform_id  
   FROM dbo.PCLQuestionForm  
   WHERE batch_id = @batch_id  
   AND bitIsProcessed = 0)  
 BEGIN 

--mb 3/16/09.  Added as debuging to see why some questionforms are not being populated.  
  INSERT INTO QuestionForm_PopulateLog (questionform_id, batch_id, survey_id, paper_type, language)
  SELECT questionform_id, batch_id, survey_id, paper_type, language  
  FROM dbo.PCLQuestionForm  q1
  WHERE batch_id = @batch_id  
  AND bitIsProcessed = 0  
  AND not exists (	SELECT	'x' 
					FROM	QuestionForm_PopulateLog q2
					WHERE	q1.questionform_id = q2.questionform_id and
							q1.batch_id = q2.batch_id and
							q1.survey_id = q2.survey_id and
							q1.paper_type = q2.paper_type and
							q1.language = q2.language
				 )

 
  DELETE FROM #MyQuestionForm  
  select @err = @@error  
  if @err <> 0  
  begin  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
  SET ROWCOUNT @batch_size  
  INSERT INTO #MyQuestionForm (  
   questionform_id, batch_id, survey_id,   
   paper_type, language, bitIsProcessed  
  ) SELECT  
   questionform_id, batch_id, survey_id,  
   paper_type, language, bitIsProcessed  
  FROM dbo.PCLQuestionForm  
  WHERE batch_id = @batch_id  
  AND bitIsProcessed = 0  
  select @err = @@error  
  if @err <> 0  
  begin  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
  SET ROWCOUNT 0  
/* We can run, let's populate the Position Tables */  
  BEGIN TRANSACTION  
  INSERT INTO dbo.BubblePos (  
   QuestionForm_id, SampleUnit_id, intPage_num,  
   QstnCore, intBegColumn, ReadMethod_id, intRespCol  
  ) SELECT DISTINCT  
   pclqf.QuestionForm_id,  
   pclr.SampleUnit_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END,  
   pclr.QstnCore,  
   pclr.BegColumn,  
   pclr.ReadMethod,  
   pclr.intRespCol  
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.BubbleLoc bl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = bl.questionform_id  
  AND pclr.selqstns_id = bl.selqstns_id  
  AND pclr.sampleunit_id = bl.sampleunit_id  
  AND pclr.QstnCore > 0  
  select @err = @@error  
  if @err <> 0  
  begin  
   ROLLBACK TRANSACTION   
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
  INSERT INTO dbo.BubbleItemPos (  
   QuestionForm_id, intPage_num, Qstncore, Survey_id,  
   Item, SampleUnit_id, Val, X_Pos, Y_Pos  
  ) SELECT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END,  
   pclr.QstnCore,  
   pclqf.Survey_id,  
   bl.Item,  
   pclr.SampleUnit_id,  
   bl.Val,  
   pclr.X + bl.RelX - (CASE WHEN pclr.X + bl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END),  
   pclr.Y + bl.RelY  
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.BubbleLoc bl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = bl.questionform_id  
  AND pclr.selqstns_id = bl.selqstns_id  
  AND pclr.sampleunit_id = bl.sampleunit_id  
  AND pclr.QstnCore > 0  
  select @err = @@error  
  if @err <> 0  
  begin  
   ROLLBACK TRANSACTION  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
  INSERT INTO dbo.HandwrittenPos (  
   QuestionForm_id, intPage_num, Qstncore,   
   Item, SampleUnit_id, X_Pos, Y_Pos, Line_id, intWidth  
  ) SELECT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END,  
   pclr.QstnCore,  
   hl.Item,  
   pclr.SampleUnit_id,  
   pclr.X + hl.RelX - (CASE WHEN pclr.X + hl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END),  
   pclr.Y + hl.RelY,  
   hl.Line_id,  
   hl.intWidth  
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.HandwrittenLoc hl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = hl.questionform_id  
  AND pclr.selqstns_id = hl.selqstns_id  
  AND pclr.sampleunit_id = hl.sampleunit_id  
  AND pclr.QstnCore > 0  
  select @err = @@error  
  if @err <> 0  
  begin  
   ROLLBACK TRANSACTION  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
  INSERT INTO dbo.CommentPos (  
   QuestionForm_id, intPage_num, CmntBox_id, SampleUnit_id,  
   X_Pos, Y_Pos, intWidth, intHeight  
  ) SELECT DISTINCT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END,  
   pclr.QstnCore,  
   pclr.SampleUnit_id,  
   pclr.X + pclr.BegColumn - (CASE WHEN pclr.X + pclr.BegColumn >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END),  
   pclr.Y - 81,  
   pclr.Width,  
   pclr.Height  
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.CommentLoc cl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = cl.questionform_id  
  AND pclr.selqstns_id = cl.selqstns_id  
  AND pclr.sampleunit_id = cl.sampleunit_id  
  select @err = @@error  
  if @err <> 0  
  begin  
   ROLLBACK TRANSACTION  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
  INSERT INTO dbo.CommentLinePos (  
   QuestionForm_id, intPage_num, CmntBox_id, intLine_num,  
   SampleUnit_id, X_Pos, Y_Pos, intWidth, intHeight  
  ) SELECT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END,  
   pclr.QstnCore,  
   cl.Line,  
   pclr.SampleUnit_id,  
   pclr.X + cl.RelX - (CASE WHEN pclr.X + cl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END),  
   pclr.Y + cl.RelY,  
   cl.Width,  
   cl.Height  
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.CommentLoc cl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = cl.questionform_id  
  AND pclr.selqstns_id = cl.selqstns_id  
  AND pclr.sampleunit_id = cl.sampleunit_id  
  select @err = @@error  
  if @err <> 0  
  begin  
   ROLLBACK TRANSACTION  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
/* 7/27/99 DV - Once we've processed the stuff into the POS tables */  
/*              we will flag PCLQuestionForm by making the batch_id a */  
/*              negative number */  
  UPDATE dbo.PCLQuestionForm  
  SET bitIsProcessed = 1  
  FROM dbo.PCLQuestionForm pclqf,  
   #MyQuestionForm mqf  
  WHERE pclqf.batch_id = mqf.batch_id  
  AND pclqf.questionform_id = mqf.questionform_id  
  AND pclqf.survey_id = mqf.survey_id  
  AND pclqf.paper_type = mqf.paper_type  
  AND pclqf.language = mqf.language  
  select @err = @@error  
  if @err <> 0  
  begin  
   ROLLBACK TRANSACTION  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
/* Now, commit all the changes as one atomic operation */  
  COMMIT TRANSACTION  
  select @err = @@error  
  if @err <> 0  
  begin  
   DROP TABLE #MyQuestionForm  
   return @err  
  end  
 end  
/* I was successful, delete the job that ran me */  
 DROP TABLE #MyQuestionForm  
 return 0
*/