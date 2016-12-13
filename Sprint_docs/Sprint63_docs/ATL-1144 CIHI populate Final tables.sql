use qp_prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'TransferToFinal_Patient')
	drop procedure CIHI.TransferToFinal_Patient
go
create procedure CIHI.TransferToFinal_Patient
@SubmissionID int
as

if not exists (select * from cihi.Submission where submissionID=@SubmissionID and SubmissionSubject='PAT')
	return

if exists (select * from CIHI.Final_Metadata where submissionID=@SubmissionID)
begin
	print 'This submission dataset has already been transfered to final'
	return
end

--declare @SubmissionID int=1
insert into CIHI.Final_Metadata ([submissionID], [creationTime_value], [sender.device.manufacturer.id.value], [sender.organization.id.value], [versionCode_code], [versionCode_codeSystem], [purpose_code], [purpose_codeSystem])
select distinct s.submissionID
	, replace(convert(varchar,s.pullDate,102),'.','') as creationTime_value
	, s.DeviceManufacturer as [sender.device.manufacturer.id.value]
	, qc.FacilityNum as [sender.organization.id.value]
	, s.CPESVersionCD as versionCode_code
	, rv.codeSystem as versionCode_codeSystem
	, s.PurposeCD as purpose_code
	, rp.codeSystem as purpose_codeSystem 
from cihi.submission s
join CIHI.QA_QuestionnaireCycleAndStratum qc on s.SubmissionID=qc.submissionID
left join cihi.recode rv on rv.QAField='CPESVersionCD' and rv.FinalTable='Final_Metadata'
left join cihi.recode rp on rp.QAField='PurposeCD' and rp.FinalTable='Final_Metadata'
where s.submissionid=@SubmissionID

insert into CIHI.Final_QuestionnaireCycle 
	( [submissionID], [questionnaireCycle.id.value], [questionnaireCycle.healthCareFacility.id.value], [questionnaireCycle.submissionType_code], [questionnaireCycle.submissionType_codeSystem]
	, [questionnaireCycle.proceduresManualVersion_code], [questionnaireCycle.proceduresManualVersion_codeSystem], [questionnaireCycle.effectiveTime.low_value], [questionnaireCycle.effectiveTime.high_value]
	, [questionnaireCycle.sampleInformation.samplingMethod_code], [questionnaireCycle.sampleInformation.samplingMethod_codeSystem], [questionnaireCycle.sampleInformation.populationInformation.dischargeCount]
	, [questionnaireCycle.sampleInformation.populationInformation.sampleSize], [questionnaireCycle.sampleInformation.populationInformation.nonResponseCount])
select [submissionID]
	, qc.CycleCD as [questionnaireCycle.id.value]
	, qc.FacilityNum as [questionnaireCycle.healthCareFacility.id.value]
	, qc.SubmissionTypeCD as [questionnaireCycle.submissionType_code]
	, null                as [questionnaireCycle.submissionType_codeSystem]
	, qc.CPESVersionCD as [questionnaireCycle.proceduresManualVersion_code]
	, null             as [questionnaireCycle.proceduresManualVersion_codeSystem]
	, qc.EncounterDateStart as [questionnaireCycle.effectiveTime.low_value]
	, qc.EncounterDateEnd as [questionnaireCycle.effectiveTime.high_value]
	, qc.samplingMethod_CD as [questionnaireCycle.sampleInformation.samplingMethod_code]
	, null                 as [questionnaireCycle.sampleInformation.samplingMethod_codeSystem]
	, qc.dischargeCount as [questionnaireCycle.sampleInformation.populationInformation.dischargeCount]
	, qc.sampleSize as [questionnaireCycle.sampleInformation.populationInformation.sampleSize]
	, qc.nonResponseCount as [questionnaireCycle.sampleInformation.populationInformation.nonResponseCount]
from CIHI.QA_QuestionnaireCycleAndStratum qc
where qc.submissionID=@SubmissionID
and qc.FacilityNum in (select FacilityNum 
				from CIHI.QA_QuestionnaireCycleAndStratum
				where submissionID=@SubmissionID
				group by FacilityNum
				having count(distinct sampleunitID)=1)

insert into CIHI.Final_QuestionnaireCycle 
	( [submissionID], [questionnaireCycle.id.value], [questionnaireCycle.healthCareFacility.id.value], [questionnaireCycle.submissionType_code], [questionnaireCycle.submissionType_codeSystem]
	, [questionnaireCycle.proceduresManualVersion_code], [questionnaireCycle.proceduresManualVersion_codeSystem], [questionnaireCycle.effectiveTime.low_value], [questionnaireCycle.effectiveTime.high_value]
	, [questionnaireCycle.sampleInformation.samplingMethod_code], [questionnaireCycle.sampleInformation.samplingMethod_codeSystem])
