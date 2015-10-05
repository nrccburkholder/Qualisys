/*
S35 US10 T1 Si Contesto FormLayout PCLGen - rollback.sql

 As an ATLAS dev I want to add some text to the Spanish translation for repeat skip language for 
 CG-CAHPS/PCMH, Hospice, ACO_CAHPS, PQRS-CAHPS that we missed in the original implementation so 
 that we can satisfy the original requirements. Acceptance criteria: Put in the phrase 
 [Si contestó "No"] for CGCAHPS/PCMH, PQRS and ACO [Si contestó No] for Hospice 

Task 1 - Create a table driven solution probably using survey rules in qualpro params and hook 
it up in pclgen and form layout
Task 2 - Test - do Spanish for some other survey types and english for a couple (print mockups and test prints)

Chris Burkholder

Updating Formlayout version in QualPro_Params

Adding SkipInstruction survey rules by survey type and language in QualPro_params

alter procedure dbo.UsePoundSignForSkipInstructions
*/

use [QP_Prod]

update QualPro_Params set strparam_value = '3.35' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.35'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO
/*
select * from qualpro_params where STRPARAM_GRP = 'SurveyRules' and strparam_nm like 'Skip%'

select * from languages
select * from surveytype

select 'SkipInstructionFormat - ' + SurveyType_Dsc + ' + ' + Language
from languages, surveytype
where langid = 19
*/
/*
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - CGCAHPS + HCAHPS Spanish', 'S', 'SurveyRules', '', 'Exceptional format string for CGCAHPS "HCAHPS Spanish" Skip Instructions')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - ACOCAHPS + HCAHPS Spanish', 'S', 'SurveyRules', '', 'Exceptional format string for ACOCAHPS "HCAHPS Spanish" Skip Instructions')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - Hospice CAHPS + HCAHPS Spanish', 'S', 'SurveyRules', '', 'Exceptional format string for Hospice "HCAHPS Spanish" Skip Instructions')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('SkipInstructionFormat - PQRS CAHPS + HCAHPS Spanish', 'S', 'SurveyRules', '', 'Exceptional format string for PQRS CAHPS "HCAHPS Spanish" Skip Instructions')

update qualpro_params set strparam_value = 'Si·contestó ''%s,''·pase a la pregunta #[S%s]'
where strparam_nm in ('SkipInstructionFormat - CGCAHPS + HCAHPS Spanish','SkipInstructionFormat - ACOCAHPS + HCAHPS Spanish','SkipInstructionFormat - PQRS CAHPS + HCAHPS Spanish')

update qualpro_params set strparam_value = 'Si·contestó %s,·pase a la pregunta #[S%s]'
where strparam_nm in ('SkipInstructionFormat - Hospice CAHPS + HCAHPS Spanish')
*/
/*
select surveytype_id, * from survey_def

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

--sp_helptext UsePoundSignForSkipInstructions

--select max(len(surveytype_dsc)) from surveytype --17
--select max(len(language)) from languages --19
*/
GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[UsePoundSignForSkipInstructions]    Script Date: 10/5/2015 11:05:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[UsePoundSignForSkipInstructions]
@survey_id int
as
select 1 
from SurveyType st
inner join Survey_def sd on st.SurveyType_id = sd.SurveyType_id 
where survey_id=@survey_id
and st.UsePoundSignForSkipInstructions=1

GO

