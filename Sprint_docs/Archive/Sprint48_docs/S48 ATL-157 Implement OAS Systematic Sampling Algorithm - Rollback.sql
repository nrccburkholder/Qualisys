/*
S48 ATL-157 Implement OAS Systematic Sampling Algorithm - Rollback.sql

Chris Burkholder

select dbo.SurveyProperty ('IsSystematic', 16, null)
select dbo.SurveyProperty ('IsSystematic', null, 16088)

CREATE PROCEDURE dbo.QCL_DeleteSystematicOutgo

*/
use QP_Prod
go

--if not exists (select * 
delete from qualpro_params where strparam_nm = 'SurveyRule: IsSystematic - OAS CAHPS'
--) insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
--values ('SurveyRule: IsSystematic - OAS CAHPS', 'S', 'SurveyRules', '1', 'OAS CAHPS uses Systematic sampling')
GO
--update qualpro_params set strparam_value = 1 where strparam_nm = 'SurveyRule: IsSystematic - OAS CAHPS'

if exists (select * from sys.procedures where name = 'QCL_DeleteSystematicOutgo')
	drop procedure QCL_DeleteSystematicOutgo
go
--CREATE PROCEDURE dbo.QCL_DeleteSystematicOutgo
--@sampleset_id INT
--AS 
--delete
--FROM SystematicSamplingProportion 
--WHERE sampleset_id = @sampleset_id

go
