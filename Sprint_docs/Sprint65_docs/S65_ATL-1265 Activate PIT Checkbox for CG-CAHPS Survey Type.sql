/*
S65_ATL-1265 Activate PIT Checkbox for CG-CAHPS Survey Type.sql

Chris Burkholder

12/21/2016

Remove record from QualPro_Params

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: PointInTimeDisallowed - CGCAHPS','S','SurveyRules',1,NULL,NULL,'Point In Time is disallowed for CGCAHPS')

*/

delete from qualpro_params where strparam_nm = 'SurveyRule: PointInTimeDisallowed - CGCAHPS'

