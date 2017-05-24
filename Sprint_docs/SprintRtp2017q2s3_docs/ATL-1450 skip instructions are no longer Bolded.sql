/*
	ATL-1450 skip instructions are no longer Bolded.sql

	Chris Burkholder

	5/24/2017

	Update QualPro_params (Form Layout version only)

	select * from qualpro_params where strparam_nm like 'Formlayout%'

*/
Use [QP_Prod]
GO

update QualPro_Params set strparam_value = '3.40'
where strparam_nm = 'FormLayoutVersion'

GO