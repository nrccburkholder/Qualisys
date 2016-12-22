/*
S65_ATL-1265 Activate PIT Checkbox for CG-CAHPS Survey Type - Rollback.sql

Chris Burkholder

12/21/2016

Reinsert record from QualPro_Params

delete from qualpro_params where strparam_nm = 'SurveyRule: PointInTimeDisallowed - CGCAHPS'

*/

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: PointInTimeDisallowed - CGCAHPS','S','SurveyRules',1,NULL,NULL,'Point In Time is disallowed for CGCAHPS')
