/*
	S22.US8 CIHI Completeness (fielding)
	  
	T8.1 Return must have >= 50% of ATA questions answered to be considered complete for CIHI

Tim Butler

QP_Prod:
CREATE PROCEDURE [dbo].[CheckForCASurveyIncompletes]

NRC_Datamart_ETL:
ALTER PROCEDURE [dbo].[csp_CAHPSProcesses] 

*/




USE [QP_Prod]
GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'CheckForCASurveyIncompletes')
	DROP PROCEDURE dbo.CheckForCASurveyIncompletes
GO


/****** Object:  StoredProcedure [dbo].[CheckForCASurveyIncompletes]    Script Date: 4/13/2015 10:12:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CheckForCASurveyIncompletes]
AS
-- =============================================
-- Author:	Tim Butler
-- Procedure Name: CheckForSurveyIncompletes 
-- Create date: 04/2015 
-- Description:	Stored Procedure that extracts question form data from QP_Prod  -- based on CheckForCAHPSIncompletes
--              Create for Sprint 22, User Story 8  -- CIHI Completeness:  Return must have >= 50% of ATA questions answered to be considered complete for CIHI
-- History: 1.0  04/2015  by Tim Butler

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
-- list of everybody who returned an CIHI CPES-IC survey today
select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
, scm.*, qf.QuestionForm_id, sm.datExpire, convert(varchar(16),'') as DispositionAction
, qf.ReceiptType_id, ms.strMailingStep_nm, qf.bitComplete, 0 as bitETLThisReturn, 0 as bitContinueWithMailings
, sstx.Subtype_id, sstx.Subtype_nm	
into #TodaysReturns
from CTE_Returns eq
inner join QuestionForm qf on qf.QuestionForm_id=eq.PKey1 
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm from [dbo].[SurveySubtype] sst INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)) sstx on sstx.Survey_id = qf.SURVEY_ID 
inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
where qf.datResultsImported is not null
and st.Surveytype_dsc in ('CIHI CPES-IC')
and sm.datExpire > getdate()
order by qf.datResultsImported desc


	-- CIHI processing
	select Surveytype_dsc, survey_id, questionform_id, sentmail_id, samplepop_id, receipttype_id, strMailingStep_nm, 0 as ResponseCount, 0 as FutureScheduledMailing, 1 as AllMailStepsAreBack
	into #QFResponseCount
	from #TodaysReturns
	where Surveytype_dsc in ('CIHI CPES-IC')

	exec dbo.QFResponseCount

	update #todaysreturns  
	set bitETLThisReturn=1, bitComplete=1, bitContinueWithMailings=0
	where surveytype_dsc in ('CIHI CPES-IC') 

	update tr 
	set bitETLThisReturn=0, bitComplete=0, bitContinueWithMailings= case when rc.strMailingStep_nm = '1st Survey' then 1 else 0 end
	-- select tr.questionform_id, tr.surveytype_dsc, rc.ResponseCount, tr.bitETLThisReturn, tr.bitComplete, tr.bitContinueWithMailings, rc.strMailingStep_nm
	from #todaysreturns tr
	inner join #QFresponsecount rc on tr.questionform_id=rc.questionform_id
	where tr.surveytype_dsc in ('CIHI CPES-IC') 
	and rc.ResponseCount=0

	update tr
			set bitComplete=case when ATACnt>=14 then 1 else 0 end
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
						where sq.qstncore in (
												51377
												,51378
												,51379
												,51380
												,51381
												,51382
												,51383
												,51384
												,51385
												,51386
												,51388
												,51391
												,51394
												,51397
												,51399
												,51406
												,51407
												,51408
												,51409
												,51410
												,51411
												,51412
												,51413
												,51414
												,51415
												,51416
												,51417
												)
						and sq.subtype = 1 
						AND sq.language = 1 
						AND ss.language = 1 
						group by qr.questionform_id) rc
					on tr.questionform_id=rc.questionform_id
			where tr.Surveytype_dsc = 'CIHI CPES-IC'


	--insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
	--select sentmail_id, samplepop_id, 25, receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
	----, strMailingStep_nm, ResponseCount
	--from #qfResponseCount rc
	--where strMailingStep_nm='1st Survey'
	--and ResponseCount=0

	--insert into dispositionlog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
	--select sentmail_id, samplepop_id, 26, receipttype_id, getdate(), 'CheckForCAHPSIncompletes'
	----, strMailingStep_nm, ResponseCount
	--from #qfResponseCount rc
	--where strMailingStep_nm='2nd Survey'
	--and ResponseCount=0


-- for complete surveys, set QuestionForm.bitComplete=1
update qf 
set bitComplete = tr.bitComplete
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id

-- Leaving all the rest of this stuff (from CheckFORCAHPSIncompletes) if it's needed down the road.


---- for blank/incomplete or partial Surveys, set bitComplete=0, move datReturned to datUnusedReturn, blank out datResultsImported,
---- and set UnusedReturn_id=5, which means a partial return that isn't used for now (it might be used later if it ends up being the only return we ever get)
---- fyi: UnusedReturn_id=6 means a partial return whose fate we have decided (either we ignored it because a better return came in or we used it because it's the best we got.)
--update qf 
--set bitComplete = 0, datReturned=null, UnusedReturn_id=5, datUnusedReturn=qf.datReturned, datResultsImported = NULL
---- select qf.QuestionForm_id, tr.bitETLThisReturn, qf.bitComplete, qf.datReturned, qf.UnusedReturn_id, qf.datUnusedReturn, qf.datResultsImported 
--from #TodaysReturns tr
--inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
--where bitETLThisReturn=0

---- move blank/incomplete and partial results into QuestionResult2
--insert into QuestionResult2 (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
--select qr.QuestionForm_ID,qr.SampleUnit_ID,qr.QstnCore,qr.intResponseVal
--from QuestionResult qr
--inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
--where bitETLThisReturn=0

---- delete blank/incomplete and partial results from QuestionResult
--delete qr
---- select qr.*, tr.bitETLThisReturn
--from QuestionResult qr
--inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
--where bitETLThisReturn=0

---- remove blank/incomplete and partial Surveys from the ETL queue
--delete qre
---- select qre.*, tr.bitETLThisReturn
--from QuestionForm_extract qre
--inner join #TodaysReturns tr on qre.QuestionForm_id=tr.QuestionForm_id
--where bitETLThisReturn=0


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

---- remove anybody who has one of the following Dispositions
--update tr 
--set bitContinueWithMailings=0
---- select tr.SamplePop_id, dl.Disposition_id, tr.bitContinueWithMailings
--from #TodaysReturns tr
--inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
--inner join Disposition d on dl.Disposition_id=d.Disposition_id
--where dl.Disposition_id in (
--		  2 --	I do not wish to participate in this Survey
--		, 3 --	The intended respondent has passed on
--		, 4 --	The intended respondent is incapacitated and cannot participate in this Survey
--		, 8 --	The Survey is not applicable to me
--		,10--	Language Barrier
--		,24 --	The intended respondent is institutionalized
--		)

---- identify respondents who have Methodology-specific Dispositions
--update tr set DispositionAction='No Mail '
---- select tr.SamplePop_id, dl.Disposition_id, tr.DispositionAction
--from #TodaysReturns tr
--inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
--inner join Disposition d on dl.Disposition_id=d.Disposition_id
--where dl.Disposition_id=5 --	The intended respondent is not at this address

--update tr set DispositionAction=DispositionAction+'No Phone'
---- select tr.SamplePop_id, dl.Disposition_id, tr.DispositionAction
--from #TodaysReturns tr
--inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
--inner join Disposition d on dl.Disposition_id=d.Disposition_id
--where dl.Disposition_id in ( 14 --	The intended respondent is not at this phone
--							,16 --	Bad/Missing/Wrong phone number
--							)

---- grab mailing step info 
--select distinct mm.Methodology_id, ms.intSequence, ms.MailingStep_id, ms.intIntervalDays, msm.MailingStepMethod_nm
--into #ms
--from mailingMethodology mm
--inner join MailingStep ms on mm.Methodology_id=ms.Methodology_id
--inner join MailingStepMethod msm on ms.MailingStepMethod_id=msm.MailingStepMethod_id
--inner join #TodaysReturns tr on mm.Methodology_id=tr.Methodology_id
--where tr.bitContinueWithMailings=1
--order by 1,2

--declare @maxint int
--set @maxint = 2147483647
--insert into #ms 
--select Methodology_id, max(intSequence)+1,@maxint,-1,'<no next step>'
--from #ms 
--group by Methodology_id

---- delete from #TodaysReturns where the next mailing has already been generated.
--while @@rowcount>0
--	update tr
--	set intSequence=ms.intSequence
--		, MailingStep_id=ms.MailingStep_id
--		,ScheduledMailing_id=scm.ScheduledMailing_id
--		,SentMail_id=scm.SentMail_id
--		,datGenerate=scm.datGenerate
--		,QuestionForm_id=0
--	from #TodaysReturns tr
--	inner join ScheduledMailing scm on tr.SamplePop_id=scm.SamplePop_id
--	inner join MailingStep ms on scm.MailingStep_id=ms.MailingStep_id
--	where tr.intSequence+1 = ms.intSequence
--	and bitContinueWithMailings=1

--update tr
--set bitContinueWithMailings=0 
---- select tr.MailingStep_id, tr.bitContinueWithMailings
--from #TodaysReturns tr 
--where tr.MailingStep_id=@maxint 

---- list of ScheduledMailing records that need to be re-created
--select ms.MailingStep_id, tr.SamplePop_id, null as OverrideItem_id, NULL as SentMail_id, tr.Methodology_id, convert(datetime,null) as datGenerate, ms.intSequence, ms.intIntervalDays, tr.DispositionAction
----, tr.*, ms.intSequence, ms.STRMailingStep_NM
--into #NewScheduledMailing 
--from #TodaysReturns tr
--inner join #ms ms on tr.Methodology_id=ms.Methodology_id and tr.intSequence=ms.intSequence-1
--where ms.Mailingstep_id <> @maxint
--and bitContinueWithMailings=1
--order by tr.SamplePop_id, ms.intSequence

---- remove respondents with Methodology-specific Dispositions
--delete nsm
---- select nsm.*
--from #NewScheduledMailing nsm
--inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
--where nsm.DispositionAction like '%No Mail%'
--and ms.MailingStepMethod_nm='Mail'

--delete nsm
---- select nsm.*
--from #NewScheduledMailing nsm
--inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
--where nsm.DispositionAction like '%No Phone%'
--and ms.MailingStepMethod_nm='Phone'

--update nsm set datGenerate=dateadd(day,nsm.intIntervalDays,convert(datetime,floor(convert(float,sm.datMailed))))
----select scm.SamplePop_id, scm.MailingStep_id, scm.SentMail_id, ms.intSequence, nsm.intSequence, nsm.datGenerate, dateadd(day,nsm.intIntervalDays,convert(datetime,floor(convert(float,sm.datMailed))))
--from #NewScheduledMailing nsm
--inner join ScheduledMailing scm on nsm.SamplePop_id=scm.SamplePop_id 
--inner join #ms ms on scm.MailingStep_id=ms.MailingStep_id
--inner join SentMailing sm on scm.SentMail_id=sm.SentMail_id
--where ms.intSequence=nsm.intSequence-1

---- if the previous MailingStep hasn't mailed yet, the next mailing step will be scheduled when it mails, so we don't have to do anything
--delete #NewScheduledMailing where datGenerate is NULL 

---- anything that should have already generated, generate it tonight.
---- it should be within the last few days? should we check that it's not older than that?
--update #NewScheduledMailing 
--set datGenerate = convert(datetime,ceiling(convert(float,getdate()))) 
--where datGenerate<getdate()

--insert into ScheduledMailing (OverrideItem_id, Methodology_ID, MailingStep_ID, SamplePop_ID, SentMail_ID, datGenerate)
--select OverrideItem_id, Methodology_ID, MailingStep_ID, SamplePop_ID, SentMail_ID, datGenerate
--from #NewScheduledMailing

--drop table #NewScheduledMailing
--drop table #ms
drop table #TodaysReturns

drop table #qfResponseCount 

GO

USE [NRC_DataMart_ETL]

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'csp_CAHPSProcesses')
	DROP PROCEDURE dbo.csp_CAHPSProcesses

GO
/****** Object:  StoredProcedure [dbo].[csp_CAHPSProcesses]    Script Date: 4/13/2015 10:06:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_CAHPSProcesses] 
AS
-- this code was previously in NRC_Datamart_ETL.dbo.csp_CAHPSProcesses. We're putting it in its own proc so that 
-- it can be called at the beginning of the ETL, instead of in the middle.

	DECLARE @country VARCHAR(10)
	SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	select @country
	IF @country = 'US'
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
		EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
		EXEC [QP_Prod].[dbo].[CheckHospiceCAHPSDispositions]
	END
	ELSE if @country = 'CA' 
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForCASurveyIncompletes] 
	END
GO

