/*
S51 ATL-492 CheckForCAHPSIncomplete

As Atlas, we want to refactor the completeness checks in CheckForCAHPSImcompletes so we joins to DL_SEL_QSTNS_BySampleSet & DL_SEL_SCLS_BySampleSet, so that completeness checks are accurate 
when questions are removed from the form.

ATL-492 Modify the stored procedure to use the DL_ tables

Dave Gilsdorf

QP_Prod
ALTER PROCEDURE dbo.CheckForCAHPSIncompletes

*/
use qp_prod
go
-- There is one known Hospice CAHPS return from production that brought this situation to light. So we'll re-queue it when we release this to production.
if exists (select * from qualpro_params where STRPARAM_NM ='EnvName' and strParam_value in ('STAGING','PRODUCTION'))
	update questionform 
	set datreturned=datreturned
	where samplepop_id=134293485 
	and datreturned is not null
go
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
--			12/23/2015   D.Gilsdorf  -- fix to address missing infamous DATRETURNED issue.
--			S41 US21     01/22/2016 T.Butler  OAS: Keep Most Complete Return - As an authorized OAS CAHPS vendor, we need to keep the most complete return when two returns are received, so that we comply protocols 
--			S43 US8		02/18/2016 T.Butler  Disposition Log Days:  As the Atlas Team, we want to populate days from first in the NRC10 dispo log, so that dispositions are processed.
--			S49 ATL-395 05/17/2016 T.Butler Hospice CAHPS Lang Speak Question Update : ATL-397 update the Hospice completeness check to question to include new qstncore 55137
-- =============================================


/* PART 1 -- find people who are going through the ETL tonight and check their completeness. If their survey was partial or incomplete, reschedule their next mailstep. */

DECLARE @doLogging bit = 0, @LogTime datetime = getdate()

SELECT @doLogging = NUMPARAM_VALUE
FROM dbo.QUALPRO_PARAMS WHERE STRPARAM_NM = 'CAHPSCompletenessLogging' and STRPARAM_GRP = 'CAHPS'


DECLARE @MinDate DATE;
SET @MinDate = DATEADD(DAY, -4, GETDATE());

DECLARE  @sql varchar(max);
declare @maxQFerror int
select @maxQFerror = max(QfMissingDatreturned_id) from Questionform_Missing_datReturned;

-- v1.1  5/27/2014 by C Caouette
WITH CTE_Returns AS
(
	SELECT DISTINCT PKey1 
	FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
	WHERE eq.ExtractFileID IS NULL AND eq.EntityTypeID = 11 AND eq.Created > @MinDate
	and Source = 'trg_NRC_DataMart_ETL_dbo_QUESTIONFORM'
)

--SELECT * FROM CTE_Returns
-- list of everybody who returned an HCAHPS IP, ACOCAHPS, ICHCAHPS, Home Health CAHPS, or Hospice CAHPS survey today
select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
, scm.*, qf.QuestionForm_id, sm.datExpire, convert(tinyint,null) as ACODisposition, convert(varchar(16),'') as DispositionAction
, qf.ReceiptType_id, ms.strMailingStep_nm, qf.bitComplete, 0 as bitETLThisReturn, 0 as bitContinueWithMailings
, sstx.Subtype_id, sstx.Subtype_nm	--> new: 1.6
, convert(tinyint,null) as HospiceDisposition --S19 US15
, convert(int,null) as DaysFromFirst	--		S43 US8
, DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),sm.datMailed,120)),qf.datReturned) as DaysFromCurrent	--		S43 US8
, sp.Sampleset_id
into #TodaysReturns
from CTE_Returns eq
inner join QuestionForm qf on qf.QuestionForm_id=eq.PKey1 
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join SamplePop sp on qf.samplepop_id=sp.samplepop_id
inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm from [dbo].[SurveySubtype] sst INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)) sstx on sstx.Survey_id = qf.SURVEY_ID --> new: 1.6
inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
where qf.datResultsImported is not null
and st.Surveytype_dsc in ('HCAHPS IP','ACOCAHPS','ICHCAHPS','Home Health CAHPS', 'Hospice CAHPS','PQRS CAHPS','OAS CAHPS') 
and sm.datExpire > getdate()
order by qf.datResultsImported desc

