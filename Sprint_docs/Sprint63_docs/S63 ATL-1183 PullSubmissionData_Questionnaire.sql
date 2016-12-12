/*

S63 ATL-1183 PullSubmissionData_Questionnaire.sql

Lanny Boswell

12/9/2016

create procedure CIHI.PullSubmissionData_Questionnaire

*/

use QP_Prod
go

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_Questionnaire')
       drop procedure CIHI.PullSubmissionData_Questionnaire
go

CREATE PROCEDURE CIHI.PullSubmissionData_Questionnaire
@SubmissionID int
AS
BEGIN

	if object_id('tempdb..#SampleSets') is not null
		drop table #SampleSets

	declare @CycleCd_dates char(9)
	select @CycleCd_dates = replace(right(convert(varchar,EncounterDateStart, 3),5),'/','') + '_' + replace(right(convert(varchar,EncounterDateEnd, 3),5),'/','')
	from CIHI.Submission cs
	where SubmissionID=@SubmissionID
	
	create table #SampleSets (
		SampleSetID int,
		StudySchema varchar(50)
	)

	insert into #SampleSets
	select distinct
		ss.SAMPLESET_ID,
		'S' + cast(sd.STUDY_ID as varchar)
	from CIHI.Submission cs
	join CIHI.SubmissionSurvey css 
		on css.submissionID = cs.submissionID
	join dbo.SURVEY_DEF sd
		on sd.Survey_ID = css.SurveyID
	join dbo.SAMPLESET ss 
		on ss.SURVEY_ID = css.SurveyID
		and ss.datDateRange_FromDate >= cs.EncounterDateStart 
		and ss.datDateRange_ToDate <= cs.EncounterDateEnd		
	where cs.SubmissionID = @SubmissionID

	declare @SampleSetID int
	declare @StudySchema varchar(50)
	declare @cmd varchar(4000)

	declare SampleSetCursor cursor for
	select SampleSetID, StudySchema from #SampleSets order by SampleSetID

	open SampleSetCursor
	fetch next from SampleSetCursor into @SampleSetID, @StudySchema

	while @@FETCH_STATUS = 0
	begin

	set @cmd = 

	'insert into CIHI.QA_Questionnaire
	(
		CycleCD,
		SubmissionID,
		SamplePopID,
		SamplesetID,
		SampleunitID,
		HCN,
		HCN_Issuer,
		CIHI_PID,
		CIHI_PIDType,
		DOB,
		EstimatedBirthCD,
		Sex,
		DischargeDate,
		CIHI_ServiceLine,
		MailingStepMethodID,
		LangID
	)
	select distinct
		left(replace(e.FacilityNum,''-'',''''),5) + ''_'+@CycleCd_dates+''',
		' + cast(@SubmissionID as varchar) + ',
		sp.samplepop_id,
		sp.sampleset_id,
		su.sampleunit_id,
		p.HCN,
		case when p.HCN is null then null else isnull(p.HCN_Issuer, ''UNK'') end,
		isnull(e.CIHI_PID, p.MRN),
		case when e.CIHI_PID is null then ''MR'' else e.CIHI_PIDType end,
		p.DOB,
		''N'',
		p.Sex,
		e.DischargeDate,
		case when e.CIHI_ServiceLine is null then ''UNK'' else e.CIHI_ServiceLine end,
		ms.MailingStepMethod_id,
		sm.[LangID]
	from dbo.SAMPLESET ss 
	join dbo.SampleUnit su 
		on ss.sampleplan_id = su.sampleplan_id
		and su.CahpsType_id = 12
	join dbo.SamplePop sp 
		on ss.sampleset_id = sp.sampleset_id
	join dbo.QuestionForm qf 
		on sp.samplepop_id = qf.samplepop_id
		and qf.datreturned is not null
	join dbo.SelectedSample sel 
		on sel.SAMPLESET_ID = ss.SAMPLESET_ID
		and sel.SAMPLEUNIT_ID = su.SAMPLEUNIT_ID
		and sel.POP_ID = sp.POP_ID
	join dbo.ScheduledMailing schm
		on schm.Samplepop_ID = sp.Samplepop_ID
	join dbo.SENTMAILING sm
		on sm.ScheduledMailing_ID = schm.SCHEDULEDMAILING_ID
		and sm.Sentmail_id = schm.Sentmail_ID
	join dbo.MAILINGSTEP ms
		on ms.Mailingstep_id = schm.MailingStep_ID
	join ' + @StudySchema + '.Population p
		on p.pop_id = sel.POP_ID
	join ' + @StudySchema + '.ENCOUNTER e
		on e.enc_id = sel.enc_id
	where sel.strUnitSelectType=''D'' and ss.SAMPLESET_ID = ' + cast(@SampleSetID as varchar)

	exec (@cmd)

	fetch next from SampleSetCursor into @SampleSetID, @StudySchema
	end
	close SampleSetCursor
	deallocate SampleSetCursor
END
