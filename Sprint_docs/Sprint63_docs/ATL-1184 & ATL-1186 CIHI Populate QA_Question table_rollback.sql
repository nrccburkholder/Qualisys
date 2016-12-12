use QP_Prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_Question')
	drop procedure CIHI.PullSubmissionData_Question
go
