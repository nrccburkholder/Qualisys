USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_EnglishOrSpanish]    Script Date: 8/13/2014 1:38:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_EnglishOrFrench]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

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

--check to make sure only english or french is used on survey
		INSERT INTO #M (Error, strMessage)
		SELECT 1, l.Language + ' is not a valid Language for this survey'
		FROM Languages l, SEL_QSTNS sq
		WHERE l.LangID = sq.LANGUAGE and
		  sq.SURVEY_ID = @Survey_id and
		  l.LangID not in (1,6)

SELECT * FROM #M

DROP TABLE #M
