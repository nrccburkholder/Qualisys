/*
S45 US11 French Skip Instructions Question Variations CIHI.sql

 As the Canadian Service team, we want skip instructions for langids 11 & 12 to use "allez", 
 so these languages can be used for CIHI surveys.

Chris Burkholder

Updating SkipInstruction survey rules by survey type and language in QualPro_params

exec dbo.UsePoundSignForSkipInstructions 15841, 11 --CIHI
exec dbo.UsePoundSignForSkipInstructions 15841, 12 --CIHI
exec dbo.UsePoundSignForSkipInstructions 15841, 1 --CIHI

*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.38' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.38'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - CIHI CPES-IC + English+Francophone')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - CIHI CPES-IC + English+Francophone', 'S', 'SurveyRules', '', 'No Question Variation, just an override for CIHI CPES-IC + English+Francophone')

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - CIHI CPES-IC + Francophone')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - CIHI CPES-IC + Francophone', 'S', 'SurveyRules', '', 'No Question Variation, just an override for CIHI CPES-IC + Francophone')

declare @override varchar(255) = 'Allez·à·la·question·n'+char(27)+'*p-30Yo'+char(27)+'*p+30Y·[S%s]'

update qualpro_params 
set strparam_value = @override
where strparam_nm in ('SkipInstructionFormat - CIHI CPES-IC + English+Francophone','SkipInstructionFormat - CIHI CPES-IC + Francophone')

GO