/*
	S32 US18	PQRS Completeness
				As a PQRS Vendor, we need to evaluate completeness of returned surveys, so that we can process and report data correctly

	18.1	implement PQRScompleteness in ACO CAHPS completeness and possibly rename the proc to more generic

Dave Gilsdorf

QP_Prod:
ALTER PROCEDURE [dbo].[CheckForACOCAHPSUsablePartials]
ALTER PROCEDURE [dbo].[CheckForCAHPSIncompletes]
ALTER PROCEDURE [dbo].[sp_phase3_questionresult_for_extract] 
*/
go
use QP_Prod
go
ALTER PROCEDURE [dbo].[CheckForACOCAHPSUsablePartials]
as
-- created 1/30/2014 DBG
-- After ACO CAHPS Surveys expire, we want to see if there were any blank/incomplete or partial returns that we initially ignored.
-- If so, and no other MailingSteps resulted in a complete Survey, we want to go ahead and use the blank/incomplete or partial return

-- list of all the returned QuestionForm records for SamplePop's that have at least one blank/incomplete or partial return (unusedreturn_id=5)
-- and the sampleset has expired.

-- Modified 06/18/2014 DBG - refactored ACOCAHPSCompleteness as a procedure instead of a function.
-- Modified 12/23/2014 DBG - other survey types are using unusedreturn_id=5, so I added "Surveytype_id=10" to the initial query

select qf.SamplePop_id, qf.QuestionForm_id, qf.unusedreturn_id, qf.datUnusedReturn, convert(bit,NULL) as bitUse, 0 as ACODisposition
, sstx.Subtype_id, sstx.Subtype_nm
into #partials
from QuestionForm qf
inner join survey_def sd on qf.survey_id=sd.survey_id
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm from [dbo].[SurveySubtype] sst INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)) sstx on sstx.Survey_id = qf.SURVEY_ID --> new: 1.6
where qf.SamplePop_id in (select SamplePop_id from QuestionForm where unusedreturn_id=5)
and (qf.datReturned is not null or unusedreturn_id=5)
and sd.Surveytype_id=10 -- ACOCAHPS
and isnull(sm.datexpire,getdate())<getdate()

if @@rowcount=0
	RETURN
	
-- if there's any other MailingStep with unusedreturn_id<>5, we're not going to use the blank/incomplete or partial
update #partials
set bitUse=0
where SamplePop_id in (	select SamplePop_id
						from #partials
						group by SamplePop_id
						having count(distinct isnull(unusedreturn_id,0)) > 1)

select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
, Subtype_nm
into #ACOQF
from #partials
where unusedreturn_id=5
and bitUse is null

exec dbo.ACOCAHPSCompleteness

update p
set ACODisposition=qf.Disposition
from #partials p
inner join #ACOQF qf on p.questionform_id=qf.questionform_id
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete


-- If all of the MailingSteps are blank/incomplete or partial, use the partial that was returned first. 
update p
set bitUse=1
from #partials p
inner join (select SamplePop_id, ACODisposition, min(datUnusedReturn) as firstreturned
			from #partials
			where SamplePop_id in (	select SamplePop_id
									from #partials
									group by SamplePop_id
									having count(distinct isnull(unusedreturn_id,0)) = 1)
			and ACODisposition=31
			group by SamplePop_id, ACODisposition) fr
		on p.SamplePop_id=fr.SamplePop_id and p.ACODisposition=fr.ACODisposition and p.datUnusedReturn=fr.firstreturned
where p.unusedreturn_id=5
and p.bitUse is null

-- and don't use anything else
update p
set bitUse=0
from #partials p
inner join (select SamplePop_id
			from #partials p
			where acoDisposition=31 
			and bitUse=1) U
	on p.SamplePop_id=u.SamplePop_id
where p.unusedreturn_id=5
and p.bitUse is null

-- If they were all blank/incomplete, use the blank/incomplete that was returned first.
update p
set bitUse=1
from #partials p
inner join (select SamplePop_id, ACODisposition, min(datUnusedReturn) as firstreturned
			from #partials
			where SamplePop_id in (	select SamplePop_id
									from #partials
									group by SamplePop_id
									having count(distinct isnull(unusedreturn_id,0)) = 1)
			and ACODisposition=34
			group by SamplePop_id, ACODisposition) fr
		on p.SamplePop_id=fr.SamplePop_id and p.ACODisposition=fr.ACODisposition and p.datUnusedReturn=fr.firstreturned
where p.unusedreturn_id=5
and p.bitUse is null

-- and don't use anything else
update p
set bitUse=0
from #partials p
inner join (select SamplePop_id
			from #partials p
			where bitUse=1) U
	on p.SamplePop_id=u.SamplePop_id
where p.unusedreturn_id=5
and p.bitUse is null

-- update unusedreturn_id=6 for those blank/incomplete or partials that we're not going to use
update qf
set unusedreturn_id=6
from QuestionForm qf
inner join #partials p on qf.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=0

-- update datReturned, datResultsImported, datUnusedReturn and UnusedReturn_id for those blank/incomplete or partials that we are going to use
update qf
set datReturned=qf.datUnusedReturn, datResultsImported=qf.datUnusedReturn, datUnusedReturn=NULL, UnusedReturn_id=0
from QuestionForm qf
inner join #partials p on qf.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=1

-- move the results for blank/incomplete or partials we've decided to use into QuestionResult
insert into QuestionResult (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select qr2.QuestionForm_ID,qr2.SampleUnit_ID,qr2.QstnCore,qr2.intResponseVal
from QuestionResult2 qr2
inner join #partials p on qr2.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=1

delete qr2
from QuestionResult2 qr2
inner join #partials p on qr2.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=1

-- put the blank/incomplete or partials we've decided to use into the ETL queue
-- This is not really needed, since a trigger on QuestionForm will populate the QuestionForm_Extract table.
--insert into QuestionForm_extract (QuestionForm_id)
--select p.QuestionForm_id
--from #partials p
--where p.unusedreturn_id=5
--and p.bitUse=1

drop table #partials
GO
ALTER PROCEDURE [dbo].[CheckForCAHPSIncompletes]
AS
-- =============================================
-- Author:	Dave Gilsdorf
-- Procedure Name: CheckForCAHPSIncompletes (original name: CheckForACOCAHPSIncompletes)
-- Create date: 1/2014 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  1/2014  by Dave Gilsdorf
--			1.1  5/27/2014 by C Caouette: Integrate logic into Catalyst ETL.
--          1.2  6/18/2014 by D Gilsdorf: Refactored ACOCAHPSCompleteness as a procedure instead of a function.
--          1.3  8/7/2014 by D Gilsdorf: added ICHCAHPS processing and renamed to CheckForCAHPSIncompletes
--          1.4  9/26/2014 by D Gilsdorf: added HCAHPS processing 
--			1.4.1  10/23/2014 by D.Gilsdorf: bug fix introduced in CAHPS release 5
--			1.5  10/02/2014 by T. Butler: ACO CAHPS processing -- modified follow-up by phone S10 US14
--			1.6  10/03/2014 by T. Butler: ACO CAHPS processing -- ATA questions by questionnaire type S10 US 11
--			1.7  10/09/2014 by T. Butler: ACO CAHPS processing -- update Complete disposition calculation S10 US 12
--			1.8  12/23/2014 by D. Gilsdorf: Added HHCAHPS processing
--          1.9  2/19/2015 by L. Boswell: Added Hospice CAHPS processing S19 US16
--			S19 US14.2	 2/25/2010 T.Butler As a Hospice CAHPS vendor, we need to be able to assign the appropriate final disposition so it can be reported to CMS.
--			S19 US15	 2/25/2010 T.Butler  Calculate if a returned survey is complete, so that we can assign the correct disposition.
--			DFCT0011890  3/16/2015 T.Butler	 Increased column width for #TodaysReturns.DispositionAction from 15 to 16 to prevent truncation error.
--			DFCT0011927  4/10/2015 T.Butler  HHCAHPS disposition - modified so that last return is used when all returns are blank.
-- =============================================


/* PART 1 -- find people who are going through the ETL tonight and check their completeness. If their survey was partial or incomplete, reschedule their next mailstep. */

DECLARE @MinDate DATE;
SET @MinDate = DATEADD(DAY, -4, GETDATE());


-- v1.1  5/27/2014 by C Caouette
WITH CTE_Returns AS
(
	SELECT DISTINCT PKey1 
	FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
	WHERE eq.ExtractFileID IS NULL AND eq.EntityTypeID = 11 AND eq.Created > @MinDate
)

--SELECT * FROM CTE_Returns
-- list of everybody who returned an HCAHPS IP, ACOCAHPS, ICHCAHPS, Home Health CAHPS, or Hospice CAHPS survey today
select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
, scm.*, qf.QuestionForm_id, sm.datExpire, convert(tinyint,null) as ACODisposition, convert(varchar(16),'') as DispositionAction
, qf.ReceiptType_id, ms.strMailingStep_nm, qf.bitComplete, 0 as bitETLThisReturn, 0 as bitContinueWithMailings
, sstx.Subtype_id, sstx.Subtype_nm	--> new: 1.6
, convert(tinyint,null) as HospiceDisposition --S19 US15
into #TodaysReturns
from CTE_Returns eq
inner join QuestionForm qf on qf.QuestionForm_id=eq.PKey1 
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm from [dbo].[SurveySubtype] sst INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)) sstx on sstx.Survey_id = qf.SURVEY_ID --> new: 1.6
inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
where qf.datResultsImported is not null
and st.Surveytype_dsc in ('HCAHPS IP','ACOCAHPS','ICHCAHPS','Home Health CAHPS', 'Hospice CAHPS')
and sm.datExpire > getdate()
order by qf.datResultsImported desc

-- ACO CAHPS Processing
select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
, Subtype_nm													--> new: 1.6
into #ACOQF
from #TodaysReturns
where Surveytype_dsc='ACOCAHPS'								--> new line

exec dbo.ACOCAHPSCompleteness

update tr
set ACODisposition=qf.disposition
	--, bitContinueWithMailings = case when qf.disposition in (31,34) then 1 else 0 end
	, bitContinueWithMailings = case when qf.disposition in (34) then 1 else 0 end --> modified: 1.5
	, bitETLThisReturn        = case when qf.disposition in (31,34) then 0 else 1 end
	, bitComplete             = case when qf.disposition = 10 then 1 else 0 end
--select tr.questionform_id, tr.ACODisposition, qf.disposition, tr.bitContinueWithMailings, tr.bitETLThisReturn, qf.disposition 
from #TodaysReturns tr
inner join #ACOQF qf on tr.questionform_id=qf.questionform_id

/* Begin Write ACO dispositions to DispositionLog - new 1.7 */  

-- write the complete and partials
insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
select sentmail_id, samplepop_id, (SELECT Disposition_ID FROM ACOCAHPSDispositions WHERE ACOCAHPSValue = tr.ACODisposition),receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
from #TodaysReturns tr
where Surveytype_dsc='ACOCAHPS'	
AND strMailingStep_nm in ('1st Survey','2nd Survey')
AND ACODisposition in ( 10, 31)


-- first survey blanks
insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
select sentmail_id, samplepop_id, 25,receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
from #TodaysReturns tr
where Surveytype_dsc='ACOCAHPS'	
AND strMailingStep_nm='1st Survey'
AND ACODisposition = 34


--second survey blanks
insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
select sentmail_id, samplepop_id, 26,receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
from #TodaysReturns tr
where Surveytype_dsc='ACOCAHPS'	
AND strMailingStep_nm='2nd Survey'
AND ACODisposition = 34


/* End Write ACO dispotions to DispositionLog */

