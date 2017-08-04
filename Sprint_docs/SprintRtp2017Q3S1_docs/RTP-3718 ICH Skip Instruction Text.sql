/*
	RTP-3718 ICH Skip Instruction Text.sql

	Chris Burkholder

	8/4/2017

	select * from qualpro_params where strparam_nm like '%skipinstruction%'

Was ACO/PQRS, and that was already addressed.
	PROD:
|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|
|Q50253|Si·contestó 'No',·|Q50254||QElse|Si·contestó·'%s',·|pase a la pregunta #[S%s]
	STAGE:
|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|
|Q50253|Si·contestó 'No',·|Q50254||QElse|Si·contestó·'%s',·|pase a la pregunta #[S%s]
	TEST:
|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If?%s,?go?to?#[S%s]|
|Q50253|Si·contestó 'No',·|Q50254||QElse|Si·contestó·'%s',·|pase a la pregunta #[S%s]
	DEV:
|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If?%s,?go?to?#[S%s]|
|Q50253|Si·contestó 'No',·|Q50254||QElse|Si·contestó·'%s',·|pase a la pregunta #[S%s]

But Test and Dev had an issue, so the following was executed:

update qualpro_params set strparam_value = N'|Q50253|If No, go to #[S%s]|Q50254|Go to #[S%s]|QElse|If·%s,·go·to·#[S%s]|'
where strparam_nm in ( 'SkipInstructionFormat - ACOCAHPS + ENGLISH',
'SkipInstructionFormat - PQRS CAHPS + ENGLISH')

Then this story became ICH, which only mentioned the first two questions, but seems there are more...
	select * from qualpro_params where strparam_nm like '%skipinstruction%ICH%'
First thing is we need to turn on SkipRepeatsScaleText for ICH

select * from surveytype

select * from survey_def where surveytype_id = 8

select * from ClientStudySurvey_view where survey_id in (16289,20745)

select * from SurveyTypeQuestionMappings where surveytype_id = 8 and qstncore in ( 47176, 47193)

*/
use qp_prod
go

update SurveyType set SkipRepeatsScaleText = 1
--select * from SurveyType
where SurveyType_ID = 8 and SkipRepeatsScaleText = 0

GO

--insert into qualpro_params (STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
--select 'SkipInstructionFormat - ICHCAHPS + ENGLISH','S','SurveyRules',
--'|Q47176|If Don''t Know, Go to Question [S%s]|Q47193|If Don''t Know, Go to Question [S%s]|QElse|If %s, go to Question [S%s]|',
--	NULL,	NULL,	'Question Variations for ICHCAHPS + ENGLISH'

if not exists( select 1 from  qualpro_params where STRPARAM_NM = 'SkipInstructionFormat - ICHCAHPS + HCAHPS Spanish')
insert into qualpro_params (STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
select 'SkipInstructionFormat - ICHCAHPS + HCAHPS Spanish','S','SurveyRules',
'Si contestó "%s", pase a la pregunta [S%s]',
	NULL,	NULL,	'Question Variations for ICHCAHPS + HCAHPS Spanish'


GO