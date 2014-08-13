USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_MedicareNumber]    Script Date: 8/13/2014 1:41:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_MedicareNumber]
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

--Make sure the Medicare number is populated.
INSERT INTO #M (Error, strMessage)
SELECT 1,'Medicare number is not populated.'
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
ON su.SUFacility_id=suf.SUFacility_id
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.CAHPSType_id = @surveyType_id
AND (suf.MedicareNumber IS NULL
OR LTRIM(RTRIM(suf.MedicareNumber))='')
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Medicare number is populated'

--make sure the Medicare number is active
INSERT INTO #M (Error, strMessage)
SELECT 1,'Medicare number is not Active'
FROM SamplePlan sp, SampleUnit su,SUFacility suf, MedicareLookup ml
WHERE sp.Survey_id=@Survey_id
AND su.SUFacility_id=suf.SUFacility_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND ml.MedicareNumber = suf.MedicareNumber
AND su.CAHPSType_id = @surveyType_id
AND ml.Active = 0
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Medicare number is Active'


SELECT * FROM #M

DROP TABLE #M
GO


