/*
	SurveyRules RT from HCAHPS - Rollback.sql

	Chris Burkholder

	6/5/2017

select * from qualpro_params where strparam_nm like 'SurveyRule%RT'
select * from qualpro_params where strparam_nm like 'SurveyRule%HCAHPS IP'
*/

USE [QP_Prod]
GO

insert into qualpro_params (strparam_nm, strparam_type, strparam_grp, strparam_value, numparam_value, comments)
select 'SurveyRule: SamplingToolPriority - RT','N','SurveyRules',NULL,3,'RT Sampling Tool Priority is 3'

GO