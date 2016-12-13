use QP_Prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_Question')
	drop procedure CIHI.PullSubmissionData_Question
go
CREATE PROCEDURE CIHI.PullSubmissionData_Question
@SubmissionID int
AS
BEGIN

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
	
	-- delete responses from surveys where no CIHI questions were answered (if max(intresponseval) < 0 ==> no questions were answered)
	delete 
	from cihi.qa_question
	where submissionID=@submissionID
	and samplepopid in (select samplepopid
						from cihi.qa_question
						where submissionid=@submissionID
						and qstncore in (select distinct qstncore from cihi.recode where QATable = 'QA_Question' and qaField='intResponseVal')
						group by samplepopid
						having max(intresponseval) < 0 )

	/*  we DON'T want to change nonResponseCount. a non-Response is someone who we didn't hear from at all.
	-- increment nonResponseCount by the number of deleted surveys
	update qc set nonResponseCount = nonResponseCount + numDeleted
	from cihi.QA_QuestionnaireCycleAndStratum qc
	join (	select sampleunitid,count(*) as numDeleted
			from cihi.qa_questionnaire 
			where submissionID=@submissionID
			and samplepopid not in (select samplepopid from cihi.qa_question)
			group by sampleunitid) d
		on qc.sampleunitid=d.sampleunitid
	where qc.submissionID=@submissionID
	*/

	-- delete those who returned blank surveys from QA_Questionnaire 
	delete
	from cihi.qa_questionnaire 
	where submissionID=@submissionID
	and samplepopid not in (select samplepopid from cihi.qa_question where submissionid=@submissionid)
	
	-- add a -9 response to any respondant who didn't answer a multiple response question
	declare @sql varchar(max) = ''
	
	select @sql = @sql + '
	insert into cihi.qa_question (SubmissionID, samplepopid, qstncore, intresponseval)
	select distinct '+convert(varchar,@submissionID)+' as submissionID, samplepopid, '+convert(varchar,qstncore)+', -9
	from cihi.qa_question qq
	where submissionID='+convert(varchar,@submissionID)+'
	and samplepopid not in (select distinct qq.samplepopid 
							from cihi.qa_question qq
							where qq.qstncore='+convert(varchar,qstncore)+'
							and submissionid='+convert(varchar,@submissionID)+')'
	from (select distinct qq.qstncore
		from cihi.qa_question qq
		join samplepop sp on qq.samplePopID=sp.SAMPLEPOP_ID
		join DL_SEL_QSTNS_BySampleSet sq on sp.sampleset_id=sq.sampleset_id and qq.qstncore=sq.QSTNCORE
		where sq.numMarkCount = 2
		and qq.qstncore in (select distinct qstncore from cihi.recode where QATable = 'QA_Question' and qaField='intResponseVal')
		and qq.submissionID = @submissionID) MR
	exec (@sql)

	
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
	where qf.datReturned is not null and cq.submissionID = @SubmissionID

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

	update cq
	set cq.intResponseVal = -4
	from CIHI.QA_Question cq
	join #cihiInvokedGate cg
		on cq.samplepopID = cg.samplePopID and cq.qstnCore = cg.SkipQstn
	where
		cq.intResponseVal = -9 or cq.intResponseVal = -8
		and cq.submissionID = @SubmissionID

	drop table #surveyInfo
	drop table #cihiInvokedGate

END