USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Resurvey]    Script Date: 8/14/2014 10:25:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_Resurvey]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

declare @ResurveyExclusionPeriod int
declare @ResurveyMethod_int int
declare @ResurveyMethodName varchar(50)

SET @ResurveyExclusionPeriod = dbo.SurveyProperty('ResurveyExclusionPeriodsNumericDefault', NUll, @Survey_id)
SET @ResurveyMethod_int = dbo.SurveyProperty('ResurveyMethodDefault', Null, @Survey_id)

SELECT @ResurveyMethodName = ReSurveyMethod.ReSurveyMethodName from ReSurveyMethod where ReSurveyMethod_id = @ResurveyMethod_int

	--Check the ReSurvey Method
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'Resurvey Method is not set to ' + @ResurveyMethodName +'.'
	FROM Survey_def
	WHERE Survey_id=@Survey_id
	AND ReSurveyMethod_id <> @ResurveyMethod_int


	IF (@surveyType_id in (@HHCAHPS, @ICHCAHPS)) or (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType)
	BEGIN

		--Check resurvey Exclusion months
		INSERT INTO #M (Error, strMessage)
		SELECT 1,
		CASE @ResurveyMethod_int 
			WHEN 1 THEN 'Resurvey Days is not '+ CAST(@ResurveyExclusionPeriod as varchar)+ '.'
			WHEN 2 THEN 'Your resurvey exclusion Month is not set to ' + CAST(@ResurveyExclusionPeriod as varchar) + ' months.'
		END
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND INTRESURVEY_PERIOD<>@ResurveyExclusionPeriod

	END

SELECT * FROM #M

DROP TABLE #M