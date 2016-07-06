/*
S52 ATL-537 OAS Submission support
ATL-539 Investigate records with improper dispositions

Dave Gilsdorf

QP_Prod
alter procedure CheckForMostCompleteUsablePartials

*/
use qp_prod
go
alter PROCEDURE [dbo].[CheckForMostCompleteUsablePartials]
as
-- created 12/23/2014 DBG
-- After HHCAHPS and ICHCAHPS Surveys expire, we want to see if there were any returns that we initially ignored because there was still outstanding surveys.
-- If so, and no other MailingSteps resulted in a complete Survey, we want to go ahead and use the return.

-- list of all the returned QuestionForm records for SamplePop's that have at least one unused return (unusedreturn_id=5)
-- and the sampleset has expired.

/*
	S41 US21     01/22/106 T.Butler  OAS: Keep Most Complete Return - As an authorized OAS CAHPS vendor, we need to keep the most complete return when two returns are received, so that we comply protocols 
*/


select qf.SamplePop_id, qf.QuestionForm_id, qf.datReturned, qf.unusedreturn_id, qf.datUnusedReturn, 0 as bitUse, 0 as numResponses
, sstx.Subtype_id, sstx.Subtype_nm, sd.survey_id, sd.surveytype_id, 0 as bitComplete, sp.sampleset_id
into #partials
from QuestionForm qf
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join samplepop sp on qf.samplepop_id=sp.samplepop_id
inner join survey_def sd on qf.survey_id=sd.survey_id
left join (	SELECT sst.survey_id, sst.subtype_id, st.subtype_nm 
			FROM [dbo].[surveysubtype] sst 
			INNER JOIN [dbo].[subtype] st ON st.subtype_id = sst.subtype_id) sstx 
		on sstx.Survey_id = qf.SURVEY_ID --> new: 1.6
where qf.SamplePop_id in (select SamplePop_id from QuestionForm where unusedreturn_id=5)
and (qf.datReturned is not null or unusedreturn_id=5)
and sd.Surveytype_id in (3, 8, 16) -- HH CAHPS and ICHCAHPS and OAS 
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
select sampleset_id, samplepop_id, questionform_id, datUnusedReturn, 0 as responsecount, survey_id
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
and qf.datUnusedReturn is not null --> S41 US21     01/22/106 T.Butler 

if @@rowcount>0
begin
	update p
	set bitComplete=case when ATACnt>=19 then 1 else 0 end
	from #partials p
	inner join (select qr.questionform_id, count(distinct sq.qstncore) as ATACnt
				from (	select rc.sampleset_id, rc.questionform_id, rc.survey_id, qr.qstncore, qr.intResponseVal
						from #qfResponseCount rc
						inner join questionresult qr on rc.questionform_id=qr.questionform_id
						union
						select rc.sampleset_id, rc.questionform_id, rc.survey_id, qr2.qstncore, qr2.intResponseVal
						from #qfResponseCount rc
						inner join questionresult2 qr2 on rc.questionform_id=qr2.questionform_id) qr
				inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
				inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
				where sq.qstncore in (51198,51199,47159,47160,47161,47162,47163,47164,47165,47166,47167,47168,47169,47170,47171,47172,47173,47174,47175,
										47176,47178,47179,47181,47182,47183,47184,47185,47186,47187,47188,47189,47190,47191,47192,47193,47195,47196,47197)
				and sq.subtype = 1 
				AND sq.language = 1 
				AND ss.language = 1 
				group by qr.questionform_id) rc
			on p.questionform_id=rc.questionform_id
	where p.Surveytype_id in (8) -- ICHCAHPS

	update p
	set bitComplete=case when ATACnt>9 then 1 else 0 end
	from #partials p
	inner join (select qr.questionform_id, count(distinct sq.qstncore) as ATACnt
				from (	select rc.sampleset_id, rc.questionform_id, rc.survey_id, qr.qstncore, qr.intResponseVal
						from #qfResponseCount rc
						inner join questionresult qr on rc.questionform_id=qr.questionform_id
						union
						select rc.sampleset_id, rc.questionform_id, rc.survey_id, qr2.qstncore, qr2.intResponseVal
						from #qfResponseCount rc
						inner join questionresult2 qr2 on rc.questionform_id=qr2.questionform_id) qr
				inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
				inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
				where sq.qstncore in (38694,38695,38696,38697,38698,38699,38700,38701,38702,38703,38704,38708,38709,38710,38711,38712,38713,38714,38717,38718)
				and sq.subtype = 1 
				AND sq.language = 1 
				AND ss.language = 1 
				group by qr.questionform_id) rc
			on p.questionform_id=rc.questionform_id
	where p.Surveytype_id in (3) -- Home Health CAHPS

	-- New: S41 US21     01/22/106 T.Butler
	update p
	set bitComplete=case when (cast(ATACnt as float)/cast(22 as float)) * 100 >= 50 then 1 else 0 end
	from #partials p
	inner join (select qr.questionform_id, count(distinct sq.qstncore) as ATACnt
				from (	select rc.sampleset_id, rc.questionform_id, rc.survey_id, qr.qstncore, qr.intResponseVal
						from #qfResponseCount rc
						inner join questionresult qr on rc.questionform_id=qr.questionform_id
						union
						select rc.sampleset_id, rc.questionform_id, rc.survey_id, qr2.qstncore, qr2.intResponseVal
						from #qfResponseCount rc
						inner join questionresult2 qr2 on rc.questionform_id=qr2.questionform_id) qr
				inner join DL_SEL_QSTNS_BySampleSet sq on qr.survey_id = sq.survey_id and qr.qstncore = sq.qstncore and qr.sampleset_id=sq.SampleSet_ID
				inner join DL_SEL_SCLS_BySampleSet ss on sq.scaleid = ss.qpc_id AND sq.survey_id = ss.survey_id and qr.intresponseval = ss.val and sq.SampleSet_ID=ss.Sampleset_ID
				where sq.qstncore in (54086,54087,54088,54089,54090,54091,54092,54093,54094,54095,54098,54099,54100,
									    54101,54102,54103,54104,54105,54106,54107,54108,54109)
				and sq.subtype = 1 
				AND sq.language = 1 
				AND ss.language = 1 
				group by qr.questionform_id) rc
			on p.questionform_id=rc.questionform_id
	where p.Surveytype_id in (16) -- OAS CAHPS 

	update qf 
	set bitComplete = p.bitComplete
	from QuestionForm qf
	inner join #partials p on qf.QuestionForm_id=p.QuestionForm_id
	where p.unusedreturn_id=5
	and p.bitUse=1
end

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