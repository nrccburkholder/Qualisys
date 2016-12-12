use qp_prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'TransferToFinal_Patient')
	drop procedure CIHI.TransferToFinal_Patient
go
