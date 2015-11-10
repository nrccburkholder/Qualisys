/*
S37 US6 T1 Skip Instructions Question Variations.sql

 Emergency fix: changes based on UAT which did not get checked

Chris Burkholder

Updating SkipInstruction survey rules by survey type and language in QualPro_params


*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.37' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.37'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO


update qualpro_params set strparam_value = '|Q50253|Si·contestó ''No'',·|Q50254||QElse|Si·contestó·''%s'',·|pase a la pregunta #[S%s]'
where strparam_nm in ('SkipInstructionFormat - ACOCAHPS + HCAHPS Spanish','SkipInstructionFormat - PQRS CAHPS + HCAHPS Spanish')

update qualpro_params set strparam_value = 'Si·contestó ''%s,''·pase a la pregunta [S%s]'
where strparam_nm in ('SkipInstructionFormat - CGCAHPS + HCAHPS Spanish')

update qualpro_params set strparam_value = 'Si·contestó %s,·pase a la pregunta [S%s]'
where strparam_nm in ('SkipInstructionFormat - Hospice CAHPS + HCAHPS Spanish')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - ACOCAHPS + ENGLISH', 'S', 'SurveyRules', '', 'Exceptional format string for ACOCAHPS "HCAHPS English" Skip Instructions')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - PQRS CAHPS + ENGLISH', 'S', 'SurveyRules', '', 'Exceptional format string for PQRS CAHPS "HCAHPS English" Skip Instructions')

declare @override varchar(255) = '|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|'

update qualpro_params 
set strparam_value = @override
where strparam_nm in ('SkipInstructionFormat - ACOCAHPS + ENGLISH','SkipInstructionFormat - PQRS CAHPS + English')

GO