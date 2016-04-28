/*
S48 ATL-157 Implement OAS Systematic Sampling Algorithm.sql

Chris Burkholder

select dbo.SurveyProperty ('IsSystematic', 16, null)

*/

if not exists (select * from qualpro_params where strparam_nm = 'SurveyRule: IsSystematic - OAS CAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SurveyRule: IsSystematic - OAS CAHPS', 'S', 'SurveyRules', '1', 'OAS CAHPS uses Systematic sampling')

