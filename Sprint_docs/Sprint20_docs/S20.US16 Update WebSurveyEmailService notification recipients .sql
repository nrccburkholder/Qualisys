/*
	S20.US16 -- Updates the WebSurveyEmailService so that email notifications will go to a specific distribution list 
	instead of TransferResultsErrors@nationalresearch.com

	This ONLY needs to be run for Canada.

*/

use QP_PROD

begin tran

update QUALPRO_PARAMS
	SET STRPARAM_VALUE = 'WebSurveyEmailServiceAlerts@nationalresearch.com'
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySendErrorNotificationTo'

commit tran

select *
from QUALPRO_PARAMS
where STRPARAM_GRP = 'WebSurveyEmailSrvc'
and STRPARAM_NM = 'WebSurveySendErrorNotificationTo'