/*
S51 ATL-513 Update QualPro Params with Skip Instruction variations - Rollback.sql

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

declare @language varchar(20) = 'English'

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @language = 'PEP-C Spanish'

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @language = 'Spanish'

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @language = 'HCAHPS Spanish'

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select @language = 'Portuguese'

delete from qualpro_params where strparam_nm = 'SkipInstructionFormat - '+ @surveytype + ' + ' + @language

select * from qualpro_params where strparam_nm like 'SkipInstruction%'

GO