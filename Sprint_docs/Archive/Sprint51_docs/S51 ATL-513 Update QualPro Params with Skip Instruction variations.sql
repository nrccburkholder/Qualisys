/*
S51 ATL-513 Update QualPro Params with Skip Instruction variations.sql

 Questionnaires generate with correct skip instruction verbiage in English, Spanish (2, 8, & 19), and Portuguese (14).

Chris Burkholder

Updating SkipInstruction survey rules by survey type and language in QualPro_params

exec dbo.UsePoundSignForSkipInstructions 11392, 1 --English
exec dbo.UsePoundSignForSkipInstructions 11392, 2 --Spanish
exec dbo.UsePoundSignForSkipInstructions 11392, 8 --PEP-C Spanish
exec dbo.UsePoundSignForSkipInstructions 11392, 19 --HCAHPS Spanish
exec dbo.UsePoundSignForSkipInstructions 11392, 14 --Portuguese

select * from languages + English + PEP-C Spanish + Spanish + HCAHPS Spanish + Portuguese
select * from surveytype - HCAHPS IP 

*/

use [QP_Prod]

declare @surveytype varchar(20) = 'HCAHPS IP'

declare @skipinstructions varchar(255) = '|Q18929|If Another, Go to Question [S%s]|QElse|If·%s,·Go·to·Question [S%s]|'
--If Another, Go to Question 21 If No, Go to Question 12 
declare @language varchar(20) = 'English'

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language)
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - '+ @surveytype + ' + ' + @language, 'S', 'SurveyRules', '', 'Question Variations for '+@surveytype + ' + '+@language)

update qualpro_params set strparam_value = @skipinstructions where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @skipinstructions = '|Q18929|Si contestó “Otra”, pase a la pregunta [S%s]|QElse|Si contestó “No”, pase a la pregunta [S%s]|'
--Si contestó “Otra”, pase a la pregunta 21 Si contestó “No”, pase a la pregunta 12 
select @language = 'PEP-C Spanish'

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language)
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - '+ @surveytype + ' + ' + @language, 'S', 'SurveyRules', '', 'Question Variations for '+@surveytype + ' + '+@language)

update qualpro_params set strparam_value = @skipinstructions where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @language = 'Spanish'

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language)
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - '+ @surveytype + ' + ' + @language, 'S', 'SurveyRules', '', 'Question Variations for '+@surveytype + ' + '+@language)

update qualpro_params set strparam_value = @skipinstructions where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @language = 'HCAHPS Spanish'

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language)
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - '+ @surveytype + ' + ' + @language, 'S', 'SurveyRules', '', 'Question Variations for '+@surveytype + ' + '+@language)

update qualpro_params set strparam_value = @skipinstructions where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @skipinstructions = '|Q18929|Se responder outra instituição, vá para a Pergunta [S%s]|QElse|Se responder Não, vá para a Pergunta [S%s]|' 
--Se responder outra instituição, vá para a Pergunta 21 Se responder Não, vá para a Pergunta 12 
select @language = 'Portuguese'

if not exists (select * from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language)
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - '+ @surveytype + ' + ' + @language, 'S', 'SurveyRules', '', 'Question Variations for '+@surveytype + ' + '+@language)

update qualpro_params set strparam_value = @skipinstructions where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select * from qualpro_params where strparam_nm like 'SkipInstruction%'

GO