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