select distinct [submissionID]
	, CycleCD as [questionnaireCycle.id.value]
	, FacilityNum as [questionnaireCycle.healthCareFacility.id.value]
	, SubmissionTypeCD as [questionnaireCycle.submissionType_code]
	, null as             [questionnaireCycle.submissionType_codeSystem]
	, CPESVersionCD as [questionnaireCycle.proceduresManualVersion_code]
	, null as          [questionnaireCycle.proceduresManualVersion_codeSystem]
	, EncounterDateStart as [questionnaireCycle.effectiveTime.low_value]
	, EncounterDateEnd as [questionnaireCycle.effectiveTime.high_value]
	, samplingMethod_CD as [questionnaireCycle.sampleInformation.samplingMethod_code]
	, null as              [questionnaireCycle.sampleInformation.samplingMethod_codeSystem]
from CIHI.QA_QuestionnaireCycleAndStratum
where submissionID=@SubmissionID
and FacilityNum in (select FacilityNum
				from CIHI.QA_QuestionnaireCycleAndStratum
				where submissionID=@SubmissionID
				group by FacilityNum
				having count(distinct sampleunitID)>1)

insert into CIHI.Final_Stratum 
	( [submissionID], [Final_QuestionnaireCycleID], [questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode], [questionnaireCycle.sampleInformation.populationInformation.stratum.stratumDescription]
	, [questionnaireCycle.sampleInformation.populationInformation.stratum.dischargeCount], [questionnaireCycle.sampleInformation.populationInformation.stratum.sampleSize]
	, [questionnaireCycle.sampleInformation.populationInformation.stratum.nonResponseCount])
select qcas.SubmissionID, fqc.[Final_QuestionnaireCycleID]
	, sampleunitID as [questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode]
	, left(strSampleunit_nm,25) as [questionnaireCycle.sampleInformation.populationInformation.stratum.stratumDescription]
	, dischargeCount as [questionnaireCycle.sampleInformation.populationInformation.stratum.dischargeCount]
	, sampleSize as [questionnaireCycle.sampleInformation.populationInformation.stratum.sampleSize]
	, nonResponseCount as [questionnaireCycle.sampleInformation.populationInformation.stratum.nonResponseCount]
from CIHI.QA_QuestionnaireCycleAndStratum qcas
join CIHI.Final_QuestionnaireCycle fqc on qcas.submissionID = fqc.submissionID and qcas.FacilityNum = fqc.[questionnaireCycle.healthCareFacility.id.value]
where qcas.submissionID=@SubmissionID
and FacilityNum in (select FacilityNum
				from CIHI.QA_QuestionnaireCycleAndStratum
				where submissionID=@SubmissionID
				group by FacilityNum
				having count(distinct sampleunitID)>1)

INSERT INTO CIHI.Final_Questionnaire 
	( [SubmissionID], [Final_QuestionnaireCycleID], [questionnaireCycle.questionnaire.id.value], [questionnaireCycle.questionnaire.stratumCode], [questionnaireCycle.questionnaire.subject.id.value], [questionnaireCycle.questionnaire.subject.id.issuer.code_code]
	, [questionnaireCycle.questionnaire.subject.id.issuer.code_codeSystem], [questionnaireCycle.questionnaire.subject.otherId.value], [questionnaireCycle.questionnaire.subject.otherId.code_code]
	, [questionnaireCycle.questionnaire.subject.otherId.code_codeSystem], [questionnaireCycle.questionnaire.subject.personInformation.birthTime_value], [questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_code]
	, [questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_codeSystem], [questionnaireCycle.questionnaire.subject.personInformation.gender_code]
	, [questionnaireCycle.questionnaire.subject.personInformation.gender_codeSystem], [questionnaireCycle.questionnaire.encompassingEncounter.effectiveTime.high_value], [questionnaireCycle.questionnaire.encompassingEncounter.service_code]
	, [questionnaireCycle.questionnaire.encompassingEncounter.service_codeSystem], [questionnaireCycle.questionnaire.authorMode_code], [questionnaireCycle.questionnaire.authorMode_codeSystem], [questionnaireCycle.questionnaire.language_code]
	, [questionnaireCycle.questionnaire.language_codeSystem])
select q.SubmissionID, qc.[Final_QuestionnaireCycleID]
	, samplepopid as [questionnaireCycle.questionnaire.id.value]
	, sampleunitid as [questionnaireCycle.questionnaire.stratumCode]
	, HCN as [questionnaireCycle.questionnaire.subject.id.value]
	, HCN_Issuer as [questionnaireCycle.questionnaire.subject.id.issuer.code_code]
	, null as       [questionnaireCycle.questionnaire.subject.id.issuer.code_codeSystem]
	, CIHI_PID as [questionnaireCycle.questionnaire.subject.otherId.value]
	, CIHI_PIDType as [questionnaireCycle.questionnaire.subject.otherId.code_code]
	, null as         [questionnaireCycle.questionnaire.subject.otherId.code_codeSystem]
	, replace(convert(varchar,DOB,102),'.','') as [questionnaireCycle.questionnaire.subject.personInformation.birthTime_value]
	, estimatedBirthCD as [questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_code]
	, null as             [questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_codeSystem]
	, sex as  [questionnaireCycle.questionnaire.subject.personInformation.gender_code]
	, null as [questionnaireCycle.questionnaire.subject.personInformation.gender_codeSystem]
	, replace(convert(varchar,dischargeDate,102),'.','') as [questionnaireCycle.questionnaire.encompassingEncounter.effectiveTime.high_value]
	, CIHI_ServiceLine as [questionnaireCycle.questionnaire.encompassingEncounter.service_code]
	, null as             [questionnaireCycle.questionnaire.encompassingEncounter.service_codeSystem]
	, mailingStepMethodID as [questionnaireCycle.questionnaire.authorMode_code]
	, null as                [questionnaireCycle.questionnaire.authorMode_codeSystem]
	, langID as [questionnaireCycle.questionnaire.language_code]
	, null as   [questionnaireCycle.questionnaire.language_codeSystem]
