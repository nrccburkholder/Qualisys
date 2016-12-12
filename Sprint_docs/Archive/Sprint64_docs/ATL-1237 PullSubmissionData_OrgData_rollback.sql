/*
	ATL-1228 Procedure to move data from QA to Final

		ATL-1237 Organization submission procedure

		Tim Butler
*/
use qp_prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_OrgData')
	drop procedure CIHI.PullSubmissionData_OrgData
go

