use qp_prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData')
	drop procedure CIHI.PullSubmissionData
go
