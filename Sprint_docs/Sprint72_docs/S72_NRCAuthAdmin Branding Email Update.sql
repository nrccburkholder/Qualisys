/*
	S72_NRCAuthAdmin Branding Email Update.sql

	Chris Burkholder

	4/14/2017

	Update QualPro_Params WWWNRCPickerUrl

*/

Use [QP_Prod]
GO

update qualpro_params set strparam_value =
--select strparam_value,
replace(strparam_value, 'http://www.NationalResearch', 'https://nrchealth')
from qualpro_params where strparam_nm = 'WWWNRCPickerUrl'

update qualpro_params set strparam_value =
--select strparam_value,
replace(strparam_value, 'NationalResearch', 'NRCHealth')
from qualpro_params where strparam_nm = 'NAAMailFromAccount'

GO