--select * from #todaysreturns
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete

			-- ICH CAHPS & Home Health CAHPS processing
			/* begin addition */
			select Surveytype_dsc, survey_id, questionform_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack----, convert(datetime,null) as GenDate1st, convert(datetime,null) as GenDate2nd
			into #QFResponseCount
			from #TodaysReturns
			where Surveytype_dsc in ('ICHCAHPS','Home Health CAHPS')
				/* for testing:
				select 'Home Health CAHPS' as Surveytype_dsc, 15851 as survey_id, questionform_id, qf.sentmail_id, qf.samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack----, convert(datetime,null) as GenDate1st, convert(datetime,null) as GenDate2nd
				into #QFResponseCount
				from Questionform qf
				inner join scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
				inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
				where qf.survey_id=15851 -- was 15722
				*/

			exec dbo.QFResponseCount

			insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
			select sentmail_id, samplepop_id, 25, receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
			--, strMailingStep_nm, ResponseCount
			from #qfResponseCount rc
			where strMailingStep_nm='1st Survey'
			and ResponseCount=0

 			insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
			select sentmail_id, samplepop_id, 26, receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
			--, strMailingStep_nm, ResponseCount
			from #qfResponseCount rc
			where strMailingStep_nm='2nd Survey'
			and ResponseCount=0
			
			update rc
			set FutureScheduledMailing=1
			-- select scm.*--rc.samplepop_id, scm.sentmail_id, rc.FutureScheduledMailing
			from #qfResponseCount rc
			inner join scheduledMailing scm on rc.samplepop_id=scm.samplepop_id
			where scm.sentmail_id is null

			-- samplepops with mailsteps that haven't been accounted for yet:
			update rc
			set AllMailStepsAreBack=0
			-- select rc.samplepop_id, qf.sentmail_id, qf.datreturned, qf.datunusedreturn, sm.datundeliverable, rc.AllMailStepsAreBack
			from #qfResponseCount rc
			inner join questionform qf on rc.samplepop_id=qf.samplepop_id
			inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
			where qf.datreturned is null and qf.datunusedreturn is null and sm.datUndeliverable is null

			-- we can etl a return if the samplepop meets these criteria:
			update tr
			set bitETLThisReturn=1, bitContinueWithMailings=0
			-- select tr.questionform_id, rc.AllMailStepsAreBack, rc.FutureScheduledMailing, tr.bitETLThisReturn, tr.bitContinueWithMailings
			from #TodaysReturns tr
			inner join #qfResponseCount rc on tr.questionform_id=rc.questionform_id
			where rc.AllMailStepsAreBack=1 
			and rc.FutureScheduledMailing=0
			
			if @@rowcount>0
			begin
				-- if we're ETLing something, check to see if any other returned mailsteps had more questions answered. If so, ETL the other mailstep
				insert into #qfresponsecount (Surveytype_dsc, survey_id, questionform_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, ResponseCount, FutureScheduledMailing, AllMailStepsAreBack)
				select tr.Surveytype_dsc, tr.survey_id, qf.questionform_id, qf.sentmail_id, qf.samplepop_id, qf.receipttype_id, ms.strmailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack
				from #TodaysReturns tr
				inner join questionform qf on tr.samplepop_id=qf.samplepop_id
				inner join ScheduledMailing scm on qf.sentmail_id=scm.sentmail_id
				inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
				where tr.bitETLThisReturn=1
				and qf.UnusedReturn_id=5
				
				if @@rowcount>0
				begin				
					exec dbo.QFResponseCount

					-- list of samplepops that have multiple returns
					select rc.questionform_id, rc.samplepop_id, ResponseCount, isnull(qf.datreturned,qf.datUnusedReturn) as datReturned, isnull(tr.bitETLThisReturn,0) as orgBitETLThisReturn, 0 as newBitETLThisReturn, 0 as useLast --> DFCT0011927
					into #takeBest
					from #qfresponsecount rc
					inner join questionform qf on rc.questionform_id=qf.questionform_id
					left join #todaysreturns tr on rc.questionform_id=tr.questionform_id

					-- samplepops where all returns were blank  --> DFCT0011927
					update tb
					set useLast = 1
					from #takebest tb
					inner join (select samplepop_id, sum(ResponseCount) as allAnswers
								from #TakeBest
								group by samplepop_id
								having count(*)>1) most
						on tb.samplepop_id=most.samplepop_id and most.allAnswers = 0


					-- we want to ETL the return with the most answers
					update tb
					set newBitETLThisReturn=1
					from #takebest tb
					inner join (select samplepop_id, max(ResponseCount) as mostAnswers
								from #TakeBest
								group by samplepop_id) most
						on tb.samplepop_id=most.samplepop_id and tb.ResponseCount = most.mostAnswers

					-- if a respondent has more than one return with the same number of answers, we want to ETL the return that was returned first
					update tb
					set newBitETLThisReturn=0
					from #takebest tb
					inner join (select samplepop_id, min(datreturned) as firstReturned 
								from #takebest 
								where newBitETLThisReturn=1 
								and useLast = 0 --> DFCT0011927
								group by samplepop_id 
								having count(*)>1) frst
						on tb.samplepop_id=frst.samplepop_id and tb.datReturned>frst.firstReturned 

					-- however, if a respondent has all blank returns, we want to ETL the last return  --> DFCT0011927
					-- Set previous blank returns to newBitETLThisReturn = 0
					update tb
					set newBitETLThisReturn=0
					from #takebest tb
					inner join (select samplepop_id, max(datreturned) as lastReturned 
								from #takebest 
								where newBitETLThisReturn=1 
								and useLast = 1
								group by samplepop_id 
								having count(*)>1) lastRet
						on tb.samplepop_id=lastRet.samplepop_id and tb.datReturned<lastRet.lastReturned 

					-- if newBitETLThisReturn is the same return as orgBitETLThisReturn, we don't need to adjust #TodaysReturn.bitETLThisReturn
					-- but we do need to change the non-ETL'd return from UnusedReturn_id=5 to UnusedReturn_id=6 (i.e. from "we might use it" to "we're never gonna use it")
					update qf
					set unusedreturn_id=6
					from #takebest tb
					inner join questionform qf on tb.questionform_id=qf.questionform_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=0

					delete from #takebest where orgBitETLThisReturn=newBitETLThisReturn

					-- if newBitETLThisReturn is the NOT same return as orgBitETLThisReturn, we need to:
					-- change today's return to an unused return (this also removes it from the Catalyst ETL queue, via a trigger)
					update qf
					set unusedreturn_id=6, datUnusedReturn=qf.datReturned, datReturned=NULL
					-- select qf.questionform_id, orgBitETLThisReturn, newBitETLThisReturn, qf.unusedreturn_id, qf.datUnusedReturn, qf.datReturned
					from #takebest tb
					inner join questionform qf on tb.questionform_id=qf.questionform_id
					where orgBitETLThisReturn=1 and newBitETLThisReturn=0

					-- move today's return's results from questionresult to questionresult2
					insert into QuestionResult2 (QUESTIONFORM_ID,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL)
					select qr.QUESTIONFORM_ID,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL
					from #takebest tb
					inner join questionresult qr on tb.questionform_id=qr.questionform_id
					where orgBitETLThisReturn=1 and newBitETLThisReturn=0

					delete qr 
					from #takebest tb
					inner join questionresult qr on tb.questionform_id=qr.questionform_id
					where orgBitETLThisReturn=1 and newBitETLThisReturn=0
					
					-- change the previous return back into a used return  (this also adds it to the Catalyst ETL queue, via a trigger)
					update qf
					set unusedreturn_id=0, datReturned=qf.datUnusedReturn, qf.datUnusedReturn=NULL
					-- select qf.questionform_id, orgBitETLThisReturn, newBitETLThisReturn, qf.unusedreturn_id, qf.datUnusedReturn, qf.datReturned
					from #takebest tb
					inner join questionform qf on tb.questionform_id=qf.questionform_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=1

					-- move the previous return's results from questionresult2 to questionresult
					insert into QuestionResult (QUESTIONFORM_ID,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL)
					select qr.QUESTIONFORM_ID,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL
					from #takebest tb
					inner join questionresult2 qr on tb.questionform_id=qr.questionform_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=1

					delete qr
					from #takebest tb
					inner join questionresult2 qr on tb.questionform_id=qr.questionform_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=1
				
					-- change the record in #todaysreturns to bitETLThisReturn=0
					update tr
					set bitETLThisReturn=0
					from #takebest tb
					inner join #todaysreturns tr on tb.questionform_id=tr.questionform_id
					where tb.newbitETLThisReturn=0
					
					-- insert the previous return into #todaysreturns
					insert into #todaysReturns (datReturned, datResultsImported, Survey_id, Surveytype_id, Surveytype_dsc, intSequence, SCHEDULEDMAILING_ID, MAILINGSTEP_ID, SAMPLEPOP_ID, 
						OVERRIDEITEM_ID, SENTMAIL_ID, METHODOLOGY_ID, DATGENERATE, QuestionForm_id, datExpire, ACODisposition, DispositionAction, ReceiptType_id, 
						strMailingStep_nm, bitComplete, bitETLThisReturn, bitContinueWithMailings)
					select qf.datReturned, qf.datResultsImported, qf.Survey_id, sd.Surveytype_id, st.Surveytype_dsc, ms.intSequence, scm.SCHEDULEDMAILING_ID, ms.MAILINGSTEP_ID, qf.SAMPLEPOP_ID, 
						scm.OVERRIDEITEM_ID, qf.SENTMAIL_ID, scm.METHODOLOGY_ID, scm.DATGENERATE, qf.QuestionForm_id, sm.datExpire, null as ACODisposition, null as DispositionAction, qf.ReceiptType_id, 
						ms.strMailingStep_nm, qf.bitComplete, tb.newbitETLThisReturn, 0 as bitContinueWithMailings
					from #takeBest tb
					inner join questionform qf on tb.questionform_id=qf.questionform_id
					inner join survey_def sd on qf.survey_id=sd.survey_id
					inner join surveytype st on sd.surveytype_id=st.surveytype_id
					inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
					inner join scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
					inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
					where tb.newBitETLThisReturn=1
					
					-- removed today's return and insert the previous return in the medusa queue
					delete qfe
					from #takebest tb
					inner join QuestionForm_extract qfe on tb.questionform_id=qfe.questionform_id
					where tb.orgBitETLThisReturn=1 and 
					tb.newBitETLThisReturn=0
					
					insert into QuestionForm_extract (Questionform_id, tiExtracted)
					select Questionform_id, 0
					from #todaysreturns
					where bitETLThisReturn=1
					and questionform_id not in (select questionform_id from QuestionForm_extract where datExtracted_dt is null)

					/* Catalyst is taken care of by triggers that fired when we updated questionform.datReturned, above
					*/
				end
			end
			
			update tr
			set bitComplete=case when ATACnt>=19 then 1 else 0 end
			from #TodaysReturns tr
			inner join (select qr.questionform_id, count(distinct sq.qstncore) as ATACnt
						from (	select rc.questionform_id, rc.survey_id, qr.qstncore, qr.intResponseVal
								from #qfResponseCount rc
								inner join questionresult qr on rc.questionform_id=qr.questionform_id
								union
								select rc.questionform_id, rc.survey_id, qr2.qstncore, qr2.intResponseVal
								from #qfResponseCount rc
								inner join questionresult2 qr2 on rc.questionform_id=qr2.questionform_id) qr
						inner join sel_qstns sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore 
						inner join sel_scls ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val
						where sq.qstncore in (51198,51199,47159,47160,47161,47162,47163,47164,47165,47166,47167,47168,47169,47170,47171,47172,47173,47174,47175,
											  47176,47178,47179,47181,47182,47183,47184,47185,47186,47187,47188,47189,47190,47191,47192,47193,47195,47196,47197)
						and sq.subtype = 1 
						AND sq.language = 1 
						AND ss.language = 1 
						group by qr.questionform_id) rc
					on tr.questionform_id=rc.questionform_id
			where tr.Surveytype_dsc = 'ICHCAHPS'

			-- similar code is used in the HHCAHPSCompleteness function (called during the Medusa ETL by in the sp_phase3_questionresult_for_extract and 
			-- SP_Phase3_QuestionResult_For_Extract_by_Samplepop prodcedures), but the function (1) doesn't look in questionresult2 for possible answers 
			-- and (2) is inefficient on large resultsets. Therefore, it's replicated here.
			update tr
			set bitComplete=case when ATACnt>9 then 1 else 0 end
			from #TodaysReturns tr
			inner join (select qr.questionform_id, count(distinct sq.qstncore) as ATACnt
						from (	select rc.questionform_id, rc.survey_id, qr.qstncore, qr.intResponseVal
								from #qfResponseCount rc
								inner join questionresult qr on rc.questionform_id=qr.questionform_id
								union
								select rc.questionform_id, rc.survey_id, qr2.qstncore, qr2.intResponseVal
								from #qfResponseCount rc
								inner join questionresult2 qr2 on rc.questionform_id=qr2.questionform_id) qr
						inner join sel_qstns sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore 
						inner join sel_scls ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val
						where sq.qstncore in (38694,38695,38696,38697,38698,38699,38700,38701,38702,38703,38704,38708,38709,38710,38711,38712,38713,38714,38717,38718)
						and sq.subtype = 1 
						AND sq.language = 1 
						AND ss.language = 1 
						group by qr.questionform_id) rc
					on tr.questionform_id=rc.questionform_id
			where tr.Surveytype_dsc = 'Home Health CAHPS'

			update tr
			set bitETLThisReturn=0, bitContinueWithMailings=1, bitComplete=0
			-- select tr.questionform_id, rc.ResponseCount, rc.strMailingStep_nm, rc.AllMailStepsAreBack, tr.bitETLThisReturn, tr.bitContinueWithMailings
			from #TodaysReturns tr
			inner join #qfResponseCount rc on tr.questionform_id=rc.questionform_id
			where rc.ResponseCount=0			
		
			/* end addition */

	-- HCAHPS and Hospice CAHPS processing - if a blank return comes in, continue data collection protocol
	delete from #QFResponseCount
	insert into #QFResponseCount
	select Surveytype_dsc, survey_id, questionform_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack----, convert(datetime,null) as GenDate1st, convert(datetime,null) as GenDate2nd
	from #TodaysReturns
	where Surveytype_dsc in ('HCAHPS IP', 'Hospice CAHPS') -- added Hospice CAHPS 2015-02-19

	exec dbo.QFResponseCount

	update #todaysreturns  -- added by G.Gilsdorf 10/23/2014 to fix bug introduced in CAHPS release 5
	set bitETLThisReturn=1, bitComplete=1, bitContinueWithMailings=0
	where surveytype_dsc in ('HCAHPS IP', 'Hospice CAHPS') -- added Hospice CAHPS 2015-02-19

	update tr 
	set bitETLThisReturn=0, bitComplete=0, bitContinueWithMailings= case when rc.strMailingStep_nm = '1st Survey' then 1 else 0 end
	-- select tr.questionform_id, tr.surveytype_dsc, rc.ResponseCount, tr.bitETLThisReturn, tr.bitComplete, tr.bitContinueWithMailings, rc.strMailingStep_nm
	from #todaysreturns tr
	inner join #QFresponsecount rc on tr.questionform_id=rc.questionform_id
	where tr.surveytype_dsc in ('HCAHPS IP', 'Hospice CAHPS') -- added Hospice CAHPS 2015-02-19
	and rc.ResponseCount=0

	/*
		S19 US15 As a Hospice CAHPS vendor, we need to be able to calculate if a returned survey is complete, 
		so that we can assign the correct disposition. - Tim Butler 
	*/
	update tr
	set HospiceDisposition = case when rc.ATACnt >= (34 * 0.50) then 13 -- Complete
							else case when rc.ATACnt >= 1 AND rc.ATACnt < (34 * 0.50) then 11 else NULL end -- Breakoff
							end
	from #TodaysReturns tr
	inner join (select qr.questionform_id, count(distinct sq.qstncore) as ATACnt
				from (	select rc.questionform_id, rc.survey_id, qr.qstncore, qr.intResponseVal
						from #qfResponseCount rc
						inner join questionresult qr on rc.questionform_id=qr.questionform_id
						union
						select rc.questionform_id, rc.survey_id, qr2.qstncore, qr2.intResponseVal
						from #qfResponseCount rc
						inner join questionresult2 qr2 on rc.questionform_id=qr2.questionform_id) qr
				inner join sel_qstns sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore 
				inner join sel_scls ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val
				where sq.qstncore in (51574,51575,51576,51577,51579,51580,51581,51582,51583,51584,51585,51586,51588,51590,51594,51597,51599,51601,51603,51604,51605,51608,51609,51610,51611,51612,51613,51614,51615,51616,51617,51618,51619,51620)
				and sq.subtype = 1 
				AND sq.language = 1 
				AND ss.language = 1 
				group by qr.questionform_id) rc
			on tr.questionform_id=rc.questionform_id
	where tr.Surveytype_dsc = 'Hospice CAHPS'

	-- completes S19 US15
	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
	select sentmail_id, samplepop_id, tr.HospiceDisposition,receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
	from #TodaysReturns tr
	where Surveytype_dsc='Hospice CAHPS'	
	AND HospiceDisposition = 13

	-- breakoffs S19 US15
	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
	select sentmail_id, samplepop_id, tr.HospiceDisposition,receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
	from #TodaysReturns tr
	where Surveytype_dsc='Hospice CAHPS'	
	AND HospiceDisposition = 11


	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
	select sentmail_id, samplepop_id, 25, receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
	--, strMailingStep_nm, ResponseCount
	from #qfResponseCount rc
	where strMailingStep_nm='1st Survey'
	and ResponseCount=0

	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
	select sentmail_id, samplepop_id, 26, receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
	--, strMailingStep_nm, ResponseCount
	from #qfResponseCount rc
	where strMailingStep_nm='2nd Survey'
	and ResponseCount=0
	-- End HCahps & Hospice

-- for complete surveys, set QuestionForm.bitComplete=1
update qf 
set bitComplete = tr.bitComplete
-- select qf.QuestionForm_id, tr.ACODisposition, qf.bitcomplete, tr.bitcomplete
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id


-- for blank/incomplete or partial Surveys, set bitComplete=0, move datReturned to datUnusedReturn, blank out datResultsImported,
-- and set UnusedReturn_id=5, which means a partial return that isn't used for now (it might be used later if it ends up being the only return we ever get)
-- fyi: UnusedReturn_id=6 means a partial return whose fate we have decided (either we ignored it because a better return came in or we used it because it's the best we got.)
update qf 
set bitComplete = 0, datReturned=null, UnusedReturn_id=5, datUnusedReturn=qf.datReturned, datResultsImported = NULL
-- select qf.QuestionForm_id, tr.bitETLThisReturn, qf.bitComplete, qf.datReturned, qf.UnusedReturn_id, qf.datUnusedReturn, qf.datResultsImported 
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where bitETLThisReturn=0

-- move blank/incomplete and partial results into QuestionResult2
insert into QuestionResult2 (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select qr.QuestionForm_ID,qr.SampleUnit_ID,qr.QstnCore,qr.intResponseVal
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where bitETLThisReturn=0

-- delete blank/incomplete and partial results from QuestionResult
delete qr
-- select qr.*, tr.bitETLThisReturn
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where bitETLThisReturn=0

-- remove blank/incomplete and partial Surveys from the ETL queue
delete qre
-- select qre.*, tr.bitETLThisReturn
from QuestionForm_extract qre
inner join #TodaysReturns tr on qre.QuestionForm_id=tr.QuestionForm_id
where bitETLThisReturn=0


/*
select unusedreturn_ID,count(*)
FROM QuestionForm
group by unusedreturn_ID

unusedreturn_ID	(No column name)
NULL			1200636
0				119186736
1				310857		Another Mailstep already returned
2				464039		Expired
3				141751		This barcode previously scanned
4				16307		Results already in QuestionResults2
88				1457
*/

-- remove anybody who has one of the following Dispositions
update tr 
set bitContinueWithMailings=0
-- select tr.SamplePop_id, dl.Disposition_id, tr.bitContinueWithMailings
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id in (
		  2 --	I do not wish to participate in this Survey
		, 3 --	The intended respondent has passed on
		, 4 --	The intended respondent is incapacitated and cannot participate in this Survey
		, 8 --	The Survey is not applicable to me
		,10--	Language Barrier
		,24 --	The intended respondent is institutionalized
		)

-- identify respondents who have Methodology-specific Dispositions
update tr set DispositionAction='No Mail '
-- select tr.SamplePop_id, dl.Disposition_id, tr.DispositionAction
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id=5 --	The intended respondent is not at this address

update tr set DispositionAction=DispositionAction+'No Phone'
-- select tr.SamplePop_id, dl.Disposition_id, tr.DispositionAction
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id in ( 14 --	The intended respondent is not at this phone
							,16 --	Bad/Missing/Wrong phone number
							)

-- grab mailing step info 
select distinct mm.Methodology_id, ms.intSequence, ms.MailingStep_id, ms.intIntervalDays, msm.MailingStepMethod_nm
into #ms
from mailingMethodology mm
inner join MailingStep ms on mm.Methodology_id=ms.Methodology_id
inner join MailingStepMethod msm on ms.MailingStepMethod_id=msm.MailingStepMethod_id
inner join #TodaysReturns tr on mm.Methodology_id=tr.Methodology_id
where tr.bitContinueWithMailings=1
order by 1,2

declare @maxint int
set @maxint = 2147483647
insert into #ms 
select Methodology_id, max(intSequence)+1,@maxint,-1,'<no next step>'
from #ms 
group by Methodology_id

-- delete from #TodaysReturns where the next mailing has already been generated.
while @@rowcount>0
	update tr
	set intSequence=ms.intSequence
		, MailingStep_id=ms.MailingStep_id
		,ScheduledMailing_id=scm.ScheduledMailing_id
		,SentMail_id=scm.SentMail_id
		,datGenerate=scm.datGenerate
		,QuestionForm_id=0
	from #TodaysReturns tr
	inner join ScheduledMailing scm on tr.SamplePop_id=scm.SamplePop_id
	inner join MailingStep ms on scm.MailingStep_id=ms.MailingStep_id
	where tr.intSequence+1 = ms.intSequence
	and bitContinueWithMailings=1

update tr
set bitContinueWithMailings=0 
-- select tr.MailingStep_id, tr.bitContinueWithMailings
from #TodaysReturns tr 
where tr.MailingStep_id=@maxint 

-- list of ScheduledMailing records that need to be re-created
select ms.MailingStep_id, tr.SamplePop_id, null as OverrideItem_id, NULL as SentMail_id, tr.Methodology_id, convert(datetime,null) as datGenerate, ms.intSequence, ms.intIntervalDays, tr.DispositionAction
--, tr.*, ms.intSequence, ms.STRMailingStep_NM
into #NewScheduledMailing 
from #TodaysReturns tr
inner join #ms ms on tr.Methodology_id=ms.Methodology_id and tr.intSequence=ms.intSequence-1
where ms.Mailingstep_id <> @maxint
and bitContinueWithMailings=1
order by tr.SamplePop_id, ms.intSequence

-- remove respondents with Methodology-specific Dispositions
delete nsm
-- select nsm.*
from #NewScheduledMailing nsm
inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
where nsm.DispositionAction like '%No Mail%'
and ms.MailingStepMethod_nm='Mail'

delete nsm
-- select nsm.*
from #NewScheduledMailing nsm
inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
where nsm.DispositionAction like '%No Phone%'
and ms.MailingStepMethod_nm='Phone'

update nsm set datGenerate=dateadd(day,nsm.intIntervalDays,convert(datetime,floor(convert(float,sm.datMailed))))
--select scm.SamplePop_id, scm.MailingStep_id, scm.SentMail_id, ms.intSequence, nsm.intSequence, nsm.datGenerate, dateadd(day,nsm.intIntervalDays,convert(datetime,floor(convert(float,sm.datMailed))))
from #NewScheduledMailing nsm
inner join ScheduledMailing scm on nsm.SamplePop_id=scm.SamplePop_id 
inner join #ms ms on scm.MailingStep_id=ms.MailingStep_id
inner join SentMailing sm on scm.SentMail_id=sm.SentMail_id
where ms.intSequence=nsm.intSequence-1

-- if the previous MailingStep hasn't mailed yet, the next mailing step will be scheduled when it mails, so we don't have to do anything
delete #NewScheduledMailing where datGenerate is NULL 

-- anything that should have already generated, generate it tonight.
-- it should be within the last few days? should we check that it's not older than that?
update #NewScheduledMailing 
set datGenerate = convert(datetime,ceiling(convert(float,getdate()))) 
where datGenerate<getdate()

insert into ScheduledMailing (OverrideItem_id, Methodology_ID, MailingStep_ID, SamplePop_ID, SentMail_ID, datGenerate)
select OverrideItem_id, Methodology_ID, MailingStep_ID, SamplePop_ID, SentMail_ID, datGenerate
from #NewScheduledMailing

drop table #NewScheduledMailing
drop table #ms
drop table #TodaysReturns
drop table #ACOQF
drop table #qfResponseCount 

/* PART 2  Now we want to look at the sampleset/mailing steps that are being generated tonight, and check to see if there 
   is anyone in the sampleset who should be getting generated tonight, but isn't in ScheduledMailing for whatever reason
   (e.g. they had a bad address disposition, but we're generating a phone step. Or their litho got reset but never rescanned.
     or who knows?)
*/

if object_id('tempdb..#ACOMailingSteps') is not null
	drop table #ACOMailingSteps

if object_id('tempdb..#ACOEverybody') is not null
	drop table #ACOEverybody

-- list of acocahps steps that are getting generated today
SELECT SD.Study_id, SD.Survey_id, SP.SampleSet_id, SM.MailingStep_id, SM.Methodology_id, ms.MailingStepMethod_id, SM.datGenerate, count(*) as cnt
into #ACOMailingSteps
FROM   Survey_def SD
inner join surveytype st on sd.surveytype_id=st.surveytype_id
inner join MailingMethodology MM on MM.Survey_id = SD.Survey_id
inner join ScheduledMailing SM on MM.Methodology_id = SM.Methodology_id 
inner join MailingStep MS on SM.MailingStep_id=MS.MailingStep_id
inner join SamplePop SP on SP.SamplePop_id = SM.SamplePop_id 
left join FormGenError FGE on SM.ScheduledMailing_id = FGE.ScheduledMailing_id 
WHERE  ST.surveytype_dsc = 'ACOCAHPS' AND
       SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       FGE.ScheduledMailing_id is NULL
GROUP BY SD.Study_id, SD.Survey_id, SP.SampleSet_id, SM.MailingStep_id, SM.Methodology_id, ms.MailingStepMethod_id, SM.datGenerate

-- list of everybody who was sampled in the same sampleset(s)
select distinct ams.Study_id, ams.Survey_id, ams.SampleSet_id, ams.MailingStep_id, ams.Methodology_id, ams.MailingStepMethod_id, sp.samplepop_id
into #ACOEverybody
from #ACOMailingSteps ams
inner join samplepop sp on ams.sampleset_id=sp.sampleset_id

-- delete people who have already returned the survey:
delete ae
from #ACOEverybody ae
inner join questionform qf on ae.samplepop_id=qf.samplepop_id
where qf.datReturned is not null

-- delete people with terminating dispositions
delete ae
from #ACOEverybody ae
inner join dispositionlog dl on ae.samplepop_id=dl.samplepop_id
where dl.Disposition_id in (
			  2 --	I do not wish to participate in this Survey
			, 3 --	The intended respondent has passed on
			, 4 --	The intended respondent is incapacitated and cannot participate in this Survey
			, 8 --	The Survey is not applicable to me
			,10 --	Language Barrier
			,11 --  Partial
			,13 --	Complete and Valid Survey
			,19 --	Complete and Valid Survey by Mail
			,20 --	Complete and Valid Survey by Phone
			,24 --	The intended respondent is institutionalized
			)

-- if this is a mail step, "Non Response Bad Address" is a terminating disposition
delete ae
from #ACOEverybody ae
inner join MailingStepMethod msm on ae.MailingStepMethod_id=msm.MailingStepMethod_id
inner join dispositionlog dl on ae.samplepop_id=dl.samplepop_id
where msm.MailingStepMethod_nm = 'Mail' and dl.disposition_id=5

-- if this is a phone step, "Non Response Bad Phone" is a terminating disposition
delete ae
from #ACOEverybody ae
inner join MailingStepMethod msm on ae.MailingStepMethod_id=msm.MailingStepMethod_id
inner join dispositionlog dl on ae.samplepop_id=dl.samplepop_id
where msm.MailingStepMethod_nm = 'Phone' and dl.disposition_id in (14,16)


-- of the people who are scheduled to generate, we want to find the datGenerate that most of them use
delete ams
from #ACOMailingSteps ams
inner join (select sampleset_id, mailingstep_id, max(cnt) as maxcnt 
			from #ACOMailingSteps 
			group by sampleset_id, mailingstep_id) mx 
		on ams.mailingstep_id=mx.mailingstep_id and ams.sampleset_id=mx.sampleset_id
where ams.cnt <> mx.maxcnt

-- delete people who already have the mailing step scheduled (whether that be tonight or some other time)
delete ae
from #ACOEverybody ae
inner join scheduledmailing schm on ae.samplepop_id=schm.samplepop_id and ae.mailingstep_id=schm.mailingstep_id

-- throw the rest of these bad boys into scheduled mailing
insert into scheduledmailing (MAILINGSTEP_ID,SAMPLEPOP_ID,SENTMAIL_ID,METHODOLOGY_ID,DATGENERATE)
select ae.MAILINGSTEP_ID,ae.SAMPLEPOP_ID,NULL,ae.METHODOLOGY_ID,min(ams.DATGENERATE)
from #ACOEverybody ae
inner join #ACOMailingSteps ams on ams.mailingstep_id=ae.mailingstep_id and ams.sampleset_id=ae.sampleset_id
group by ae.MAILINGSTEP_ID,ae.SAMPLEPOP_ID,ae.METHODOLOGY_ID
GO
-- Modified 7/28/04 SJS (skip pattern recode) 
-- Modified 11/2/05 BGD Removed skip pattern enforcement. Now in the SP_Extract_BubbleData procedure 
-- Modified 11/16/05 BGD Calculate completeness for HCAHPS Surveys 
-- Modified 2/22/06 BGD Also enforce skip if question is left blank or has an invalid response. 
-- Modified 3/7/06 BGD Calculate the number of days since first and current mailing. 
-- Modified 3/16/06 BGD Add 10000 to answers that should have been skipped instead of recoding to -7 
-- Modified 5/2/06 BGD Populating the strUnitSelectType column in the Extract_Web_QuestionForm table 
-- Modified 5/22/06 BGD Bring over the langid from SentMailing to populate Big_Table_XXXX_X.LangID 
-- Modified 8/31/07 SJS Changed "INSERT INTO Extract_Web_QuestionForm" to use datReturned rather than datResultsImported data. 
-- Modified 9/19/09 MWB Added initial HHCAHPS Logic 
-- added #b (HHCAHPS completeness check) and final Disposition logic. 
-- added ReceiptType_ID to Extract_Web_QuestionForm insert 
-- Modified 11/2/09 added extra skip logic for qstncore 38694. 
-- HHCAHPS guidelines require all questions to be 
-- skipped if 38694 is not answered as 1 
-- Modified 4/5/2010 MWB Added SurveyType 4 (MNCM) Disposition logic. 
-- added #c (completeness check) and MNCM completeness check. 
-- Modified 5/27/10 MWB changed Disposition table insert from convert 110 to 120 to add time. 
-- this will avoid PK errors in the extract 
-- Modified 11/30/12 DRM Added changes to properly evaluate nested skip questions. 
-- i.e. when a gateway question is a skip question for a previous gateway question. 
-- Modified 12/28/2012 MWB added a bunch of debug writes to drm_tracktimes around skip patten  
-- logic to help identify why Survey's are taking so long    
-- Modified 01/03/2013 DRH changed @work to #work plus index
-- Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question
-- Modified 05/13/2013 DBG - added Survey_id in the link between cmnt_QuestionResult_work and skipidentifier in four places
-- Modified 05/14/2013 DBG - modifications to account for overlapping skips
-- Modified 01/14/2014 DBG - added check for ACO CAHPS usable partials and ACOCahps completeness check 
-- Modified 02/27/2014 CB - added -5 and -6 as non-response codes. Phone surveys can code -5 as "Refused" and -6 as "Don't Know"
-- Modified 06/18/2014 DBG - refactored ACOCAHPSCompleteness as a procedure instead of a function.
-- Modified 10/29/2014 DBG - added Subtype_nm to temp table because ACOCAHPSCompleteness now needs it
-- Modified 03/27/2015 TSB -- modified #HHQF to include STRMAILINGSTEP_NM
ALTER PROCEDURE [dbo].[sp_phase3_questionresult_for_extract] 
AS 

    SET TRANSACTION isolation level READ uncommitted 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Begin SP_Phase3_QuestionResult_For_Extract' 

    --The Cmnt_QuestionResult_work table should be able to be removed.  
    TRUNCATE TABLE cmnt_QuestionResult_work 
    TRUNCATE TABLE extract_web_QuestionForm 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H get hcahps records and index' 

    --Get the records that are HCAHPS so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #a 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 2 
    GROUP  BY e.QuestionForm_id 

    CREATE INDEX tmpindex ON #a (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H update tmp table with function call' 

    UPDATE #a 
	SET    complete = dbo.Hcahpscompleteness(QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #a t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #a 

    --END: Get the records that are HCAHPS so we can compute completeness  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH get hcahps records and index' 

    ----Get the records that are HHCAHPS so we can compute completeness  
    --SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1
    --INTO   #HHQF 
    --FROM   QuestionForm_extract e, 
    --       QuestionForm qf, 
    --       Survey_def sd
    --WHERE  e.study_id IS NOT NULL 
    --       AND e.tiextracted = 0 
    --       AND datextracted_dt IS NULL 
    --       AND e.QuestionForm_id = qf.QuestionForm_id 
    --       AND qf.Survey_id = sd.Survey_id 
    --       AND Surveytype_id = 3 
    --GROUP  BY e.QuestionForm_id 

	--Modified 03/27/2015 TSB
	select e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1, ms.STRMAILINGSTEP_NM
	into #HHQF
	from QuestionForm_extract e
	inner join QuestionForm qf on e.QuestionForm_id = qf.QuestionForm_id 
	inner join survey_def sd on qf.survey_id=sd.survey_id
	inner join SENTMAILING sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
	inner join SCHEDULEDMAILING scm on scm.scheduledmailing_id = sm.scheduledmailing_id
	inner join MAILINGSTEP ms on ms.MAILINGSTEP_ID = scm.mailingstep_id
	where e.study_id IS NOT NULL 
           AND e.tiextracted = 0
		   AND sd.surveytype_id=3
	GROUP  BY e.QuestionForm_id, ms.STRMAILINGSTEP_NM


    CREATE INDEX tmpindex ON #HHQF (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update tmp table with procedure call' 

--	UPDATE #HHQF
--	SET    complete = dbo.Hhcahpscompleteness(QuestionForm_id) 
	exec dbo.HHCAHPSCompleteness

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #HHQF t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

--	DROP TABLE #HHQF --> we're using this later, so don't drop it yet.

    --END: Get the records that are HHCAHPS so we can compute completeness  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'MNCM get hcahps records and index' 

    --Get the records that are MNCM so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #c 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 4 
    GROUP  BY e.QuestionForm_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --delete #c   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    CREATE INDEX tmpindex ON #c (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'MNCM update tmp table with function call' 

    UPDATE #c 
	SET    complete = dbo.Mncmcompleteness(QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'MNCM update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, 
           #c t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #c 

	-------------------------------------------------------------------
	-- ccaouette 2014/04: Commented out and moved to Catalyst ETL
	-------------------------------------------------------------------
    --END: Get the records that are MNCM so we can compute completeness  

 --   INSERT INTO drm_tracktimes 
 --   SELECT Getdate(), 'exec CheckForACOCAHPSUsablePartials' 

	--exec dbo.CheckForACOCAHPSUsablePartials

 --   INSERT INTO drm_tracktimes 
 --   SELECT Getdate(), 'exec CheckForACOCAHPSIncompletes' 

	--exec dbo.CheckForACOCAHPSIncompletes
 --   --END: Get the records that are ACO so we can compute completeness  

INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'populate Cmnt_QuestionResult_Work' 

    INSERT INTO cmnt_QuestionResult_work 
                (QuestionForm_id, 
                 strlithocode, 
                 SamplePop_id, 
                 val, 
                 sampleunit_id, 
                 qstncore, 
                 datmailed, 
                 datimported, 
                 study_id, 
                 datGenerated, 
                 qf.Survey_id, 
                 receipttype_id, 
                 Surveytype_id, 
                 bitcomplete) 
    SELECT qf.QuestionForm_id, 
           strlithocode, 
           qf.SamplePop_id, 
           intresponseval, 
           sampleunit_id, 
        qstncore, 
           datmailed, 
           datResultsImported, 
           qfe.study_id, 
           datGenerated, 
           qf.Survey_id, 
           Isnull(qf.receipttype_id, 17), 
           sd.Surveytype_id, 
           qf.bitcomplete 
    FROM   (SELECT DISTINCT QuestionForm_id, study_id 
            FROM   QuestionForm_extract 
            WHERE  study_id IS NOT NULL 
                   AND tiextracted = 0 
                   AND datextracted_dt IS NULL) qfe, 
           QuestionForm qf, 
           SentMailing sm, 
           QuestionResult qr, 
           Survey_def sd 
    WHERE  qfe.QuestionForm_id = qf.QuestionForm_id 
           AND qf.QuestionForm_id = qr.QuestionForm_id 
           AND qf.SentMail_id = sm.SentMail_id 
           AND qf.Survey_id = sd.Survey_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --and sd.SurveyType_id=2   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'populate Extract_Web_QuestionForm' 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    INSERT INTO extract_web_QuestionForm 
                (study_id, 
                 Survey_id, 
                 QuestionForm_id, 
                 SamplePop_id, 
                 sampleunit_id, 
                 strlithocode, 
                 sampleset_id, 
                 datReturned, 
                 bitcomplete, 
                 strunitselecttype, 
                 langid, 
                 receipttype_id) 
    SELECT sp.study_id, 
           qf.Survey_id, 
           qf.QuestionForm_id, 
           qf.SamplePop_id, 
           sampleunit_id, 
           strlithocode, 
           sp.sampleset_id, 
           qf.datReturned, 
           qf.bitcomplete, 
           ss.strunitselecttype, 
           langid, 
           qf.receipttype_id 
    FROM   (SELECT DISTINCT QuestionForm_id, study_id 
            FROM   cmnt_QuestionResult_work) qfe, 
           QuestionForm qf, 
           SentMailing sm, 
           SamplePop sp, 
           selectedsample ss 
    WHERE  qfe.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = sm.SentMail_id 
           AND qf.SamplePop_id = sp.SamplePop_id 
           AND sp.sampleset_id = ss.sampleset_id 
           AND sp.pop_id = ss.pop_id 

    --INSERT INTO Extract_Web_QuestionForm (sp.Study_id, qf.Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id,                   
    -- strLithoCode, Sampleset_id, datReturned, bitComplete, strUnitSelectType, LangID, receiptType_ID)                  
    --SELECT sp.Study_id, qf.Survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode,                   
    -- sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id                
    --FROM (SELECT DISTINCT QuestionForm_id, Study_id               
    --  FROM Cmnt_QuestionResult_work) qfe,                 
    -- QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss                   
    --, Survey_def sd   
    --WHERE qfe.QuestionForm_id=qf.QuestionForm_id                    
    --AND qf.SentMail_id=sm.SentMail_id               
    --AND qf.SamplePop_id=sp.SamplePop_id                   
    --AND sp.Sampleset_id=ss.Sampleset_id                   
    --AND sp.Pop_id=ss.Pop_id              
    --and qf.Survey_id = sd.Survey_id      
    --and sd.Surveytype_id = 2   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Calc days from first mailing' 

    -- Add code to determine days from first mailing as well as days from current mailing until the return 
    -- Get all of the maildates for the SamplePops were are extracting  
    SELECT e.SamplePop_id, 
           strlithocode, 
           MailingStep_id, 
           CONVERT(DATETIME, CONVERT(VARCHAR(10), Isnull(datmailed, datprinted), 120 )) 
           datMailed 
    INTO   #mail 
    FROM   (SELECT SamplePop_id 
            FROM   extract_web_QuestionForm 
            GROUP  BY SamplePop_id) e, 
           ScheduledMailing schm, 
           SentMailing sm 
    WHERE  e.SamplePop_id = schm.SamplePop_id 
           AND schm.SentMail_id = sm.SentMail_id 

    CREATE INDEX tempindex ON #mail (SamplePop_id, strlithocode) 

    -- Update the work table with the actual number of days  
    UPDATE ewq 
    SET    DaysFromFirstMailing = Datediff(day, firstmail, datReturned), 
           DaysFromCurrentMailing = Datediff(day, c.datmailed, datReturned) 
    FROM   extract_web_QuestionForm ewq, 
           (SELECT SamplePop_id, Min(datmailed) FirstMail 
            FROM   #mail 
            GROUP  BY SamplePop_id) t, 
           #mail c 
    WHERE  ewq.SamplePop_id = t.SamplePop_id 
           AND ewq.SamplePop_id = c.SamplePop_id 
           AND ewq.strlithocode = c.strlithocode 

    -- Make sure there are no negative days.  
    UPDATE extract_web_QuestionForm 
    SET    daysfromfirstmailing = 0 
    WHERE  daysfromfirstmailing < 0 

    UPDATE extract_web_QuestionForm 
    SET    daysfromcurrentmailing = 0 
    WHERE  daysfromcurrentmailing < 0 

    DROP TABLE #mail 

    -- Modification 7/28/04 SJS -- Replaced code for skip pattern recode so that nested skip patterns are handled correctly 
	-- Modified 8/27/2013 CBC -- Removed explicit Primary Key constraint name 
    --SET NOCOUNT ON  
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --DECLARE @work TABLE (QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)                
    --CREATE TABLE #work 
    --  (  workident       INT IDENTITY (1, 1) CONSTRAINT pk_work_workident_a PRIMARY KEY, 
    --     QuestionForm_id INT, 
    --     sampleunit_id   INT, 
    --     skip_id         INT, 
    --     Survey_id       INT 
    --  )
	 
	CREATE TABLE #work 
      (  workident       INT IDENTITY (1, 1) PRIMARY KEY, 
         QuestionForm_id INT, 
         sampleunit_id   INT, 
         skip_id         INT, 
         Survey_id       INT 
      ) 


    DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT  

    SET @bitUpdate = 1 

    --Now to recode Skip pattern results  
    --If we have a valid answer, we will add 10000 to the responsevalue  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Skip patterns' 

    -- Identify the first skip pattern that needs to be enforced for a QuestionForm_id  
    DECLARE @rowcount INT 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --INSERT INTO @work (QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id)                 
    INSERT INTO #work (QuestionForm_id, sampleunit_id, skip_id, Survey_id) 
    SELECT QuestionForm_id, sampleunit_id, skip_id, si.Survey_id 
    FROM   cmnt_QuestionResult_work qr 
           INNER JOIN skipidentifier si  ON qr.Survey_id = si.Survey_id
                                           AND qr.datGenerated = si.datGenerated 
                                AND qr.qstncore = si.qstncore 
                                           AND qr.val = si.intresponseval 
           INNER JOIN Survey_def sd      ON si.Survey_id = sd.Survey_id 
    WHERE  sd.bitenforceskip <> 0 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, skip_id, si.Survey_id 
    FROM   cmnt_QuestionResult_work qr 
           INNER JOIN skipidentifier si ON qr.Survey_id = si.Survey_id
                                           AND qr.datGenerated = si.datGenerated 
                                           AND qr.qstncore = si.qstncore 
                                           AND qr.val IN ( -8, -9, -6, -5 ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
           INNER JOIN Survey_def sd     ON si.Survey_id = sd.Survey_id 
    WHERE  sd.bitenforceskip <> 0 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, -1 Skip_id, q.Survey_id 
    FROM   cmnt_QuestionResult_work q, Survey_def sd 
    WHERE  qstncore = 38694 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, -2 Skip_id, q.Survey_id 
    FROM   cmnt_QuestionResult_work q, Survey_def sd 
    WHERE  qstncore = 38726 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    ORDER  BY 1, 2, 3, 4 

    CREATE INDEX tmpwork_index ON #work (QuestionForm_id, sampleunit_id, skip_id, Survey_id) 

    SELECT @rowcount = @@rowcount 

    PRINT 'After insert into #work: ' + Cast(@rowcount AS VARCHAR) 

/*************************************************************************************************/
    --Assign Final Dispositions for HCAHPS and HHCAHPS  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Final Dispositions' 

    --HCAHPS DispositionS  
    UPDATE cqw 
    SET    FinalDisposition = '01' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 2 
           AND bitcomplete = 1 

    UPDATE cqw 
    SET    FinalDisposition = '06' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 2 
           AND bitcomplete = 0 

    --HHCAHPS DispositionS 
    -- if more than half of the ATA questions have been answered, bitComplete=1 and it's coded as a Complete
    UPDATE cqw 
    SET    FinalDisposition = '110' -- Completed Mail Survey
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
    SET    FinalDisposition = '120' -- Completed Phone Interview
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 12 

    --SELECT q.QuestionForm_id 
    --INTO   #hhcahps_invalidDisposition 
    --FROM   cmnt_QuestionResult_work q, 
    --       Survey_def sd 
    --WHERE  qstncore = 38694 
    --       AND val <> 1 
    --       AND sd.Survey_id = q.Survey_id 
    --       AND sd.Surveytype_id = 3 
    --       AND bitcomplete = 0 

	-- if incomplete and Q1=No and they didn't answer any other questions, they're ineligible
    UPDATE cqw 
    SET    FinalDisposition = '220' -- Ineligible: Does not meet eligible Population criteria
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on  hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.Q1 = 2
           AND hh.complete = 0
           AND hh.numAnswersAfterQ1 = 0

    --SELECT q.QuestionForm_id 
    --INTO   #hhcahps_validDisposition 
    --FROM   cmnt_QuestionResult_work q, 
    --       Survey_def sd 
    --WHERE  qstncore = 38694 
    --       AND val = 1 
    --       AND sd.Survey_id = q.Survey_id 
    --       AND sd.Surveytype_id = 3 
    --       AND bitcomplete = 0 

	-- if incomplete and Q1=Yes or they answered questions after Q1, it's a breakoff
    UPDATE cqw 
    SET    FinalDisposition = '310' -- Breakoff
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND (hh.numAnswersAfterQ1 > 0 or hh.Q1=1)
           
	-- if incomplete and Q1 isn't answered and they didn't answer anything else either, it's just a blank survey.
	-- Modified 03/27/2015 TSB  to only look at 2ndSurvey
    UPDATE cqw 
    SET    FinalDisposition = '320' -- Refusal
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND hh.numAnswersAfterQ1=0 
           AND hh.Q1=-9
		   AND hh.STRMAILINGSTEP_NM = '2nd Survey'

    --MNCM DispositionS  
    UPDATE cqw 
    SET    FinalDisposition = '21' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 0 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
    SET    FinalDisposition = '22' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 0 
           AND ReceiptType_ID = 12 

    UPDATE cqw 
    SET    FinalDisposition = '11' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
	SET    FinalDisposition = '12' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 12 

    SELECT q.QuestionForm_id 
    INTO   #mncm_negrespscreenqstn 
    FROM   cmnt_QuestionResult_work q, 
           Survey_def sd 
    WHERE  qstncore = 39113 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 4 
           AND bitcomplete = 0 

    UPDATE cqw 
    SET    FinalDisposition = '38' 
    FROM   cmnt_QuestionResult_work cqw, 
           #mncm_negrespscreenqstn i 
    WHERE  i.QuestionForm_id = cqw.QuestionForm_id 

    --ACO CAHPS Dispositions
    select cqw.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition, Subtype_nm
    into #ACOQF
    FROM   cmnt_QuestionResult_work cqw 
    inner join Surveytype st on cqw.Surveytype_id=st.Surveytype_id
	left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm 
				from [dbo].[SurveySubtype] sst 
				INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)
				) sst on sst.Survey_id = cqw.SURVEY_ID 
    WHERE  st.SurveyType_dsc = 'ACOCAHPS'
    
    exec dbo.ACOCAHPSCompleteness
        
    UPDATE cqw 
    SET    FinalDisposition = qf.Disposition
    FROM   cmnt_QuestionResult_work cqw 
    inner join #ACOQF qf on cqw.questionform_id=qf.questionform_id
    WHERE  qf.disposition <> 255

	drop table #ACOQF

    /*************************************************************************************************/
    /************************************************************************************************/
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Find ineligible hcahps' 

    --round up all the HHCHAPS Surveys that were not eligible (qstncore 38694 <> 1) and set an inelig. Disposition. 
    DECLARE @InEligDispo INT, @SQL VARCHAR(8000) 

    SELECT @InEligDispo = d.Disposition_id 
    FROM   Disposition d, 
           hhcahpsDispositions hd 
    WHERE  d.Disposition_id = hd.Disposition_id 
           AND hd.hhcahpsvalue = '220' 

    --SELECT q.QuestionForm_id  
    --into #updateDisposition  
    --FROM Cmnt_QuestionResult_Work q, Survey_DEF sd  
    --WHERE qstncore = 38694 AND val <> 1 AND sd.Survey_ID = q.Survey_id AND sd.SurveyType_id = 3  
    CREATE TABLE #updatedispsql (a INT IDENTITY (1, 1), strsql VARCHAR(8000))  

    --HCHAPS  
    INSERT INTO #updatedispsql 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.hcahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 2 

    --HHCAHPS  
    INSERT INTO #updatedispsql 
                (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.hhcahpsvalue = cqw.finalDisposition 
      AND cqw.Surveytype_id = 3 

    --MNCM  
    INSERT INTO #updatedispsql (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.mncmvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 4 

    --ACO
    INSERT INTO #updatedispsql (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.acocahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 10

    WHILE (SELECT Count(*) FROM #updatedispsql) > 0 
      BEGIN 
          SELECT TOP 1 @SQL = strsql FROM #updatedispsql 
          EXEC (@SQL) 

          DELETE FROM #updatedispsql WHERE strsql = @SQL 
      END 

    /************************************************************************************************/
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Update skip questions' 

    DECLARE @loopcnt INT 
    SET @loopcnt = 0 

    --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
    DECLARE @invskipcnt INT 
    SET @invskipcnt = 0 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    SELECT TOP 1 @qf = QuestionForm_id, 
                 @su = sampleunit_id, 
                 @sk = skip_id, 
                 @svy = Survey_id 
    --FROM @WORK              
    FROM   #work 
    ORDER  BY QuestionForm_id, 
              sampleunit_id, 
              skip_id 

    -- Update skipped qstncores while we have work to process  
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --WHILE (SELECT COUNT(*) FROM @work) > 0                 
    WHILE (SELECT Count(*) FROM #work) > 0 
      BEGIN 
          SET @loopcnt = @loopcnt + 1 

          --print 'QuestionForm_ID = ' + cast(@qf as varchar(10))  
          --print 'Sampleunit_ID = ' + cast(@su as varchar(10))  
          --print '@skip = ' + cast(@sk as varchar(10))  
          --print '@svy = ' + cast(@svy as varchar(10))  
          --print '@bitUpdate = ' + cast(@bitUpdate as varchar(10))  
          --SkipPatternWork:  
          IF @bitUpdate = 1 
            BEGIN 
                --print 'standard skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       skipqstns sq 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = Skip_id 
                       AND sq.qstncore = qr.qstncore 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'Start HHCAHPS qstncore 38694 skip update' 
                  END 

                --print 'HHCAHPS qstncore 38694 skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       Survey_def sd, 
                       (SELECT DISTINCT qstncore 
                        FROM   sel_qstns 
                        WHERE  Survey_id = @svy 
                               AND qstncore <> 38694 
                               AND nummarkcount > 0) a 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = -1 
                       AND a.qstncore = qr.qstncore 
                       AND sd.Survey_id = @svy 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 
                       AND sd.Surveytype_id = 3 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'End HHCAHPS qstncore 38694 skip update' 
                  END 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'Start HHCAHPS qstncore 38726 skip update' 
                  END 

                --print 'HHCAHPS qstncore 38726 skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       Survey_def sd 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = -2 
                       AND qr.qstncore = 38727 
                       AND sd.Survey_id = @svy 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 
                       AND sd.Surveytype_id = 3 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'End HHCAHPS qstncore 38726 skip update' 
                  END 
            END 

          -- Identify the NEXT skip pattern that needs to be enforced for a QuestionForm_id  
          -- Modified 01/03/2013 DRH changed @work to #work plus index 
          --DELETE FROM @work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id    
          DELETE FROM #work 
         WHERE  @qf = QuestionForm_id 
                 AND @su = sampleunit_id 
                 AND @sk = skip_id 
                 AND @svy = Survey_id 

          --SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY QuestionForm_id, sampleunit_id, skip_id     
          SELECT TOP 1 @qf = QuestionForm_id, 
                   @su = sampleunit_id, 
                       @sk = skip_id, 
                       @svy = Survey_id 
          FROM   #work 
          ORDER  BY QuestionForm_id, 
                    sampleunit_id, 
                    skip_id 

          IF @loopcnt < 25 
            BEGIN 
                INSERT INTO drm_tracktimes 
                SELECT Getdate(), 'Start Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'
            END 

          --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
          SELECT @invskipcnt = Count(*) 
          FROM   cmnt_QuestionResult_work qr 
                 INNER JOIN skipidentifier si  ON qr.Survey_id = si.Survey_id
                                                  AND qr.datGenerated = si.datGenerated 
                                                  AND qr.qstncore = si.qstncore 
                                                  AND ( qr.val = si.intresponseval OR qr.val IN ( -8, -9, -6, -5 ) ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                 INNER JOIN Survey_def sd      ON si.Survey_id = sd.Survey_id 
                 INNER JOIN skipqstns sq       ON si.skip_id = sq.skip_id 
                 INNER JOIN skipidentifier si2 ON sq.qstncore = si2.qstncore 
                                                  AND si2.skip_id = @sk 
          WHERE  sd.bitenforceskip <> 0 
                 AND qr.QuestionForm_id = @qf 

          -- Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop 
          IF (SELECT Count(*) 
              FROM   cmnt_QuestionResult_work qr 
                     INNER JOIN skipidentifier si ON qr.QuestionForm_id = @qf 
                                                     AND qr.sampleunit_id = @su  
                                                     AND qr.Survey_id = si.Survey_id
                                                     AND qr.datGenerated = si.datGenerated 
                                                     AND qr.qstncore = si.qstncore 
                                                     AND ( qr.val = si.intresponseval OR qr.val IN ( -8, -9, -6, -5 ) ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                                     AND si.skip_id = @sk 
                                                     --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
                                                     AND @invskipcnt = 0 
             -- 11/30/12 DRM -- Nested skip questions  
             -- If any previous gateway questions include the current gateway as a skip question,  
             --  and if the previous gateway was answered so as to skip the current gateway,  
             -- then don't enforce skip logic on the current gateway question.  
             --select count(*)  
             --FROM Cmnt_QuestionResult_Work qr  
             --INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
             --INNER JOIN Survey_def sd ON si.Survey_id = sd.Survey_id  
             --inner join SkipQstns sq on si.Skip_id = sq.Skip_id  
             --inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk  
             --WHERE sd.bitEnforceSkip <> 0  
             --and qr.QuestionForm_id = @qf  
             ) > 0 
              OR (SELECT count(*)
                  FROM   cmnt_QuestionResult_work qr, 
                         Survey_def sd 
                  WHERE  qr.QuestionForm_id = @qf 
                     AND qr.sampleunit_id = @su 
                         AND qstncore = 38694 
                         AND val <> 1 
                         AND @sk = -1 
                         AND sd.Survey_id = qr.Survey_id 
                         AND sd.Surveytype_id = 3) > 0 
              OR (SELECT count(*)
                  FROM   cmnt_QuestionResult_work qr, 
                         Survey_def sd 
                  WHERE  qr.QuestionForm_id = @qf 
                         AND qr.sampleunit_id = @su 
                         AND qstncore = 38726 
                         AND val <> 1 
                         AND @sk = -2 
                         AND sd.Survey_id = qr.Survey_id 
                         AND sd.Surveytype_id = 3) > 0 
            SET @bitUpdate = 1 
          ELSE 
            SET @bitUpdate = 0 

          IF @loopcnt < 25 
            BEGIN 
                INSERT INTO drm_tracktimes 
                SELECT Getdate(), 'End Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'
            END 
      END 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'End SP_Phase3_QuestionResult_For_Extract' 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    DROP TABLE #work 

	--dbg 5/14/13-- -8's and -9's are now being offset, but we don't really want them to be. So we're now offsetting them back.
    UPDATE cmnt_QuestionResult_work 
    SET    val = val - 10000 
    WHERE  val IN ( 9991, 9992, 9995, 9994 ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know

    SET nocount OFF 
    SET TRANSACTION isolation level READ committed
GO