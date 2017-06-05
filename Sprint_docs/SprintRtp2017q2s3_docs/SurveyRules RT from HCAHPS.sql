/*
	SurveyRules RT from HCAHPS.sql

	Chris Burkholder

	6/5/2017

select * from qualpro_params where strparam_nm like 'SurveyRule%RT'
select * from qualpro_params where strparam_nm like 'SurveyRule%HCAHPS IP'
*/

USE [QP_Prod]
GO

insert into qualpro_params (strparam_nm, strparam_type, strparam_grp, strparam_value, numparam_value, comments)
select replace(strparam_nm, 'HCAHPS IP', 'RT'), STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, replace (replace(COMMENTS, 'HCAHPS', 'RT'), ' IP', '')
from qualpro_params where strparam_nm like 'SurveyRule%HCAHPS IP' 
and strparam_nm <> 'SurveyRule: SamplingToolPriority - HCAHPS IP'

GO