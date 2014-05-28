--Stored procedure to adapt the dedup bubblepos.sql script in order to automatically recover from 
--	Violation of UNIQUE KEY constraint 'PX_BUBBLEPOS'. Cannot insert duplicate key in object 'dbo.BUBBLEPOS' errors
--	causing failures in the SQL Agent job [PCLGEN - sp_pcl_batch_populatepos] on nrc10
--
--01/06/2014	DRH		Initial creation

CREATE proc [dbo].[sp_pcl_dedup_bubblepos]
	@batch_id int  
as

--drop table #MyQuestionForm 
 CREATE TABLE #MyQuestionForm (  
  questionform_id int,  
  batch_id int,  
  survey_id int,  
  paper_type int,  
  language int,  
  bitIsProcessed bit  
 )  
  INSERT INTO #MyQuestionForm (  
   questionform_id, batch_id, survey_id,   
   paper_type, language, bitIsProcessed  
  ) SELECT  
   questionform_id, batch_id, survey_id,  
   paper_type, language, bitIsProcessed  
  FROM dbo.PCLQuestionForm  
  WHERE batch_id = @batch_id
  AND bitIsProcessed = 0  

--drop table #x
SELECT DISTINCT  
   pclqf.QuestionForm_id,  
   pclr.SampleUnit_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END intpage_num,
   pclr.QstnCore,  
   pclr.BegColumn,  
   pclr.ReadMethod,  
   pclr.intRespCol  
into #x
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.BubbleLoc bl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = bl.questionform_id  
  AND pclr.selqstns_id = bl.selqstns_id  
  AND pclr.sampleunit_id = bl.sampleunit_id  
  AND pclr.QstnCore > 0  

--drop table #sav
select b.* into #sav 
from bubblepos b, #x x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.qstncore=x.qstncore

/*
select * from #x
select count(*) from bubblepos b, #sav x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.qstncore=x.qstncore
select * from #sav
select count(*) from bubblepos b, #x x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.qstncore=x.qstncore
*/ 
delete b 
from bubblepos b , #sav x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.qstncore=x.qstncore

/**************/
--drop table #x4
SELECT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END intpage_num,  
   pclr.QstnCore,  
   pclqf.Survey_id,  
   bl.Item,  
   pclr.SampleUnit_id,  
   bl.Val,  
   pclr.X + bl.RelX - (CASE WHEN pclr.X + bl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END) x_pos,  
   pclr.Y + bl.RelY  y_pos
into #x4
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.BubbleLoc bl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = bl.questionform_id  
  AND pclr.selqstns_id = bl.selqstns_id  
  AND pclr.sampleunit_id = bl.sampleunit_id  
  AND pclr.QstnCore > 0  


--drop table #sav4
select b.* into #sav4 
from BubbleItemPos b, #x4 x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.qstncore=x.qstncore

/*
select count(*) from bubblepos b, #sav4 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.qstncore=x.qstncore
select count(*) from #sav4
*/ 

delete b 
from BubbleItemPos b , #sav4 x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.qstncore=x.qstncore

/**************/
--drop table #x2
SELECT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END intpage_num,  
   pclr.QstnCore,  
   hl.Item,  
   pclr.SampleUnit_id,  
   pclr.X + hl.RelX - (CASE WHEN pclr.X + hl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END) x_pos,  
   pclr.Y + hl.RelY y_pos,  
   hl.Line_id,  
   hl.intWidth  
into #x2
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.HandwrittenLoc hl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = hl.questionform_id  
  AND pclr.selqstns_id = hl.selqstns_id  
  AND pclr.sampleunit_id = hl.sampleunit_id  
  AND pclr.QstnCore > 0  

--drop table #sav2
select b.* into #sav2 
from handwrittenpos b, #x2 x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.qstncore=x.qstncore

/*
select count(*) from bubblepos b, #sav2 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.qstncore=x.qstncore
select count(*) from #sav2
*/

delete b from handwrittenpos b , #sav2 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.qstncore=x.qstncore

/**************/

--   INSERT INTO dbo.CommentPos (  
--    QuestionForm_id, intPage_num, CmntBox_id, SampleUnit_id,  
--    X_Pos, Y_Pos, intWidth, intHeight  )

--drop table #x3
SELECT DISTINCT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END intpage_num,  
   pclr.QstnCore cmntbox_id,  
   pclr.SampleUnit_id,  
   pclr.X + pclr.BegColumn - (CASE WHEN pclr.X + pclr.BegColumn >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END) x_pos,  
   pclr.Y - 81 y_pos,  
   pclr.Width,  
   pclr.Height  
into #x3
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.CommentLoc cl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = cl.questionform_id  
  AND pclr.selqstns_id = cl.selqstns_id  
  AND pclr.sampleunit_id = cl.sampleunit_id  

--drop table #sav3
select b.* into #sav3 
from commentpos b, #x3 x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.cmntbox_id=x.cmntbox_id

/*
select count(*) from commentpos b, #sav3 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.cmntbox_id=x.cmntbox_id
select count(*) from #sav3
*/

delete b from commentpos b , #sav3 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.intpage_num=x.intpage_num and b.cmntbox_id=x.cmntbox_id

/*******************/
--  INSERT INTO dbo.CommentLinePos (  
--drop table #x5
SELECT  
   pclr.QuestionForm_id,  
   CASE WHEN pclqf.paper_type = 5 THEN pclr.PageNum ELSE pclr.Side END Cmntbox_id,  
   pclr.QstnCore,  
   cl.Line,  
   pclr.SampleUnit_id,  
   pclr.X + cl.RelX - (CASE WHEN pclr.X + cl.RelX >= 5100 AND pclqf.paper_type = 5 THEN 5100 ELSE 0 END) x,  
   pclr.Y + cl.RelY y,  
   cl.Width,  
   cl.Height  
into #x5
  FROM #MyQuestionForm pclqf,  
   dbo.PCLResults pclr,  
   dbo.CommentLoc cl  
  WHERE pclqf.questionform_id = pclr.questionform_id  
  AND pclr.questionform_id = cl.questionform_id  
  AND pclr.selqstns_id = cl.selqstns_id  
  AND pclr.sampleunit_id = cl.sampleunit_id  

--drop table #sav5
select b.* into #sav5 
from commentlinepos b, #x5 x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.cmntbox_id=x.cmntbox_id

/*
select @@Trancount
begin tran
insert into commentlinepos 
select * from #x5 x where not exists (select * from commentlinepos b where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.cmntbox_id=x.cmntbox_id)
commit tran

select count(*) from commentlinepos b, #x5 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.cmntbox_id=x.cmntbox_id
select count(*) from commentlinepos b, #sav5 x where b.questionform_id=x.questionform_id and b.sampleunit_Id=x.sampleunit_id and b.cmntbox_id=x.cmntbox_id
select count(*) from #sav5
*/ 

delete b 
from commentlinepos b , #sav5 x 
where b.questionform_id=x.questionform_id 
and b.sampleunit_Id=x.sampleunit_id 
and b.intpage_num=x.intpage_num 
and b.cmntbox_id=x.cmntbox_id


