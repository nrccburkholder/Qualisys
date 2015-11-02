/*
S37 INC0050205 FormLayout Print Mockup Fix.sql

Chris Burkholder

alter procedure dbo.UsePoundSignForSkipInstructions
*/

use [QP_Prod]

GO

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

exec dbo.UsePoundSignForSkipInstructions -1, 1 --FormLayout stand alone mode

exec dbo.UsePoundSignForSkipInstructions @survey_id=15975, @lang_id=19

--sp_helptext UsePoundSignForSkipInstructions

--select max(len(surveytype_dsc)) from surveytype --17
--select max(len(language)) from languages --19
*/

alter procedure dbo.UsePoundSignForSkipInstructions
@survey_id int,
@lang_id int
as

declare @SurveyType varchar(25)
declare @Language varchar(25)
declare @SkipGoPhrase varchar(50)
declare @SkipEndPhrase varchar(50)
declare @FormatOverride varchar(255)
declare @bitUsePoundForSkipInstructions bit
declare @bitSkipRepeatsScaleText bit

select @bitUsePoundForSkipInstructions = st.UsePoundSignForSkipInstructions, 
	@bitSkipRepeatsScaleText = st.SkipRepeatsScaleText,
	@SurveyType = Surveytype_dsc from SurveyType st
inner join Survey_def sd on st.SurveyType_id = sd.SurveyType_id 
where survey_id=@survey_id

select @Language = Language, @SkipGoPhrase = SkipGoPhrase, @SkipEndPhrase = SkipEndPhrase from Languages 
where LangId = @lang_id

select @FormatOverride = strparam_value from QualPro_Params where
strparam_nm = 'SkipInstructionFormat - ' + @SurveyType + ' + ' + @Language

--CJB 11/2/2015 Using 0 and 1 as defaults for bits below, hoping these match up to most new template print mockups INC0050205

select IsNull(@bitUsePoundForSkipInstructions, 0) UsePoundSignForSkipInstructions, 
	IsNull(@FormatOverride, '') FormatOverride,
	IsNull(@bitSkipRepeatsScaleText, 1) SkipRepeatsScaleText,
	IsNull(@SkipGoPhrase, '') SkipGoPhrase,
	IsNull(@SkipEndPhrase, '') SkipEndPhrase

GO