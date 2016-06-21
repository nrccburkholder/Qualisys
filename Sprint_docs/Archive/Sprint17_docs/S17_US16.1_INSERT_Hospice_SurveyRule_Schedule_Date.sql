/*

S16.US16	As a Data Management Associate, I want the default date for scheduling the sample to be the day before the field period starts, so I do not have to remember to change the date.

Tim Butler



*/

use qp_prod
go


begin tran

/*
	Survey Properties
*/

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: DefaultScheduleDateAdjustmentByMonths - Hospice CAHPS','N','SurveyRules',NULL,3,NULL,'The number of months to add to Sample Period expectedstartdate to set scheduled generation date')



commit tran


