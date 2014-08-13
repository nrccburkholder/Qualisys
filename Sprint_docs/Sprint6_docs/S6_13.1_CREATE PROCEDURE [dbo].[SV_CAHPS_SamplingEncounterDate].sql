USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingEncounterDate]    Script Date: 8/13/2014 1:44:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_SamplingEncounterDate]
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

IF @surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType
BEGIN
	IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date field must be MosRecVisDate.'
	ELSE
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date field must be MosRecVisDate.'
		FROM Survey_def sd, MetaTable mt
		WHERE sd.sampleEncounterTable_id=mt.Table_id
			AND  sd.Survey_id=@Survey_id
			AND sd.sampleEncounterField_id NOT IN (1649) 
	IF @@ROWCOUNT=0
		INSERT INTO #M (Error, strMessage)
		SELECT 0,'Sample Encounter Date field is MosRecVisDate.'
END
ELSE
BEGIN

	--Make sure the Sampling Encounter date is either ServiceDate or DischargeDate
	IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date Field has to be either Service or Discharge Date from the Encounter table.'
	ELSE
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date Field has to be either Service or Discharge Date from the Encounter table.'
		FROM Survey_def sd, MetaTable mt
		WHERE sd.sampleEncounterTable_id=mt.Table_id
			AND  sd.Survey_id=@Survey_id
			AND sd.sampleEncounterField_id NOT IN (54,117)
	IF @@ROWCOUNT=0
		INSERT INTO #M (Error, strMessage)
		SELECT 0,'Sample Encounter Date Field is set to either Service or Discharge Date.'
END

SELECT * FROM #M

DROP TABLE #M
GO


