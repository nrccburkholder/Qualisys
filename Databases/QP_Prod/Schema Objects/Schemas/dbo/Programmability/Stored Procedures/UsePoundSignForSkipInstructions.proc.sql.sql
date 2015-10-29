create procedure dbo.UsePoundSignForSkipInstructions
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

select @bitUsePoundForSkipInstructions UsePoundSignForSkipInstructions, 
	IsNull(@FormatOverride, '') FormatOverride,
	@bitSkipRepeatsScaleText SkipRepeatsScaleText,
	IsNull(@SkipGoPhrase, '') SkipGoPhrase,
	IsNull(@SkipEndPhrase, '') SkipEndPhrase