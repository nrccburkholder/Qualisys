

select *
from QUALPRO_PARAMS
where strparam_nm like 'skip%'
order by param_id

'|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|'

'|Q50253|Si·contestó 'No',|Q50254||QElse|Si·contestó·'%s',|·pase a la pregunta #[S%s]'

/*

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - ACOCAHPS + ENGLISH', 'S', 'SurveyRules', '', 'Exceptional format string for ACOCAHPS "HCAHPS English" Skip Instructions')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - PQRS CAHPS + ENGLISH', 'S', 'SurveyRules', '', 'Exceptional format string for PQRS CAHPS "HCAHPS English" Skip Instructions')

declare @override varchar(255) = '|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|'

update qualpro_params 
set strparam_value = @override
where strparam_nm in ('SkipInstructionFormat - ACOCAHPS + ENGLISH','SkipInstructionFormat - PQRS CAHPS + English')


declare @overrideSP varchar(255) = '|Q50253|Si·contestó "No",|Q50254||QElse|Si·contestó·"%s",|·pase a la pregunta #[S%s]'

/*
original values
ACO  - Si·contestó '%s,'·pase a la pregunta #[S%s]
PQRS - Si·contestó '%s,'·pase a la pregunta #[S%s]

*/

update qualpro_params 
set strparam_value = @overrideSP
where strparam_nm in ('SkipInstructionFormat - ACOCAHPS + HCAHPS Spanish','SkipInstructionFormat - PQRS CAHPS + HCAHPS Spanish')

*/

exec dbo.UsePoundSignForSkipInstructions 15975, 19 --hospice
exec dbo.UsePoundSignForSkipInstructions 15965, 19 --cgcahps
exec dbo.UsePoundSignForSkipInstructions 15958, 19 --pqrs
exec dbo.UsePoundSignForSkipInstructions 15954, 19 --aco
exec dbo.UsePoundSignForSkipInstructions 15937, 19 --hh

exec dbo.UsePoundSignForSkipInstructions 15975, 1 --hospice
exec dbo.UsePoundSignForSkipInstructions 15965, 1 --cgcahps
exec dbo.UsePoundSignForSkipInstructions 15958, 1 --pqrs
exec dbo.UsePoundSignForSkipInstructions 15954, 1 --aco
exec dbo.UsePoundSignForSkipInstructions 15937, 1 --hh

exec dbo.UsePoundSignForSkipInstructions @survey_id=15975, @lang_id=19

Si·contestó '%s,'·pase a la pregunta #[S%s]