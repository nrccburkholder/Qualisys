use nrc_datamart_etl
go
-- =============================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetQuestionFormExtractData
-- Create date: 3/01/2009 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 modifed logic to handle DatUndeliverable changes
--			1.2 by ccaouette: ACO CAHPS Project
-- =============================================
alter PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 
	@ExtractFileID int 
	
--exec [dbo].[csp_GetQuestionFormExtractData]  2238
AS
	SET NOCOUNT ON 

	declare @EntityTypeID int
	set @EntityTypeID = 11 -- QuestionForm
--
 --   declare @ExtractFileID int
	--set @ExtractFileID = 539 -- 

	---------------------------------------------------------------------------------------
	-- ACO CAHPS Project
	-- ccaouette: 2014-05
	---------------------------------------------------------------------------------------
	DECLARE @country VARCHAR(10)
	SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	select @country
	IF @country = 'US'
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
	END
	

	---------------------------------------------------------------------------------------
	-- Load records to Insert/Update into a temp table
	-- Changed 2009.11.09 to handle surveytypeid = 3 surveys by kmn
	---------------------------------------------------------------------------------------

	-- clean up any records that might be in the tables already
	delete QuestionFormTemp where ExtractFileID = @ExtractFileID

	insert QuestionFormTemp 
			(ExtractFileID, QUESTIONFORM_ID, SURVEY_ID,SurveyType_id,SAMPLEPOP_ID,strLithoCode, isComplete, ReceiptType_id
             , returnDate, DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,IsDeleted)
		select distinct @ExtractFileID, qf.QUESTIONFORM_ID, qf.SURVEY_ID,sd.SurveyType_id, qf.SAMPLEPOP_ID,sm.strLithoCode, 
			   case when qf.bitComplete <> 0 then 'true' else 'false' end, 
			   qf.ReceiptType_id,qf.datReturned , sm.DatMailed, sm.DatExpire, sm.DatGenerated, sm.DatPrinted, sm.DatBundled, sm.DatUndeliverable,0
  --      select *
		 from (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh
				inner join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1
               	inner join QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
                inner join QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = qf.SAMPLEPOP_ID	
                inner join QP_Prod.dbo.Survey_def sd With (NOLOCK) on qf.SURVEY_ID = sd.SURVEY_ID
                left join SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     and sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
	    where (qf.DATRETURNED is not null OR sm.DatUndeliverable is not NULL ) 
	           and sp.POP_ID > 0
	           and sst.sampleset_id is NULL --excludes questionforms/sample pops that will be deleted due to sampleset deletes
	    
---------------------------------------------------------------------------------------	    
-- Add code to determine days from first mailing as well as days from current mailing until the return    
-- Get all of the maildates for the samplepops were are extracting    
---------------------------------------------------------------------------------------
	SELECT e.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed    
	INTO #Mail    
	FROM (SELECT SamplePop_id FROM QuestionFormTemp WITH (NOLOCK) WHERE ExtractFileID = @ExtractFileID GROUP BY SamplePop_id) e
	INNER JOIN QP_Prod.dbo.ScheduledMailing schm WITH (NOLOCK) ON e.SamplePop_id=schm.SamplePop_id  
	INNER JOIN QP_Prod.dbo.SentMailing sm WITH (NOLOCK) ON schm.SentMail_id=sm.SentMail_id  


	-- Update the work table with the actual number of days    
	UPDATE QuestionFormTemp
	SET datFirstMailed = FirstMail.datMailed
	,DaysFromFirstMailing=DATEDIFF(DAY,FirstMail.datMailed,returnDate)
	,DaysFromCurrentMailing=DATEDIFF(DAY,CurrentMail.datMailed,returnDate)  
	--SELECT *  
	FROM QuestionFormTemp qftemp WITH (NOLOCK)     
	INNER JOIN  (SELECT SamplePop_id, MIN(datMailed) datMailed FROM #Mail GROUP BY SamplePop_id) FirstMail ON qftemp.SamplePop_id=FirstMail.SamplePop_id  
	INNER JOIN #Mail CurrentMail ON qftemp.SamplePop_id = CurrentMail.SamplePop_id AND qftemp.strLithoCode=CurrentMail.strLithoCode      
	WHERE qftemp.ExtractFileID = @ExtractFileID 

	drop table #Mail  
	
	-- Make sure there are no negative days.    
	UPDATE QuestionFormTemp
	SET DaysFromFirstMailing = 0 
	--SELECT *  
	FROM QuestionFormTemp WITH (NOLOCK)  
	WHERE DaysFromFirstMailing < 0 AND ExtractFileID = @ExtractFileID 

	UPDATE QuestionFormTemp
	SET DaysFromCurrentMailing = 0 
	--SELECT *  
	FROM QuestionFormTemp WITH (NOLOCK)  
	WHERE DaysFromCurrentMailing < 0 AND ExtractFileID = @ExtractFileID    
  
 ---------------------------------------------------------------------------------------
 -- Update bitComplete flag for HCACHPS seurveys
 ---------------------------------------------------------------------------------------
	UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=2
    
    UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.HHCAHPSCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=3
    
    UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.MNCMCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=4

 ---------------------------------------------------------------------------------------
 -- Load records to deletes into a temp table
  ---------------------------------------------------------------------------------------
 insert QuestionFormTemp 
			(ExtractFileID, QUESTIONFORM_ID, SAMPLEPOP_ID,strLithoCode,IsDeleted )
		select distinct @ExtractFileID, IsNull(qf.QUESTIONFORM_ID,-1), IsNull(qf.SAMPLEPOP_ID,-1),IsNull(IsNull(eh.PKey2,sm.strLithoCode),-1),1 
  --      select *
		 from (select distinct PKey1 ,PKey2
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 1 ) eh
				Left join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1 AND qf.DATRETURNED IS NULL--if datReturned is not NULL it is not a delete
				Left join QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
go
use qp_Prod
go
drop procedure [dbo].[QFResponseCount]
drop procedure [dbo].[CheckForCAHPSIncompletes]
go
CREATE PROCEDURE [dbo].[CheckForACOCAHPSIncompletes]
AS
-- =============================================
-- Author:	Dave Gilsdorf
-- Procedure Name: CheckForACOCAHPSIncompletes
-- Create date: 1/2014 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  1/2014  by Dave Gilsdorf
--			1.1  5/27/2014 by C Caouette: Integrate logic into Catalyst ETL.
--          1.2  6/18/2014 by D Gilsdorf: Refactored ACOCAHPSCompleteness as a procedure instead of a function.
-- =============================================


/* PART 1 -- find people who are going through the ETL tonight and check their completeness. If their survey was partial or incomplete, reschedule their next mailstep. */

DECLARE @MinDate DATE;
SET @MinDate = DATEADD(DAY, -2, GETDATE());


-- v1.1  5/27/2014 by C Caouette
WITH CTE_Returns AS
(
	SELECT DISTINCT PKey1 
	FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
	WHERE eq.ExtractFileID IS NULL AND eq.EntityTypeID = 11 AND eq.Created > @MinDate
)

--SELECT * FROM CTE_Returns
-- list of everybody who returned an ACOCAHPS Survey today
select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
, scm.*, qf.QuestionForm_id, sm.datExpire, convert(tinyint,null) as ACODisposition, convert(varchar(15),'') as DispositionAction
into #TodaysReturns
from CTE_Returns eq
inner join QuestionForm qf on qf.QuestionForm_id=eq.PKey1 
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
where qf.datResultsImported is not null
and st.Surveytype_dsc='ACOCAHPS'
and sm.datExpire > getdate()
order by qf.datResultsImported desc

select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
into #ACOQF
from #TodaysReturns

exec dbo.ACOCAHPSCompleteness

update tr
set ACODisposition=qf.disposition
from #TodaysReturns tr
inner join #ACOQF qf on tr.questionform_id=qf.questionform_id

--select * from #todaysreturns
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete

-- for complete survyes, set QuestionForm.bitComplete=1
update qf 
set bitComplete = 1
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where ACODisposition = 10 

-- for blank/incomplete or partial Surveys, set bitComplete=0, move datReturned to datUnusedReturn, blank out datResultsImported,
-- and set UnusedReturn_id=5, which means a partial return that isn't used for now (it might be used later if it ends up being the only return we ever get)
-- fyi: UnusedReturn_id=6 means a partial return whose fate we have decided (either we ignored it because a better return came in or we used it because it's the best we got.)
update qf 
set bitComplete = 0, datReturned=null, UnusedReturn_id=5, datUnusedReturn=qf.datReturned, datResultsImported = NULL
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

-- move blank/incomplete and partial results into QuestionResult2
insert into QuestionResult2 (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select qr.QuestionForm_ID,qr.SampleUnit_ID,qr.QstnCore,qr.intResponseVal
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

-- delete blank/incomplete and partial results from QuestionResult
delete qr
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

-- remove blank/incomplete and partial Surveys from the ETL queue
delete qre
from QuestionForm_extract qre
inner join #TodaysReturns tr on qre.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

/* ----------------------------------------------------------------------------------------
--	v1.1  5/2014 by C Caouette:	Modified to logically remove partial and incomplete questionforms from
								the Catalyst ExtractQueue table. 
 ---------------------------------------------------------------------------------------- */
--UPDATE eq
--SET ExtractFileID = -1
----DELETE eq
----SELECT *
--FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
--	INNER JOIN #TodaysReturns tr ON eq.PKey1=tr.QuestionForm_id AND eq.EntityTypeID = 11 AND eq.ExtractFileID IS NULL
--WHERE ACODisposition <> 10 

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


delete from #TodaysReturns where ACODisposition = 10 

-- remove anybody who has one of the following Dispositions
delete tr
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
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id=5 --	The intended respondent is not at this address

update tr set DispositionAction=DispositionAction+'No Phone'
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

delete from #TodaysReturns where MailingStep_id=@maxint

-- list of ScheduledMailing records that need to be re-created
select ms.MailingStep_id, tr.SamplePop_id, null as OverrideItem_id, NULL as SentMail_id, tr.Methodology_id, convert(datetime,null) as datGenerate, ms.intSequence, ms.intIntervalDays, tr.DispositionAction
--, tr.*, ms.intSequence, ms.STRMailingStep_NM
into #NewScheduledMailing 
from #TodaysReturns tr
inner join #ms ms on tr.Methodology_id=ms.Methodology_id and tr.intSequence=ms.intSequence-1
where ms.Mailingstep_id <> @maxint
order by tr.SamplePop_id, ms.intSequence

-- remove respondents with Methodology-specific Dispositions
delete nsm
from #NewScheduledMailing nsm
inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
where nsm.DispositionAction like '%No Mail%'
and ms.MailingStepMethod_nm='Mail'

delete nsm
from #NewScheduledMailing nsm
inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
where nsm.DispositionAction like '%No Phone%'
and ms.MailingStepMethod_nm='Phone'

update nsm set datGenerate=dateadd(day,nsm.intIntervalDays,convert(datetime,floor(convert(float,sm.datMailed))))
--select scm.*, ms.*, sm.datMailed, nsm.intIntervalDays, dateadd(day,nsm.intIntervalDays,sm.datMailed)
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
go