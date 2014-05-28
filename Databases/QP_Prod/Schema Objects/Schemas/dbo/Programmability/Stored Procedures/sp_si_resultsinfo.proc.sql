/***********************************************************************************************************************************
SP Name: sp_si_resultsinfo 
Part of:  Scanner Interface - Import (2nd pass)
Purpose:  
Input:  
 
Output:  
Creation Date: ?/?/1999
Author(s): Cap Gemini 
Revision: 
v2.0.1 - 2/8/2000 - Dave Gilsdorf
  Added WHEN '0-1' to case statement on INSERT INTO dbo.QuestionResult - compensation for bug
  in Scanner Interface - Export (1st pass) that defined a missing value for a 3 digit question 
  response as '0-1' instead of '-01'.  This could be discarded after .str files are 
  reprocessed and the SI-Export bug is fixed.
v2.0.2 - 2/9/2000 - Don Stavneak
  Added @@error statements for error trapping.
v2.0.3 - 3/17/2000 - Dave Gilsdorf
  bug addressed in v2.0.1 is also affecting 4 digit question responses.  reponses of '00-1' are
  being seen.
***********************************************************************************************************************************/
CREATE procedure sp_si_resultsinfo
as
 declare @begin_count int
 declare @end_count int

 create table #resultsinfo (
  strLithoCode varchar(10),
  questionform_id int,
  samplepop_id int,
  qstncore int,
  sampleunit_id int,
  survey_id int,
  intbegcolumn int,
  intpage_num int,
  bitmultiresp bit
 )
 create table #bubblecounter (
  counter int
 )

/* Populate the bubblecounter so we can do the multiresponse questions easily */
 insert into #bubblecounter (counter) values (1)
 insert into #bubblecounter (counter) values (2)
 insert into #bubblecounter (counter) values (3)
 insert into #bubblecounter (counter) values (4)
 insert into #bubblecounter (counter) values (5)
 insert into #bubblecounter (counter) values (6)
 insert into #bubblecounter (counter) values (7)
 insert into #bubblecounter (counter) values (8)
 insert into #bubblecounter (counter) values (9)

/* Results Info */
 insert into #resultsinfo (
  strLithoCode, questionform_id, samplepop_id, qstncore,
  sampleunit_id, survey_id, intbegcolumn, intpage_num,
  bitmultiresp
 ) select
  t.strLithoCode,
  qf.questionform_id,
  qf.samplepop_id,
  bp.qstncore,
  bp.sampleunit_id,
  qf.survey_id,
  bp.intbegcolumn,
  bp.intpage_num,
  rm.bitmultiresp
 from #upreturns t,
  dbo.sentmailing sm,
  dbo.questionform qf,
  dbo.bubblepos bp,
  dbo.readmethod rm
 where sm.strlithocode = t.strlithocode
 and sm.sentmail_id = qf.sentmail_id
 and qf.questionform_id = bp.questionform_id
 and bp.readmethod_id = rm.readmethod_id
 and t.sentmail_id is not null
 and t.questionform_id is not null

if @@error <> 0
   insert into scanimporterror (STRLITHOCODE, DATERRORDATE)
   select strlithocode, getdate() from #upreturns

 create index idx_strLithoCode on #resultsinfo (strLithoCode)
 create index idx_qfsuqc on #resultsinfo (questionform_id, sampleunit_id, qstncore)

/* Single Response Questions */
 INSERT INTO dbo.QuestionResult (
  QuestionForm_Id, sampleUnit_Id, QstnCore, intResponseVal 
 ) select
  ri.questionform_id, ri.sampleunit_id, ri.qstncore, 
  case rtrim(substring(t.txtResponse1 + t.txtResponse2 + t.txtResponse3 + t.txtResponse4,ri.intbegcolumn,bp.intrespcol))
   when '' then -9
   when '*' then -8
   when '0-1' then -1
   when '00-1' then -1
   else convert(int,substring(t.txtResponse1 + t.txtResponse2 + t.txtResponse3 + t.txtResponse4,ri.intbegcolumn,bp.intrespcol))
  end
 from #resultsinfo ri, #upreturns t, dbo.bubblepos bp
 where bp.questionform_id = ri.questionform_id
 and bp.sampleunit_id = ri.sampleunit_id
 and bp.qstncore = ri.qstncore
 and ri.strLithoCode = t.strLithoCode
 and ri.bitmultiresp = 0

if @@error <> 0
   insert into scanimporterror (STRLITHOCODE, DATERRORDATE)
   select strlithocode, getdate() from #upreturns

/* Multi-Response Questions */
 INSERT INTO dbo.QuestionResult (
  QuestionForm_id, sampleUnit_Id, Qstncore, intResponseVal
 ) select
   ri.questionform_id, ri.sampleunit_id, ri.qstncore,
  case when substring(substring(t.txtResponse1 + t.txtResponse2 + t.txtResponse3 + t.txtResponse4,ri.intbegcolumn,sq.numBubbleCount), bcntr.counter, 1) = '1' then bip.val
  else 0
  end
 from #resultsinfo ri, #upreturns t, #bubblecounter bcntr,
  dbo.sel_qstns sq, dbo.bubbleitempos bip
 where ri.strLithoCode = t.strLithoCode
 and ri.qstncore = sq.qstncore
 and ri.survey_id = sq.survey_id
 and ri.questionform_id = bip.questionform_id
 and ri.sampleunit_id = bip.sampleunit_id
 and ri.intpage_num = bip.intpage_num
 and ri.qstncore = bip.qstncore
 and ri.survey_id = bip.survey_id
 and bip.item = bcntr.counter
 and sq.numBubbleCount >= bcntr.counter
 and sq.subtype = 1
 and ri.bitmultiresp = 1

if @@error <> 0
   insert into scanimporterror (STRLITHOCODE, DATERRORDATE)
   select strlithocode, getdate() from #upreturns

/* Thanks Yous */
 INSERT INTO dbo.ScheduledMailing (
  MailingStep_id, SamplePop_id, Methodology_id, datGenerate
 ) SELECT DISTINCT
  MS.MailingStep_id, ri.SamplePop_id, MS.Methodology_id, getdate()
 FROM MailingStep MS, SentMailing SM, #resultsinfo ri
 WHERE SM.strLithoCode = ri.strLithoCode
 AND SM.Methodology_id = MS.Methodology_id
 AND MS.bitThankYouItem = 1