--		S43 US8
UPDATE tr
SET DaysFromFirst = DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),sm.FirstMailed,120)),tr.datReturned)
from #TodaysReturns tr
inner join (select tr.samplepop_id, min(sm.datMailed) as FirstMailed
			FROM #TodaysReturns tr
			inner join dbo.ScheduledMailing scm on tr.samplepop_id=scm.samplepop_id
			inner join dbo.SentMailing sm on scm.sentmail_id=sm.sentmail_id
			WHERE tr.datReturned is not null
			GROUP BY tr.samplepop_id) sm
		on tr.samplepop_id=sm.samplepop_id


-- ACO CAHPS Processing
select QuestionForm_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
, Subtype_nm, SurveyType_id													--> new: 1.6
into #ACOQF
from #TodaysReturns
where Surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')								--> new line

exec dbo.ACOCAHPSCompleteness

update tr
set ACODisposition=qf.disposition
	--, bitContinueWithMailings = case when qf.disposition in (31,34) then 1 else 0 end
	, bitContinueWithMailings = case when qf.disposition in (34) then 1 else 0 end --> modified: 1.5
	, bitETLThisReturn        = case when qf.disposition in (31,34) then 0 else 1 end
	, bitComplete             = case when qf.disposition = 10 then 1 else 0 end
--select tr.QuestionForm_id, tr.ACODisposition, qf.disposition, tr.bitContinueWithMailings, tr.bitETLThisReturn, qf.disposition 
from #TodaysReturns tr
inner join #ACOQF qf on tr.QuestionForm_id=qf.QuestionForm_id

/* Begin Write ACO dispositions to DispositionLog - new 1.7 */  

-- write the complete and partials
insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
, DaysFromFirst, DaysFromCurrent)
select sentmail_id, samplepop_id, (SELECT Disposition_ID FROM ACOCAHPSDispositions WHERE ACOCAHPSValue = tr.ACODisposition),receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
, tr.DaysFromFirst, tr.DaysFromCurrent --	S43 US8
from #TodaysReturns tr
where Surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
AND strMailingStep_nm in ('1st Survey','2nd Survey')
AND ACODisposition in ( 10, 31)


-- first survey blanks
insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
, DaysFromFirst, DaysFromCurrent)
select sentmail_id, samplepop_id, 25,receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
, tr.DaysFromFirst, tr.DaysFromCurrent --	S43 US8
from #TodaysReturns tr
where Surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
AND strMailingStep_nm='1st Survey'
AND ACODisposition = 34


--second survey blanks
insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
, DaysFromFirst, DaysFromCurrent)
select sentmail_id, samplepop_id, 26,receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
, tr.DaysFromFirst, tr.DaysFromCurrent --	S43 US8
from #TodaysReturns tr
where Surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
AND strMailingStep_nm='2nd Survey'
AND ACODisposition = 34


/* End Write ACO dispotions to DispositionLog */

