/*
	S72_NRCAuthAdmin Branding Email Update - Rollback.sql

	Chris Burkholder

	4/14/2017

	Update QualPro_Params WWWNRCPickerUrl,'NAAMailFromAccount','NAAMassEmailFrom'

*/

Use [QP_Prod]
GO

update qualpro_params set strparam_value =
--select strparam_value,
replace(strparam_value, 'https://nrchealth', 'http://www.NationalResearch')
from qualpro_params where strparam_nm = 'WWWNRCPickerUrl'

update qualpro_params set strparam_value =
--select strparam_value,
replace(strparam_value, 'NRCHealth', 'NationalResearch')
from qualpro_params where strparam_nm in ('NAAMailFromAccount','NAAMassEmailFrom')

GO