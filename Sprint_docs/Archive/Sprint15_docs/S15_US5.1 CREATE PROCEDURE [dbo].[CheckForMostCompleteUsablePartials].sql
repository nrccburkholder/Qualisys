/*
S15.US5	HHCAHPS Keep Most Complete Return
	As an Authorized Vendor, we want to keep results from the most complete questionnaire when more than one is received for HHCAHPS, so that we follow protocols

T15.1	Audit the code to see that it complies with the information in Dana's grid

Dave Gilsdorf

CREATE PROCEDURE [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] 
ALTER PROCEDURE [NRC_DataMart_ETL].[dbo].[csp_GetQuestionFormExtractData] 
*/
use qp_prod
go
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.procedures st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'DBO' and st.name=N'CheckForMostCompleteUsablePartials') 
	DROP PROCEDURE [dbo].[CheckForMostCompleteUsablePartials]
go
CREATE PROCEDURE [dbo].[CheckForMostCompleteUsablePartials]
as
-- created 12/23/2014 DBG
-- After HHCAHPS and ICHCAHPS Surveys expire, we want to see if there were any returns that we initially ignored because there was still outstanding surveys.
-- If so, and no other MailingSteps resulted in a complete Survey, we want to go ahead and use the return.

-- list of all the returned QuestionForm records for SamplePop's that have at least one unused return (unusedreturn_id=5)
-- and the sampleset has expired.


select qf.SamplePop_id, qf.QuestionForm_id, qf.datReturned, qf.unusedreturn_id, qf.datUnusedReturn, 0 as bitUse, 0 as numResponses
, sstx.Subtype_id, sstx.Subtype_nm
into #partials
from QuestionForm qf
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join survey_def sd on qf.survey_id=sd.survey_id
left join (	SELECT sst.survey_id, sst.subtype_id, st.subtype_nm 
			FROM [dbo].[surveysubtype] sst 
			INNER JOIN [dbo].[subtype] st ON st.subtype_id = sst.subtype_id) sstx 
		on sstx.Survey_id = qf.SURVEY_ID --> new: 1.6
where qf.SamplePop_id in (select SamplePop_id from QuestionForm where unusedreturn_id=5)
and (qf.datReturned is not null or unusedreturn_id=5)
and sd.Surveytype_id in (3, 8) -- HH CAHPS and ICHCAHPS
and isnull(sm.datexpire,getdate())<getdate()

if @@rowcount=0
	RETURN


-- if there's any other MailingStep with unusedreturn_id<>5 and datReturned is not NULL, we're not going to use unused return because some other return has already been used
update questionform 
set unusedreturn_id=6
where samplepop_id in (select samplepop_id from #partials where datReturned is not null)
and unusedreturn_id=5

delete from #partials
where samplepop_id in (select samplepop_id from #partials where datReturned is not null)

if not exists (select * from #partials)
	return

-- if the unused return was the only return we got, go ahead and use it.
update #partials
set bituse=1
where samplepop_id in (select samplepop_id from #partials group by samplepop_id having count(*)=1)


-- if there are two unused returns, use the one with the most responses
select samplepop_id, questionform_id, datUnusedReturn, 0 as responsecount
into #QFResponseCount
from #partials
where samplepop_id in (select samplepop_id from #partials group by samplepop_id having count(*)>1)

exec dbo.QFResponseCount

update p
set numResponses=rc.ResponseCount
from #partials p
inner join #qfResponseCount rc on p.questionform_id=rc.questionform_id

update p
set bitUse=1
from #partials p
inner join (select samplepop_id, max(responsecount) as mostResponses 
			from #qfResponseCount 
			group by samplepop_id) best
on p.samplepop_id=best.samplepop_id
and p.numResponses = best.mostResponses

-- if there's more than one return for a samplepop with bitUse=1, that means both returns had the same number of responses. 
-- We want to use the first one returned.
update p
set bitUse=0
-- select *
from #partials p
inner join (select samplepop_id, min(datUnusedReturn) as firstReturn
			from #partials p
			where bituse=1
			group by samplepop_id
			having count(*)>1) frst
on p.samplepop_id=frst.samplepop_id
and p.datUnusedReturn > firstReturn

-- if there's STILL more than one return for a samplepop with bitUse=1, that means both returns had the same number of responses and were returned at the same date/time
-- At this point, just use one.
update p
set bitUse=0
from #partials p
inner join (select samplepop_id, min(questionform_id) as oneOfTheQuestionform_ids
			from #partials p
			where bituse=1
			group by samplepop_id
			having count(*)>1) qf
on p.samplepop_id=qf.samplepop_id
and p.questionform_id = qf.oneOfTheQuestionform_ids



-- update unusedreturn_id=6 for returns that we're not going to use
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

drop table #partials
drop table #QFResponseCount
go
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
--          1.3 by dgilsdorf: CheckForACOCAHPSIncompletes changed to CheckForCAHPSIncompletes
--          1.4 by dgilsdorf: added call to CheckForMostCompleteUsablePartials for HHCAHPS and ICHCAHPS processing
-- =============================================
ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 
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
		EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
		EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
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