--select * from #todaysreturns
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete


			-----
			select qf.questionform_id, qf.survey_id, qf.samplepop_id, qf.datReturned, qf.unusedreturn_id, qf.datunusedreturn, qf.datresultsimported, qf.bitcomplete 
			into #Audit
			from questionform qf
			inner join survey_def sd on qf.survey_id=sd.survey_id
			where sd.surveytype_id in (3,8,16)
			and qf.datreturned > convert(datetime,floor(convert(float,@LogTime)))
			and @doLogging = 1
			-----

			-- ICH CAHPS & Home Health CAHPS & OAS CAHPS processing
			/* begin addition */
			select Surveytype_dsc, survey_id, QuestionForm_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack	
			, 0 as tempFlag
			, DaysFromFirst, DaysFromCurrent --	S43 US8
			, Sampleset_id
			into #QFResponseCount
			from #TodaysReturns
			where Surveytype_dsc in ('ICHCAHPS','Home Health CAHPS','OAS CAHPS')
				/* for testing:
				select 'Home Health CAHPS' as Surveytype_dsc, 15851 as survey_id, QuestionForm_id, qf.sentmail_id, qf.samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack, 
					DaysFromFirst, DaysFromCurrent
				into #QFResponseCount
				from Questionform qf
				inner join scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
				inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
				where qf.survey_id=15851 -- was 15722
				*/

			exec dbo.QFResponseCount

			insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
			,DaysFromFirst,DaysFromCurrent)
			select sentmail_id, samplepop_id, 25, receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
			, DaysFromFirst, DaysFromCurrent --	S43 US8
			--, strMailingStep_nm, ResponseCount
			from #qfResponseCount rc
			where strMailingStep_nm='1st Survey'
			and ResponseCount=0

 			insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
			,DaysFromFirst,DaysFromCurrent)
			select sentmail_id, samplepop_id, 26, receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
			, DaysFromFirst, DaysFromCurrent --	S43 US8
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
			-- select tr.QuestionForm_id, rc.AllMailStepsAreBack, rc.FutureScheduledMailing, tr.bitETLThisReturn, tr.bitContinueWithMailings
			from #TodaysReturns tr
			inner join #qfResponseCount rc on tr.QuestionForm_id=rc.QuestionForm_id
			where rc.AllMailStepsAreBack=1 
			and rc.FutureScheduledMailing=0
			
			if @@rowcount>0
			begin

				if @doLogging = 1
				begin
					insert into [temp_TodaysReturns] 
						select		[datReturned]
								  ,[datResultsImported]
								  ,[Survey_id]
								  ,[Surveytype_id]
								  ,[Surveytype_dsc]
								  ,[intSequence]
								  ,[SCHEDULEDMAILING_ID]
								  ,[MAILINGSTEP_ID]
								  ,[SAMPLEPOP_ID]
								  ,[OVERRIDEITEM_ID]
								  ,[SENTMAIL_ID]
								  ,[METHODOLOGY_ID]
								  ,[DATGENERATE]
								  ,[QuestionForm_id]
								  ,[datExpire]
								  ,[ACODisposition]
								  ,[DispositionAction]
								  ,[ReceiptType_id]
								  ,[strMailingStep_nm]
								  ,[bitComplete]
								  ,[bitETLThisReturn]
								  ,[bitContinueWithMailings]
								  ,[Subtype_id]
								  ,[Subtype_nm]
								  ,[HospiceDisposition]								  
								  , @LogTime 
								  ,[DaysFromFirst]
								  ,[DaysFromCurrent]
						from #TodaysReturns

					insert into [temp_qfResponseCount] 
					SELECT [Surveytype_dsc]
						  ,[survey_id]
						  ,[QuestionForm_id]
						  ,[sentmail_id]
						  ,[samplepop_id]
						  ,[receipttype_id]
						  ,[strMailingStep_nm]
						  ,[ResponseCount]
						  ,[FutureScheduledMailing]
						  ,[AllMailStepsAreBack]
						  ,[tempFlag]					  
						  , @LogTime 
						  ,[DaysFromFirst]
						  ,[DaysFromCurrent]
						from #qfResponseCount
				end

				-- if we're ETLing something, check to see if any other returned mailsteps had more questions answered. If so, ETL the other mailstep
				insert into #qfresponsecount (Surveytype_dsc, survey_id, QuestionForm_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, ResponseCount, FutureScheduledMailing,AllMailStepsAreBack,tempFlag,DaysFromFirst,DaysFromCurrent,Sampleset_id)
				select tr.Surveytype_dsc, tr.survey_id, qf.QuestionForm_id, qf.sentmail_id, qf.samplepop_id, qf.receipttype_id, ms.strmailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack, 1 as tempFlag
				, tr.DaysFromFirst, tr.DaysFromCurrent, tr.Sampleset_id
				from #TodaysReturns tr
				inner join questionform qf on tr.samplepop_id=qf.samplepop_id
				inner join ScheduledMailing scm on qf.sentmail_id=scm.sentmail_id
				inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
				where tr.bitETLThisReturn=1
				and qf.UnusedReturn_id=5
				and tr.Surveytype_dsc in ('ICHCAHPS','Home Health CAHPS','OAS CAHPS')
				
				if @@rowcount>0
				begin
					
					exec dbo.QFResponseCount

					if @doLogging = 1
					begin
						insert into [temp_qfResponseCount] SELECT [Surveytype_dsc]
						  ,[survey_id]
						  ,[QuestionForm_id]
						  ,[sentmail_id]
						  ,[samplepop_id]
						  ,[receipttype_id]
						  ,[strMailingStep_nm]
						  ,[ResponseCount]
						  ,[FutureScheduledMailing]
						  ,[AllMailStepsAreBack]
						  ,[tempFlag]					  
						  , @LogTime 
						  ,[DaysFromFirst]
						  ,[DaysFromCurrent]
						  from #qfResponseCount 
						  where tempFlag=1
					end

					-- list of samplepops that have multiple returns
					select rc.QuestionForm_id, rc.samplepop_id, ResponseCount, isnull(qf.datreturned,qf.datUnusedReturn) as datReturned, isnull(tr.bitETLThisReturn,0) as orgBitETLThisReturn, 0 as newBitETLThisReturn, 0 as useLast --> DFCT0011927
					into #takeBest
					from #qfresponsecount rc
					inner join questionform qf on rc.QuestionForm_id=qf.QuestionForm_id
					left join #todaysreturns tr on rc.QuestionForm_id=tr.QuestionForm_id
					where rc.AllMailStepsAreBack=1

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

					if @doLogging = 1
					begin
						insert into [temp_takeBest] select *, @LogTime from #TakeBest
					end

					-- if newBitETLThisReturn is the same return as orgBitETLThisReturn, we don't need to adjust #TodaysReturn.bitETLThisReturn
					-- but we do need to change the non-ETL'd return from UnusedReturn_id=5 to UnusedReturn_id=6 (i.e. from "we might use it" to "we're never gonna use it")
					update qf
					set unusedreturn_id=6
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=0
					and qf.unusedreturn_id=5
					-----

					if exists (select * from Questionform_Missing_datReturned where QfMissingDatreturned_id>@maxQFerror)
					begin
						select @sql = 'yo! (a) There are ' + convert(varchar,count(*))+' new records in Questionform_Missing_datReturned. QfMissingDatreturned_id between ' + convert(varchar,min(QfMissingDatreturned_id)) + ' and ' 
							+ convert(varchar,max(QfMissingDatreturned_id))
						from Questionform_Missing_datReturned
						where QfMissingDatreturned_id>@maxQFerror
						print @SQL
						select @maxQFerror = max(QfMissingDatreturned_id) from Questionform_Missing_datReturned
					end

					-----

					delete from #takebest where orgBitETLThisReturn=newBitETLThisReturn

					-- if newBitETLThisReturn is the NOT same return as orgBitETLThisReturn, we need to:
					-- move today's return's results from questionresult to questionresult2
					insert into QuestionResult2 (QuestionForm_id,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL)
					select qr.QuestionForm_id,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					inner join questionresult qr on tb.QuestionForm_id=qr.QuestionForm_id
					where orgBitETLThisReturn=1 and newBitETLThisReturn=0
					and qf.datReturned is not NULL

					delete qr 
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					inner join questionresult qr on tb.QuestionForm_id=qr.QuestionForm_id
					where orgBitETLThisReturn=1 and newBitETLThisReturn=0
					and qf.datReturned is not NULL


					-- change today's return to an unused return (this also removes it from the Catalyst ETL queue, via a trigger)
					update qf
					set unusedreturn_id=6, datUnusedReturn=qf.datReturned, datReturned=NULL
					-- select qf.QuestionForm_id, orgBitETLThisReturn, newBitETLThisReturn, qf.unusedreturn_id, qf.datUnusedReturn, qf.datReturned
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					where orgBitETLThisReturn=1 and newBitETLThisReturn=0
					and qf.datReturned is not NULL
					-----


					if exists (select * from Questionform_Missing_datReturned where QfMissingDatreturned_id>@maxQFerror)
					begin
						select @sql = 'yo! (b) There are ' + convert(varchar,count(*))+' new records in Questionform_Missing_datReturned. QfMissingDatreturned_id between ' + convert(varchar,min(QfMissingDatreturned_id)) + ' and ' 
							+ convert(varchar,max(QfMissingDatreturned_id))
						from Questionform_Missing_datReturned
						where QfMissingDatreturned_id>@maxQFerror
						print @SQL
						select @maxQFerror = max(QfMissingDatreturned_id) from Questionform_Missing_datReturned
					end

					-----
					
					-- move the previous return's results from questionresult2 to questionresult
					insert into QuestionResult (QuestionForm_id,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL)
					select qr.QuestionForm_id,SAMPLEUNIT_ID,QSTNCORE,INTRESPONSEVAL
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					inner join questionresult2 qr on tb.QuestionForm_id=qr.QuestionForm_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=1
					and qf.datUnusedReturn is not null
					and qf.unusedreturn_id=5

					delete qr
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					inner join questionresult2 qr on tb.QuestionForm_id=qr.QuestionForm_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=1
					and qf.datUnusedReturn is not null
					and qf.unusedreturn_id=5

					-- change the previous return back into a used return  (this also adds it to the Catalyst ETL queue, via a trigger)
					update qf
					set unusedreturn_id=0, datReturned=qf.datUnusedReturn, qf.datUnusedReturn=NULL
					-- select qf.QuestionForm_id, orgBitETLThisReturn, newBitETLThisReturn, qf.unusedreturn_id, qf.datUnusedReturn, qf.datReturned
					from #takebest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					where orgBitETLThisReturn=0 and newBitETLThisReturn=1
					and qf.datUnusedReturn is not null
					and qf.unusedreturn_id=5
					-----

					if exists (select * from Questionform_Missing_datReturned where QfMissingDatreturned_id>@maxQFerror)
					begin
						select @sql = 'yo! (c) There are ' + convert(varchar,count(*))+' new records in Questionform_Missing_datReturned. QfMissingDatreturned_id between ' + convert(varchar,min(QfMissingDatreturned_id)) + ' and ' 
							+ convert(varchar,max(QfMissingDatreturned_id))
						from Questionform_Missing_datReturned
						where QfMissingDatreturned_id>@maxQFerror
						print @SQL
						select @maxQFerror = max(QfMissingDatreturned_id) from Questionform_Missing_datReturned
					end

					-----
				
					-- change the record in #todaysreturns to bitETLThisReturn=0
					update tr
					set bitETLThisReturn=0
					from #takebest tb
					inner join #todaysreturns tr on tb.QuestionForm_id=tr.QuestionForm_id
					where tb.newbitETLThisReturn=0
					
					-- insert the previous return into #todaysreturns
					insert into #todaysReturns (datReturned, datResultsImported, Survey_id, Surveytype_id, Surveytype_dsc, intSequence, SCHEDULEDMAILING_ID, MAILINGSTEP_ID, SAMPLEPOP_ID, 
						OVERRIDEITEM_ID, SENTMAIL_ID, METHODOLOGY_ID, DATGENERATE, QuestionForm_id, datExpire, ACODisposition, DispositionAction, ReceiptType_id, 
						strMailingStep_nm, bitComplete, bitETLThisReturn, bitContinueWithMailings
						,DaysFromFirst
						,DaysFromCurrent
						,Sampleset_id)
					select qf.datReturned, qf.datResultsImported, qf.Survey_id, sd.Surveytype_id, st.Surveytype_dsc, ms.intSequence, scm.SCHEDULEDMAILING_ID, ms.MAILINGSTEP_ID, qf.SAMPLEPOP_ID, 
						scm.OVERRIDEITEM_ID, qf.SENTMAIL_ID, scm.METHODOLOGY_ID, scm.DATGENERATE, qf.QuestionForm_id, sm.datExpire, null as ACODisposition, null as DispositionAction, qf.ReceiptType_id, 
						ms.strMailingStep_nm, qf.bitComplete, tb.newbitETLThisReturn, 0 as bitContinueWithMailings
						, convert(int,null) as DaysFromFirst	--		S43 US8
						, DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),sm.datMailed,120)),qf.datReturned) as DaysFromCurrent	--		S43 US8
						, sp.Sampleset_id
					from #takeBest tb
					inner join questionform qf on tb.QuestionForm_id=qf.QuestionForm_id
					inner join SamplePop sp on qf.samplepop_id=sp.samplepop_id
					inner join survey_def sd on qf.survey_id=sd.survey_id
					inner join surveytype st on sd.surveytype_id=st.surveytype_id
					inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
					inner join scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
					inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
					where tb.newBitETLThisReturn=1
					and qf.QuestionForm_id not in (select QuestionForm_id from #todaysreturns)


					--		S43 US8
					UPDATE tr
					SET DaysFromFirst = DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),sm.FirstMailed,120)),tr.datReturned)
					from #TodaysReturns tr
					inner join (select tr.samplepop_id, min(sm.datMailed) as FirstMailed
								FROM #TodaysReturns tr
								inner join dbo.ScheduledMailing scm on tr.samplepop_id=scm.samplepop_id
								inner join dbo.SentMailing sm on scm.sentmail_id=sm.sentmail_id
								WHERE tr.datReturned is not null
								GROUP BY tr.samplepop_id) sm
							on tr.samplepop_id=sm.samplepop_id
					WHERE tr.DaysFromFirst is null

					
					-- removed today's return and insert the previous return in the medusa queue
					delete qfe
					from #takebest tb
					inner join QuestionForm_extract qfe on tb.QuestionForm_id=qfe.QuestionForm_id
					where tb.orgBitETLThisReturn=1 and 
					tb.newBitETLThisReturn=0
					
					insert into QuestionForm_extract (QuestionForm_id, tiExtracted)
					select QuestionForm_id, 0
					from #todaysreturns
					where bitETLThisReturn=1
					and QuestionForm_id not in (select QuestionForm_id from QuestionForm_extract where datExtracted_dt is null)

					/* Catalyst is taken care of by triggers that fired when we updated questionform.datReturned, above
					*/
				end
			end
			
			update tr
			set bitComplete=case when ATACnt>=19 then 1 else 0 end
			from #TodaysReturns tr
			inner join (select qr.QuestionForm_id, count(distinct sq.qstncore) as ATACnt
						from (	select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr.qstncore, qr.intResponseVal
								from #qfResponseCount rc
								inner join questionresult qr on rc.QuestionForm_id=qr.QuestionForm_id
								union
								select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr2.qstncore, qr2.intResponseVal
								from #qfResponseCount rc
								inner join questionresult2 qr2 on rc.QuestionForm_id=qr2.QuestionForm_id) qr
						inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
						inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
						where sq.qstncore in (51198,51199,47159,47160,47161,47162,47163,47164,47165,47166,47167,47168,47169,47170,47171,47172,47173,47174,47175,
											  47176,47178,47179,47181,47182,47183,47184,47185,47186,47187,47188,47189,47190,47191,47192,47193,47195,47196,47197)
						and sq.subtype = 1 
						AND sq.language = 1 
						AND ss.language = 1 
						group by qr.QuestionForm_id) rc
					on tr.QuestionForm_id=rc.QuestionForm_id
			where tr.Surveytype_dsc = 'ICHCAHPS'

			-- similar code is used in the HHCAHPSCompleteness function (called during the Medusa ETL by in the sp_phase3_questionresult_for_extract and 
			-- SP_Phase3_QuestionResult_For_Extract_by_Samplepop prodcedures), but the function (1) doesn't look in questionresult2 for possible answers 
			-- and (2) is inefficient on large resultsets. Therefore, it's replicated here.
			update tr
			set bitComplete=case when ATACnt>9 then 1 else 0 end
			from #TodaysReturns tr
			inner join (select qr.QuestionForm_id, count(distinct sq.qstncore) as ATACnt
						from (	select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr.qstncore, qr.intResponseVal
								from #qfResponseCount rc
								inner join questionresult qr on rc.QuestionForm_id=qr.QuestionForm_id
								union
								select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr2.qstncore, qr2.intResponseVal
								from #qfResponseCount rc
								inner join questionresult2 qr2 on rc.QuestionForm_id=qr2.QuestionForm_id) qr
						inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
						inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
						where sq.qstncore in (38694,38695,38696,38697,38698,38699,38700,38701,38702,38703,38704,38708,38709,38710,38711,38712,38713,38714,38717,38718)
						and sq.subtype = 1 
						AND sq.language = 1 
						AND ss.language = 1 
						group by qr.QuestionForm_id) rc
					on tr.QuestionForm_id=rc.QuestionForm_id
			where tr.Surveytype_dsc = 'Home Health CAHPS'

			-- New: S41 US21     01/22/106 T.Butler
			update tr 
			set bitComplete = case when (cast(ATACnt as float)/cast(22 as float)) * 100 >= 50 then 1 else 0 end
			from #TodaysReturns tr
			inner join (select qr.QuestionForm_id, count(distinct sq.qstncore) as ATACnt
						from (	select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr.qstncore, qr.intResponseVal
								from #qfResponseCount rc
								inner join questionresult qr on rc.QuestionForm_id=qr.QuestionForm_id
								union
								select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr2.qstncore, qr2.intResponseVal
								from #qfResponseCount rc
								inner join questionresult2 qr2 on rc.QuestionForm_id=qr2.QuestionForm_id) qr
						inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
						inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
						where sq.qstncore in (54086,54087,54088,54089,54090,54091,54092,54093,54094,54095,54098,54099,54100,
											  54101,54102,54103,54104,54105,54106,54107,54108,54109)
						and sq.subtype = 1 
						AND sq.language = 1 
						AND ss.language = 1 
						group by qr.QuestionForm_id) rc
					on tr.QuestionForm_id=rc.QuestionForm_id
			where tr.Surveytype_dsc = 'OAS CAHPS'

			update tr
			set bitETLThisReturn=0, bitContinueWithMailings=1, bitComplete=0
			-- select tr.QuestionForm_id, rc.ResponseCount, rc.strMailingStep_nm, rc.AllMailStepsAreBack, tr.bitETLThisReturn, tr.bitContinueWithMailings
			from #TodaysReturns tr
			inner join #qfResponseCount rc on tr.QuestionForm_id=rc.QuestionForm_id
			where rc.ResponseCount=0			
		
			/* end addition */

	-- HCAHPS and Hospice CAHPS processing - if a blank return comes in, continue data collection protocol
	delete from #QFResponseCount
	insert into #QFResponseCount
	select Surveytype_dsc, survey_id, QuestionForm_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack
	, 0 as tempFlag
	, DaysFromFirst, DaysFromCurrent --	S43 US8
	, Sampleset_id
	from #TodaysReturns
	where Surveytype_dsc in ('HCAHPS IP', 'Hospice CAHPS') -- added Hospice CAHPS 2015-02-19

	exec dbo.QFResponseCount

	update #todaysreturns  -- added by G.Gilsdorf 10/23/2014 to fix bug introduced in CAHPS release 5
	set bitETLThisReturn=1, bitComplete=1, bitContinueWithMailings=0
	where surveytype_dsc in ('HCAHPS IP', 'Hospice CAHPS') -- added Hospice CAHPS 2015-02-19

	update tr 
	set bitETLThisReturn=0, bitComplete=0, bitContinueWithMailings= case when rc.strMailingStep_nm = '1st Survey' then 1 else 0 end
	-- select tr.QuestionForm_id, tr.surveytype_dsc, rc.ResponseCount, tr.bitETLThisReturn, tr.bitComplete, tr.bitContinueWithMailings, rc.strMailingStep_nm
	from #todaysreturns tr
	inner join #QFresponsecount rc on tr.QuestionForm_id=rc.QuestionForm_id
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
		, bitComplete = case when rc.ATACnt >= (34 * 0.50) then 1 else 0 end
	from #TodaysReturns tr
	inner join (select qr.QuestionForm_id, count(distinct sq.qstncore) as ATACnt
				from (	select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr.qstncore, qr.intResponseVal
						from #qfResponseCount rc
						inner join questionresult qr on rc.QuestionForm_id=qr.QuestionForm_id
						union
						select rc.QuestionForm_id, rc.survey_id, rc.sampleset_id, qr2.qstncore, qr2.intResponseVal
						from #qfResponseCount rc
						inner join questionresult2 qr2 on rc.QuestionForm_id=qr2.QuestionForm_id) qr
				inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
				inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
				where sq.qstncore in (51574,51575,51576,51577,51579,51580,51581,51582,51583,51584,51585,51586,51588,51590,51594,51597,51599,51601,51603,51604,51605,51608,51609,51610,51611,51612,51613,51614,51615
					,51616,51617,51618,51619,51620,54067,55137) -- S49 ATL-395: added qstncore 55137
				and sq.subtype = 1 
				AND sq.language = 1 
				AND ss.language = 1 
				group by qr.QuestionForm_id) rc
			on tr.QuestionForm_id=rc.QuestionForm_id
	where tr.Surveytype_dsc = 'Hospice CAHPS'

	-- completes S19 US15
	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
	, DaysFromFirst, DaysFromCurrent)
	select sentmail_id, samplepop_id, tr.HospiceDisposition,receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
	, tr.DaysFromFirst, tr.DaysFromCurrent --	S43 US8
	from #TodaysReturns tr
	where Surveytype_dsc='Hospice CAHPS'	
	AND HospiceDisposition = 13

	-- breakoffs S19 US15
	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
	, DaysFromFirst, DaysFromCurrent)
	select sentmail_id, samplepop_id, tr.HospiceDisposition,receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
	, tr.DaysFromFirst, tr.DaysFromCurrent --	S43 US8
	from #TodaysReturns tr
	where Surveytype_dsc='Hospice CAHPS'	
	AND HospiceDisposition = 11


	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
	, DaysFromFirst, DaysFromCurrent)
	select sentmail_id, samplepop_id, 25, receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
	, DaysFromFirst, DaysFromCurrent --	S43 US8
	--, strMailingStep_nm, ResponseCount
	from #qfResponseCount rc
	where strMailingStep_nm='1st Survey'
	and ResponseCount=0

	insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy
	, DaysFromFirst, DaysFromCurrent)
	select sentmail_id, samplepop_id, 26, receipttype_id, @LogTime, 'CheckForCAHPSIncompletes'
	, DaysFromFirst, DaysFromCurrent --	S43 US8
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
and qf.UnusedReturn_id=0
and qf.datReturned is not null
					-----

					if exists (select * from Questionform_Missing_datReturned where QfMissingDatreturned_id>@maxQFerror)
					begin
						select @sql = 'yo! (d) There are ' + convert(varchar,count(*))+' new records in Questionform_Missing_datReturned. QfMissingDatreturned_id between ' + convert(varchar,min(QfMissingDatreturned_id)) + ' and ' 
							+ convert(varchar,max(QfMissingDatreturned_id))
						from Questionform_Missing_datReturned
						where QfMissingDatreturned_id>@maxQFerror
						print @SQL
						select @maxQFerror = max(QfMissingDatreturned_id) from Questionform_Missing_datReturned
					end

					-----

