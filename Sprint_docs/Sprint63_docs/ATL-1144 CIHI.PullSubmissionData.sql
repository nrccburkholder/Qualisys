use qp_prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData')
	drop procedure CIHI.PullSubmissionData
go
create procedure CIHI.PullSubmissionData 
@SubmissionID int
as

if exists (select submissionID from CIHI.Submission where SubmissionID = @SubmissionID and pullDate is not null
		union select submissionID from cihi.Final_Metadata where submissionID=@SubmissionID)
begin
	print 'data has already been pulled. aborting'
	return
end

declare @pullDate datetime = getdate()
update CIHI.Submission set PullDate = @pullDate where SubmissionID = @SubmissionID

declare @submissionSubject char(3)
select @submissionSubject = submissionSubject from CIHI.Submission where SubmissionID = @SubmissionID

if @submissionSubject = 'ORG' -- organizations
begin
	exec CIHI.PullSubmissionData_OrgData @SubmissionID
end
else if @submissionSubject = 'PAT' -- patients
begin
	delete from CIHI.QA_QuestionnaireCycleAndStratum where submissionID=@SubmissionID
	delete from CIHI.QA_Questionnaire where submissionID=@SubmissionID
	delete from CIHI.QA_Question where submissionID=@SubmissionID

	exec CIHI.PullSubmissionData_QuestionnaireCycle @SubmissionID
	exec CIHI.PullSubmissionData_Questionnaire @SubmissionID
	exec CIHI.PullSubmissionData_Question @SubmissionID

end
go



