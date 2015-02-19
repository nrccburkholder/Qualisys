USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplePeriods]    Script Date: 8/13/2014 1:43:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_SamplePeriods]
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


declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

IF @surveyType_id in (@CIHI)
	BEGIN
		--check to make sure the sample period is at lest three consecutive months
		INSERT INTO #M (Error, strMessage)
		select  1, p1.strPeriodDef_nm + ' must be at least three consecutive months.'
		from PeriodDef p1
		where p1.Survey_id = @Survey_id and
		DATEDIFF(MONTH, [datExpectedEncStart], DateAdd(d,1,[datExpectedEncEnd])) >= 3
		and p1.intExpectedSamples <> 1
	END
	ELSE
	BEGIN 

		--check to make sure only one sample period on survey
		INSERT INTO #M (Error, strMessage)
		select  1, p1.strPeriodDef_nm + ' has more than one Sample in one period.'
		from PeriodDef p1
		where p1.Survey_id = @Survey_id and
		  p1.intExpectedSamples <> 1
	END

SELECT * FROM #M

DROP TABLE #M
