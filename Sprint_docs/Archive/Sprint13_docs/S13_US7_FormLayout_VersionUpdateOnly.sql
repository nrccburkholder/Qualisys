/*
S13.US7	As a Formlayout user, I need better management of translation for text boxes	
		Setup the Implementation Client from the template to get expected variations of cover letters	

7.1	Add dynamic cover letters to print mockup

Chris Burkholder

Only updating QualPro_Param
*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.25' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.25'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO