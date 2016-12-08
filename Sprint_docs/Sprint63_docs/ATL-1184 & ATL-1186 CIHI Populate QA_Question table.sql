use QP_Prod
GO

declare @SubmissionID int = 1
insert into CIHI.QA_Question (SubmissionID, samplePopID, qstncore, intResponseVal)
(
	select distinct @SubmissionID, qf.samplepop_id, qr.QSTNCORE, qr.INTRESPONSEVAL
	from CIHI.Submission cs
	join CIHI.SubmissionSurvey css on cs.submissionID=css.submissionID
	join SAMPLESET ss on css.surveyid=ss.survey_id
	join SampleUnit su on ss.sampleplan_id=su.sampleplan_id
	join SamplePop sp on ss.sampleset_id=sp.sampleset_id
	join selectedsample sel on ss.sampleset_id = sel.sampleset_id and sp.POP_ID = sel.POP_ID and su.SAMPLEUNIT_ID = sel.SAMPLEUNIT_ID
	join questionform qf on sp.samplepop_id=qf.samplepop_id
	join questionResult qr on qf.QUESTIONFORM_ID=qr.QUESTIONFORM_ID
	where cs.SubmissionID=@SubmissionID
	and su.CahpsType_id=12
	and ss.datDateRange_FromDate>=cs.EncounterDateStart and ss.datDateRange_ToDate<=cs.EncounterDateEnd
	and qf.datreturned is not null
	and sel.strunitselecttype = 'D'
)

GO

--if gate is answered in a way where child should be skipped, if that child contains -8 or -9 update child response to -4

create table #surveyInfo (
	questionID		INT,
	survey_id		INT,
	intResponseVal	INT,
	qstnCore		INT,
	samplepopID		INT,
	datGenerated	DATETIME
)
insert into #surveyInfo (questionID, survey_id, intResponseVal, qstnCore, samplepopID, datGenerated) 
select cq.questionID, qf.survey_id, cq.intResponseVal, cq.qstnCore, cq.samplePopID, sm.datGenerated
from CIHI.QA_Question cq
join QuestionForm qf on cq.samplepopid = qf.samplepop_id
join sentmailing sm on qf.sentmail_id = sm.sentmail_id
where qf.datReturned is not null

GO

--CIHI questions that are Gates
create table #cihiInvokedGate (
	GateQstn		INT,
	intResponseVal	INT,
	skipQstn		INT,
	samplePopID		INT
)
insert into #cihiInvokedGate (GateQstn, intResponseVal, skipQstn, samplePopID)
select surv.qstnCore, surv.intResponseVal, sq.QstnCore, surv.samplepopID
from #surveyInfo surv
join SkipIdentifier si on si.survey_id = surv.survey_id and si.qstnCore = surv.qstnCore and surv.intResponseVal = si.intResponseVal and si.datGenerated = surv.datGenerated
join SkipQstns sq on si.skip_id = sq.skip_id

GO

update cq
set cq.intResponseVal = -4
from CIHI.QA_Question cq
join #cihiInvokedGate cg
	on cq.samplepopID = cg.samplePopID and cq.qstnCore = cg.SkipQstn
where
	cq.intResponseVal = -9 or cq.intResponseVal = -8

GO

drop table #surveyInfo
drop table #cihiInvokedGate