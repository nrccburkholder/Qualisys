/*
S31_US15_T1_FormLayout_VersionUpdateOnly.sql

New: PQRS:  Skip Pattern Instruction Text	
As the CAHPS Compliance Officer, I want skip pattern instruction text available to match the text on the PQRS survey, so that we comply with requirements to not modify the survey	
"""If [Response Text], go to # [q num]""
""If No, go to # 44"""	

15.1	change the case statement in PCLGen/form layout

Chris Burkholder

Only updating QualPro_Param
*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.33' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.33'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO