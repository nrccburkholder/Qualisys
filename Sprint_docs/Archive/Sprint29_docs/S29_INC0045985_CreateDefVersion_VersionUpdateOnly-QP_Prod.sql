/*
S29_INC0045985_CreateDefVersion_VersionUpdateOnly-QP_Prod.sql

Fix: non-deliverable problems with litho codes mistakenly tripping Canada logic

Chris Burkholder

Only updating QualPro_Param
*/

use qp_prod
go

update qualpro_params set strparam_value = 'v2.17.0000' where strparam_nm = 'CreateDefVersion' and strparam_value = 'v2.16.0055'


select * from qualpro_params where strparam_nm = 'CreateDefVersion'