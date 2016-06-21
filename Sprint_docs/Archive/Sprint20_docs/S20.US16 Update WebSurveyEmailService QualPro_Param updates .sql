/*
	S20.US16 -- Updates the WebSurveyEmailService QualPro_Params for Service Cycle Time and Error Notification
	

	This ONLY needs to be run for Canada.

*/

use QP_PROD

begin tran

update QUALPRO_PARAMS
	SET STRPARAM_VALUE = 'WebSurveyEmailServiceAlerts@nationalresearch.com'
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySendErrorNotificationTo'

update QUALPRO_PARAMS
	SET NUMPARAM_VALUE = '2'
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveyServiceCycleTime'

commit tran

select *
from QUALPRO_PARAMS
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
