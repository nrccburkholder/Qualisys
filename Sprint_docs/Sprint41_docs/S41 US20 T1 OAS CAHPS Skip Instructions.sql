/*
S41 US20 T1 OAS CAHPS Skip Instructions.sql

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
update surveytype set SkipRepeatsScaleText = 1, UsePoundSignForSkipInstructions = 1
where surveytype_dsc = 'OAS CAHPS'

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - OAS CAHPS + ENGLISH', 'S', 'SurveyRules', '', 'Exceptional format string for ACOCAHPS "HCAHPS English" Skip Instructions')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - OAS CAHPS + HCAHPS Spanish', 'S', 'SurveyRules', '', 'Exceptional format string for PQRS CAHPS "HCAHPS English" Skip Instructions')

declare @override varchar(255) = '|Q54115|If No, go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|'

update qualpro_params 
set strparam_value = @override
where strparam_nm in ('SkipInstructionFormat - OAS CAHPS + ENGLISH')

select @override = '|Q54115|Si·contestó "No",·pase a la pregunta [S%s]|QElse|Si·contestó "%s,"·pase a la pregunta [S%s]'

update qualpro_params 
set strparam_value = @override
where strparam_nm in ('SkipInstructionFormat - OAS CAHPS + HCAHPS Spanish')

GO

--select * from qualpro_params where strparam_nm like 'SkipInstructionFormat%'

--rollback tran
commit tran