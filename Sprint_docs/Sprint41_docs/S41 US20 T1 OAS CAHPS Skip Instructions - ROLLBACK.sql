/*
S41 US20 T1 OAS CAHPS Skip Instructions - ROLLBACK.sql

 20 OAS: Skip Pattern Instructions
As an authorized OAS CAHPS vendor, we need to follow the skip pattern instruction text, so that we comply with 
mandatory requirements
"Acceptance: Question 30 will have a skip pattern language exception like: If [response text], 
go to #[q number] Exception on 30 (Hispanic, etc.) - Changes will be in qualpro params table, maybe survey 
type table" 

Chris Burkholder

Updating SkipInstruction survey rules by survey type and language in QualPro_params


*/

use [QP_Prod]

GO

begin tran

--select * from surveytype
update surveytype set SkipRepeatsScaleText = 0, UsePoundSignForSkipInstructions = 0
where surveytype_dsc = 'OAS CAHPS'

delete qualpro_params where STRPARAM_NM = 'SkipInstructionFormat - OAS CAHPS + ENGLISH'

delete qualpro_params where STRPARAM_NM = 'SkipInstructionFormat - OAS CAHPS + HCAHPS Spanish'

GO

--select * from qualpro_params where strparam_nm like 'SkipInstructionFormat%'

--rollback tran
commit tran