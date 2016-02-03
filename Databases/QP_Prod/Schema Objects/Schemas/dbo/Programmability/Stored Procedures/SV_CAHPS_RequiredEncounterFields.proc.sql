USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredEncounterFields]    Script Date: 8/13/2014 1:42:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

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


--Make sure required fields are a part of the study (Encounter Fields)
	INSERT INTO #M (Error, strMessage)
	SELECT 1,a.strField_nm+' is not an Encounter field in the data structure.'
	FROM (SELECT Field_id, strField_nm
		  FROM MetaField
		  WHERE strField_nm IN (SELECT [ColumnName] 
								FROM SurveyValidationFields
								WHERE SurveyType_Id = @surveyType_id
								AND TableName = 'ENCOUNTER'
								AND bitActive = 1)) a
		  LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
					 WHERE sd.Survey_id=@Survey_id
					 AND sd.Study_id=m.Study_id
	   AND m.strTable_nm = 'ENCOUNTER') b
	ON a.strField_nm=b.strField_nm
	WHERE b.strField_nm IS NULL
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'All Encounter ' + @SurveyTypeDescription + ' fields are in the data structure'

SELECT * FROM #M

DROP TABLE #M