-- move blank/incomplete and partial results into QuestionResult2
insert into QuestionResult2 (QuestionForm_id,SampleUnit_ID,QstnCore,intResponseVal)
select qr.QuestionForm_id,qr.SampleUnit_ID,qr.QstnCore,qr.intResponseVal
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
set datGenerate = convert(datetime,ceiling(convert(float,@LogTime))) 
where datGenerate<@LogTime

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
WHERE  ST.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS') AND
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

if @doLogging = 1
begin
	select qf.questionform_id, qf.survey_id, qf.samplepop_id, qf.datReturned, qf.unusedreturn_id, qf.datunusedreturn, qf.datresultsimported, qf.bitcomplete 
	into #Audit2
	from questionform qf
	where questionform_id in (select questionform_id from #audit)

	Insert into [temp_CheckForCAHPSIncompletesAudit] select a.*, b.datReturned as newDatReturned, b.unusedreturn_id as newUnusedReturn_id, b.datunusedreturn as newDatUnusedReturn, b.datresultsimported as newDatResultsImported
		, b.bitcomplete as newBitComplete, @LogTime
	from #Audit a
	inner join #audit2 b on a.questionform_id=b.questionform_id
	where isnull(a.datReturned, '1/1/1910') <> isnull(b.datReturned, '1/1/1910') 
	or isnull(a.unusedreturn_id,-1) <> isnull(b.unusedreturn_id,-1)
	or isnull(a.datunusedreturn, '1/1/1910') <> isnull(b.datunusedreturn, '1/1/1910') 
	or isnull(a.datresultsimported, '1/1/1910') <> isnull(b.datresultsimported, '1/1/1910') 
	or a.bitcomplete <> b.bitcomplete
	or (a.bitcomplete is null and b.bitcomplete is not null)
	or (b.bitcomplete is null and a.bitcomplete is not null)

end