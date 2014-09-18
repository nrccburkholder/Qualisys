--UPDATED SURVEYPROPERTY FUNCTION to handle PCMH surveysubtype for accessing survey properties

-- =============================================
-- Author:		Burkholder, Chris
-- Create date: 7/10/2014
-- Description:	Simple Rule Reader by Survey Type 
-- =============================================
CREATE FUNCTION [dbo].[SurveyProperty] 
(
	@PropertyName varchar(50),
	@SurveyType_id int = null,
	@Survey_id int = null
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar(50)
	Declare @StrParam varchar(50)
	Declare @NumParam int
	Declare @DatParam datetime
	DECLARE @SurveyType varchar(20)
	
	Declare @Override varchar(50) = null
	if @Survey_id is not null
		select top 1 @Override = st.Subtype_nm  
		from surveysubtype sst 
		inner join subtype st on sst.Subtype_id = st.Subtype_id 
		where survey_id = @Survey_id and st.bitRuleOverride = 1

	if @surveytype_id is not null
	select @surveyType = SurveyType_dsc from SurveyType where surveytype_id = @SurveyType_id
	else
	if @survey_id is not null
	select @surveyType = SurveyType_dsc from SurveyType st inner join Survey_DEF sd on st.surveyType_id = sd.SurveyType_id and sd.survey_id = @survey_id
	else
	select @surveyType = ''

	if exists (Select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @Override)
	Select @StrParam = STRPARAM_VALUE, @NumParam = NUMPARAM_VALUE, @DatParam = DATPARAM_VALUE from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @Override
	else
	if exists (Select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @SurveyType)
	Select @StrParam = STRPARAM_VALUE, @NumParam = NUMPARAM_VALUE, @DatParam = DATPARAM_VALUE from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @SurveyType
	else
	if exists (select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName)
	Select @StrParam = STRPARAM_VALUE, @NumParam = NUMPARAM_VALUE, @DatParam = DATPARAM_VALUE from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName 
	else
	Select @StrParam = '', @NumParam = null, @DatParam = null

	if @DatParam is not null
	set @Resultvar = convert(varchar, @DatParam)
	else 
	if @NumParam is not null
	set @Resultvar = convert(varchar, @NumParam)
	else
	set @Resultvar = @StrParam

	if @ResultVar = 'QMFolderColorByPriority' and @Survey_id is not null
	begin
		IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'QMFolderColorByPriority'
                    AND Routine_Type = 'FUNCTION' ) 		
			begin
				set @ResultVar = dbo.QMFolderColorByPriority(@Survey_id)
			end
	end

	Return @Resultvar
END