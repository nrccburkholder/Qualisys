/*
S33_US12_FormLayout_VersionUpdateOnly.sql

As an authorized ACO CAHPS vendor, we want to update the skip pattern instructions to include those with the #, so that we 
field the survey according to specs

12.1	write new stored procedure to determine inclusion in pound sign list
12.2	refactor PCLGen to call new stored procedure to determine skip language

Dave Gilsdorf

Only updating QualPro_Param
*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.35' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.35'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO