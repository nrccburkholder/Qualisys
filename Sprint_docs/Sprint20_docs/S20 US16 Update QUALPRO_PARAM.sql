/*

S20 US16 Enhancement to WebSurveyEmailService

Tim Butler

	Update WebSurveyEmailSrvc parameter value

*/


USE QP_Prod

begin tran

update qualpro_params
set NUMPARAM_VALUE = 2
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveyServiceCycleTime'

commit tran

SELECT *
FROM qualpro_params
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveyServiceCycleTime'