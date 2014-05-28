CREATE procedure dbo.CheckForACOCAHPSUsablePartials
as
-- created 1/30/2014 DBG
-- After ACO CAHPS Surveys expire, we want to see if there were any blank/incomplete or partial returns that we initially ignored.
-- If so, and no other MailingSteps resulted in a complete Survey, we want to go ahead and use the blank/incomplete or partial return

-- list of all the returned QuestionForm records for SamplePop's that have at least one blank/incomplete or partial return (unusedreturn_id=5)
-- and the sampleset has expired.
select qf.SamplePop_id, qf.QuestionForm_id, qf.unusedreturn_id, qf.datUnusedReturn, convert(bit,NULL) as bitUse, 0 as ACODisposition
into #partials
from QuestionForm qf
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
where qf.SamplePop_id in (select SamplePop_id from QuestionForm where unusedreturn_id=5)
and (qf.datReturned is not null or unusedreturn_id=5)
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

update #partials 
set ACODisposition=dbo.ACOCAHPSCompleteness(QuestionForm_id)
where unusedreturn_id=5
and bitUse is null
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


