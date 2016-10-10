use qp_prod

select *
from qualpro_params
where STRPARAM_GRP = 'WebSurveyEmailSrvc'

update qualpro_params
	set NUMParam_value = '1'
where strPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveyServiceCycleTime'

update qualpro_params
	set NUMParam_value = '50'
where strPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveyMessageThrottleCount'


begin tran
update qualpro_params
	set strParam_value = 'nrcc@reportsystem.nationalresearch.ca'
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySmtpUserName'

update qualpro_params
	set strParam_value = 'B[T&uxM-o$%p'
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySmtpPassword'


update qualpro_params
	set NUMParam_value = '25'
where strPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySmtpPort'

update qualpro_params
	set strParam_value = 'reportsystem.nationalresearch.ca'
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySmtpHostName'

commit tran


select *
from qualpro_params
where STRPARAM_GRP = 'WebSurveyEmailSrvc'