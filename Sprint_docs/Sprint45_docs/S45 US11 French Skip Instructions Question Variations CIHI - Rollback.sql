/*
S45 US11 French Skip Instructions Question Variations CIHI - Rollback.sql

 As the Canadian Service team, we want skip instructions for langids 11 & 12 to use "allez", 
 so these languages can be used for CIHI surveys.

Chris Burkholder

Updating SkipInstruction survey rules by survey type and language in QualPro_params

exec dbo.UsePoundSignForSkipInstructions 15841, 11 --CIHI
exec dbo.UsePoundSignForSkipInstructions 15841, 12 --CIHI
exec dbo.UsePoundSignForSkipInstructions 15841, 1 --CIHI

*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.37' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.37'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - CIHI CPES-IC + English+Francophone'

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - CIHI CPES-IC + Francophone'

GO