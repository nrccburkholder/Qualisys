/*
	SurveyRules RT from HCAHPS - Rollback.sql

	Chris Burkholder

	6/5/2017

select * from qualpro_params where strparam_nm like 'SurveyRule%RT'
select * from qualpro_params where strparam_nm like 'SurveyRule%HCAHPS IP'
*/

USE [QP_Prod]
GO

delete
from qualpro_params where strparam_nm like 'SurveyRule%RT' 
and strparam_nm <> 'SurveyRule: SamplingToolPriority - RT'

GO