/*
S23_US12_FormLayout_VersionUpdateOnly.sql

(S22) US12	Analysis: PCLGen keep with next functionality	as an HCAHPS vendor we must keep headers and transitional text with the following question

Chris Burkholder

Only updating QualPro_Param
*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.29' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.29'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO