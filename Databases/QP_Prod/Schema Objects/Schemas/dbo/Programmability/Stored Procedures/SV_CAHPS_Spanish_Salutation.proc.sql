USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SkipPatterns]    Script Date: 8/13/2014 1:46:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_Spanish_Salutation]
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
/*
-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8
*/

declare @HCAHPS int
SET @HCAHPS = 2

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

-- Check for code 926 rather than 800 for Spanish Salutation
if (@surveyType_id = @HCAHPS) 
	and exists(select 1 from sel_textbox where survey_id = @survey_id and language = 19 /*HCAHPS Spanish*/)
		if exists(	select 1 from sel_textbox
			where survey_id = @survey_id
			and richtext like '%{800\}%'
		)
			INSERT INTO #M (Error, strMessage)
			SELECT 1, 'Survey uses prohibited Spanish salutation text box code (800)'
		ELSE
			if exists(	select 1 from sel_textbox
				where survey_id = @survey_id
				and richtext like '%{926\}%'
			)
				INSERT INTO #M (Error, strMessage)
				SELECT 0, 'Survey uses approved Spanish salutation text box code (926)'

-- End Spanish Salutation

SELECT * FROM #M

DROP TABLE #M

GO


