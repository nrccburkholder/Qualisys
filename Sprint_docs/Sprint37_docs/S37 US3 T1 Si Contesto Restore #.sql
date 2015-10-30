/*
S37 US3 T1 Si Contesto Restore #.sql

 Emergency fix: changes based on UAT which did not get checked

Chris Burkholder

Updating SkipInstruction survey rules by survey type and language in QualPro_params


*/

use [QP_Prod]

update qualpro_params set strparam_value = 'Si·contestó ''%s,''·pase a la pregunta #[S%s]'
where strparam_nm in ('SkipInstructionFormat - CGCAHPS + HCAHPS Spanish','SkipInstructionFormat - ACOCAHPS + HCAHPS Spanish','SkipInstructionFormat - PQRS CAHPS + HCAHPS Spanish')

update qualpro_params set strparam_value = 'Si·contestó %s,·pase a la pregunta #[S%s]'
where strparam_nm in ('SkipInstructionFormat - Hospice CAHPS + HCAHPS Spanish')

GO