from CIHI.QA_Questionnaire q 
join CIHI.Final_QuestionnaireCycle qc on q.CycleCD=qc.[questionnaireCycle.id.value] and q.submissionID=qc.submissionID
where q.submissionID=@SubmissionID

-- blank out stratumCode (sampleunitID) for questionnaires that don't have strata (i.e. SRS and CEN samples)
update fq set [questionnaireCycle.questionnaire.stratumCode]=null 
from cihi.final_questionnaire fq
left join cihi.final_stratum fs on fq.[questionnaireCycle.questionnaire.stratumCode]=fs.[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode] and fs.submissionid=fq.submissionid
where fq.submissionid=@submissionid
and fs.submissionid is null

select distinct cycleCd as [cycleCDs that don't appear in Final_QuestionnaireCycle] from CIHI.QA_Questionnaire q where cycleCd not in (select [questionnaireCycle.id.value] from CIHI.Final_QuestionnaireCycle )

insert into CIHI.Final_Question 
	( [SubmissionID], [Final_QuestionnaireID], [questionnaireCycle.questionnaire.questions.question.code_code], [questionnaireCycle.questionnaire.questions.question.code_codeSystem]
	, [questionnaireCycle.questionnaire.questions.question.answer_code], [questionnaireCycle.questionnaire.questions.question.answer_codeSystem])
select qr.SubmissionID, qf.[Final_QuestionnaireID]
	, qstncore as [questionnaireCycle.questionnaire.questions.question.code_code]
	, NULL as     [questionnaireCycle.questionnaire.questions.question.code_codeSystem]
	, intResponseVal as [questionnaireCycle.questionnaire.questions.question.answer_code]
	, NULL as           [questionnaireCycle.questionnaire.questions.question.answer_codeSystem]
from CIHI.QA_Question qr
join CIHI.Final_Questionnaire qf on qr.samplePopID = qf.[questionnaireCycle.questionnaire.id.value] and qf.SubmissionID=qr.submissionID
where qr.SubmissionID=@SubmissionID

/*
	Recode Final tables
*/
DECLARE @sql nvarchar(max)

--we shouldn't submit appropriately skipped questions
DELETE FROM CIHI.Final_Question where [questionnaireCycle.questionnaire.questions.question.answer_code]='-4'

IF OBJECT_ID('tempdb..#Recode') IS NOT NULL DROP TABLE #Recode

select distinct [FinalTable],[FinalField]
INTO #Recode
from cihi.recode
order by FinalTable, FinalField


DECLARE @FinalTable varchar(50)
DECLARE @FinalField varchar(100)

SELECT top 1 @FinalTable = FinalTable, @FinalField = FinalField FROM #Recode order by FinalTable, FinalField
WHILE @@rowcount > 0
begin

	select distinct @sql ='
	update f 
		set f.['+r.Finalfield+'] = r.CIHIValue'+case when right(r.FinalField,4)='Code' then ',f.['+r.FinalField+'System]=r.codesystem' else '' end+'
	from cihi.[' + FinalTable + '] f
	join cihi.recode r on f.[' + r.FinalField + ']=r.nrcValue
	where r.finalTable=''' + r.FinalTable + ''' and r.finalField = ''' + r.FinalField + ''' '
	from cihi.Recode r
	WHERE r.FinalTable = @FinalTable
	and r.FinalField = @FinalField

	if @FinalField = 'questionnaireCycle.questionnaire.questions.question.answer_code'
		set @sql = replace(@sql,' on ',' on f.[questionnaireCycle.questionnaire.questions.question.code_code]=r.qstncore and ')

	print @sql

	exec sp_executesql @sql

	DELETE FROM #Recode where FinalTable = @FinalTable and FinalField = @FinalField
	SELECT top 1 @FinalTable = FinalTable, @FinalField = FinalField FROM #Recode
end

set @sql=''
select @sql = @sql + '
update fq set ['+FinalField+']='''+CIHIValue+''', ['+FinalField+'system]='''+codeSystem+'''
from cihi.final_questionnaire fq
where ['+FinalField+'system] is null' 
from cihi.recode 
where nrcvalue = '%else%'
exec sp_executesql @sql

-- the CIHI surveys can have custom questions. These are not submitted to CIHI and can be deleted.
delete from CIHI.final_Question where [questionnaireCycle.questionnaire.questions.question.code_codeSystem] is NULL
