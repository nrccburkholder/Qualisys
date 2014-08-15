USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredPopulationFields]    Script Date: 8/13/2014 1:42:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
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

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the required fields are a part of the study (Population Fields)
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a Population field in the data structure.'
FROM (SELECT Field_id, strField_nm
		FROM MetaField
		WHERE strField_nm IN (SELECT [ColumnName] 
							FROM SurveyValidationFields
							WHERE SurveyType_Id = @surveyType_id
							AND TableName = 'POPULATION'
							AND bitActive = 1)) a
LEFT JOIN ( SELECT strField_nm 
			FROM MetaData_View m, Survey_def sd
			WHERE sd.Survey_id=@Survey_id
			AND sd.Study_id=m.Study_id
			AND m.strTable_nm = 'POPULATION') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL

IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All Population ' + @SurveyTypeDescription + ' fields are in the data structure'


SELECT * FROM #M

DROP TABLE #M
GO


