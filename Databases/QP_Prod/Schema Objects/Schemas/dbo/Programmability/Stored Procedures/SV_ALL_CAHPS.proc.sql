USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_ALL_CAHPS]    Script Date: 7/22/2014 8:58:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_ALL_CAHPS]
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

IF @SurveyType_id not in (@ACOCAHPS,@CGCAHPS,@HCAHPS,@HHCAHPS,@ICHCAHPS)
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

--Make sure we have at least one sampleunit (ALL CAHPS)
IF (SELECT COUNT(*)
    FROM SampleUnit su, SamplePlan sp
    WHERE sp.Survey_id=@Survey_id
    AND sp.SamplePlan_id=su.SamplePlan_id
    AND su.CAHPSType_id = @surveyType_id)<1
INSERT INTO #M (Error, strMessage)
SELECT 1,'Survey must have at least one ' + @SurveyTypeDescription + ' Sampleunit.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0,'Survey has one ' + @SurveyTypeDescription + ' Sampleunit.'


--Check the active methodology  (ALL CAHPS)
CREATE TABLE #ActiveMethodology (standardmethodologyid INT)

INSERT INTO #ActiveMethodology
SELECT standardmethodologyid
FROM MailingMethodology (NOLOCK)
WHERE Survey_id=@Survey_id
AND bitActiveMethodology=1

IF @@ROWCOUNT<>1
 INSERT INTO #M (Error, strMessage)
 SELECT 1,'There must be exactly 1 active methodology.'
ELSE
BEGIN
 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid = 5) -- 5 is custom methodology
  INSERT INTO #M (Error, strMessage)
  SELECT 2,'Survey uses a custom methodology.'         -- a warning

 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology
   WHERE standardmethodologyid in (select StandardMethodologyID
     from StandardMethodologyBySurveyType where SurveyType_id = @surveyType_id
    )
   )
  INSERT INTO #M (Error, strMessage)
  SELECT 0,'Survey uses a standard ' + @SurveyTypeDescription + ' methodology.'
 ELSE
  INSERT INTO #M (Error, strMessage)
  SELECT 2,'Survey does not use a standard ' + @SurveyTypeDescription + ' methodology.'   -- a warning     
END

DROP TABLE #ActiveMethodology


----Validate Mode Mapping
DECLARE @MappedCount INT

SELECT @MappedCount = Count(*)
FROM ModeSectionMapping
WHERE Survey_Id = @Survey_Id

IF @MappedCount > 0
BEGIN

	CREATE TABLE #MailingStepMethod (Survey_Id INT, MailingStepMethod_id INT, MailingStepMethod_nm varchar(60))

	INSERT INTO #MailingStepMethod
	select distinct mm.SURVEY_ID, msm.MailingStepMethod_id, msm.MailingStepMethod_nm
	from mailingstepmethod msm
	INNER JOIN mailingstep ms ON msm.mailingstepmethod_id = ms.mailingstepmethod_id
	INNER JOIN mailingmethodology mm ON ms.methodology_id = mm.methodology_id
	where mm.bitactivemethodology = 1
	and (ms.bitsendsurvey = 1 or msm.isnonmailgeneration = 1)
	and mm.survey_id =  @Survey_Id

	CREATE TABLE #MappedModes (ModeName varchar(60))

	INSERT INTO #MappedModes
	select distinct msm.MailingStepMethod_nm
	from #mailingstepmethod msm
	LEFT JOIN ModeSectionMapping mode on (msm.MailingStepMethod_id = mode.MailingStepMethod_Id and mode.Survey_Id = @Survey_Id)
	where mode.ID is null

	DECLARE @ModeName varchar(60)

	SELECT TOP 1 @ModeName = ModeName
	FROM #MappedModes

	WHILE @@rowcount>0
	BEGIN

		INSERT INTO #M (Error, strMessage)
			SELECT 2,'Mode Type "'+ LTRIM(RTRIM(@ModeName)) +'" exists and is not mapped to a Question section. '
		 
		DELETE
		FROM #MappedModes
		WHERE ModeName=@ModeName

		SELECT TOP 1 @ModeName = ModeName
		FROM #MappedModes

	END

	DROP TABLE #MailingStepMethod
	DROP TABLE #MappedModes

END

-- Now we only work with Non-CGCAHPS stuff
IF @surveyType_id in (@ACOCAHPS, @HHCAHPS, @HCAHPS, @ICHCAHPS)
BEGIN

	IF @surveyType_id in (@HHCAHPS)
	BEGIN
		--Make sure the required fields are a part of the study (Population Fields)
		INSERT INTO #M (Error, strMessage)
		SELECT 1,a.strField_nm+' is not a field in the data structure.'
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
	END

	--Make sure required fields are a part of the study (Encounter Fields)
	INSERT INTO #M (Error, strMessage)
	SELECT 1,a.strField_nm+' is not a field in the data structure.'
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

	--Make sure skip patterns are enforced.
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'Skip Patterns are not enforced.'
	FROM Survey_def
	WHERE Survey_id=@Survey_id
	AND bitEnforceSkip=0
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'Skip Patterns are enforced'

	IF @surveyType_id in (@HCAHPS)
	BEGIN
		--Check the ReSurvey Method
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Resurvey Method is not set to Calendar Month.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND ReSurveyMethod_id<>2
	END

	IF @surveyType_id in (@HHCAHPS)
	BEGIN

		--Check the ReSurvey Method
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Resurvey Method is not set to Calendar Month.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND ReSurveyMethod_id<>2

		--check resurvey Exclusion Type
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your resurvey exclusion Method is not set to months.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND ReSurveyMethod_id<>2

		--Check resurvey Exclusion months
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your resurvey exclusion Month is not set to 6 months.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND INTRESURVEY_PERIOD<>6

	END

	IF @surveyType_id in (@ICHCAHPS)
	BEGIN
		--check resurvey Exclusion Type
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your resurvey exclusion Method is not set to Days.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND ReSurveyMethod_id<>1

		--Check resurvey Exclusion Period
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your resurvey exclusion Period is not set to 0 Days.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND INTRESURVEY_PERIOD<>0
	END


	IF @surveyType_id in (@ACOCAHPS)
	BEGIN
		--Check the ReSurvey Method                                                         
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Resurvey Method is not set to Resurvey Days.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND ReSurveyMethod_id<>(select ReSurveyMethod_id from ReSurveyMethod where ReSurveyMethodName = 'Resurvey Days')
	END


	IF @surveyType_id in (@HCAHPS)
	BEGIN
		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is not defined.'
		FROM Survey_def sd LEFT JOIN HouseHoldRule hhr
		ON sd.Survey_id=hhr.Survey_id
		WHERE sd.Survey_id=@Survey_id
		AND hhr.Survey_id IS NULL

		--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns
		INSERT INTO #M (Error, strMessage)
		SELECT 1,strField_nm+' is not a householding column.'
		FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a
		  LEFT JOIN HouseHoldRule hhr
		ON a.Field_id=hhr.Field_id
		AND hhr.Survey_id=@Survey_id
		WHERE hhr.Field_id IS NULL

		--Is AHA_id populated?
		IF EXISTS (SELECT *
				   FROM (SELECT SampleUnit_id, SUFacility_id
						 FROM SamplePlan sp, SampleUnit su
						 WHERE sp.Survey_id=@Survey_id
						   AND sp.SamplePlan_id=su.SamplePlan_id
						   AND CAHPSType_id  = @surveyType_id) a
						LEFT JOIN SUFacility f
							   ON a.SUFacility_id=f.SUFacility_id
				   WHERE f.AHA_id IS NULL)
		INSERT INTO #M (Error, strMessage)
		SELECT 2,'At least one ' + @SurveyTypeDescription + ' Sampleunit does not have an AHA value.'

	END

	IF @surveyType_id in (@ACOCAHPS)
	BEGIN
		--Make sure the reporting date is ACO_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
			FROM Survey_def sd, MetaTable mt
		 WHERE sd.sampleEncounterTable_id=mt.Table_id
			  AND  sd.Survey_id=@Survey_id
			  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ACO_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ACO_FieldDate.'
	END

	IF @surveyType_id in (@ICHCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ICH_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ICH_FieldDate.'
	END

	IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS)
	BEGIN
		--What is the sampling method                                                        
		if exists(select 1 from PeriodDef where survey_id=@survey_id and SamplingMethod_id <> (select SamplingMethod_id from SamplingMethod where strSamplingMethod_nm = 'Census'))
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your sampling method is not Census.'

		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is defined and should not be.'
		FROM HouseHoldRule hhr
		WHERE hhr.Survey_id=@Survey_id
	END



	IF @surveyType_id in (@HHCAHPS)
	BEGIN
		--Check that all HHCAHPS sampleunits have targets assigned.
		INSERT INTO #M (Error, strMessage)
		SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a target return specified.'
		FROM SamplePlan sp, SampleUnit su
		WHERE sp.Survey_id=@Survey_id
		AND sp.SamplePlan_id=su.SamplePlan_id
		AND su.CAHPSType_id = @surveyType_id and INTTARGETRETURN = 0
	END

	IF @surveyType_id in (@HCAHPS, @HHCAHPS,@ICHCAHPS)
	BEGIN
		--What is the sampling algorithm
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your sampling algorithm is not StaticPlus.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND SamplingAlgorithmID<>3
	END

	IF @surveyType_id in (@HCAHPS, @HHCAHPS)
	BEGIN
		--Make sure the Medicare number is populated.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Medicare number is not populated.'
		FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
		ON su.SUFacility_id=suf.SUFacility_id
		WHERE sp.Survey_id=@Survey_id
		AND sp.SamplePlan_id=su.SamplePlan_id
		AND su.bitHHCAHPS=1
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

		IF @surveyType_id in (@HHCAHPS)
		BEGIN
			--make sure the medicare number is populated
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
		END

		--Check that FacilityState is populated for the HCAHPS & HHCAHPS units.
		INSERT INTO #M (Error, strMessage)
		SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a state designated.'
		FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
		ON su.SUFacility_id=suf.SUFacility_id
		WHERE sp.Survey_id=@Survey_id
		AND sp.SamplePlan_id=su.SamplePlan_id
		AND su.CAHPSType_id = @surveyType_id
		AND suf.State IS NULL

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

	--Make sure all of the CAHPS questions are on the form and in the correct location.
	CREATE TABLE #CurrentForm (
		Order_id INT IDENTITY(1,1),
		QstnCore INT,
		Section_id INT,
		Subsection INT,
		Item INT
	)

	--Get the questions currently on the form
	INSERT INTO #CurrentForm (QstnCore, Section_id, Subsection, Item)
	SELECT QstnCore, Section_id, Subsection, Item
	FROM Sel_Qstns
	WHERE Survey_id=@Survey_id
	  AND SubType in (1,4)
	  AND Language=1
	  AND (Height>0 OR Height IS NULL)
	ORDER BY Section_id, Subsection, Item

	--Check for expanded questions
	--If they exist on survey, then pull question list that includes expanded questions (bitExpanded = 1)
	declare @bitExpanded int

	CREATE TABLE #CAHPS_SurveyTypeQuestionMappings(
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL)

	IF @surveyType_id in (@ACOCAHPS, @HCAHPS)
	BEGIN

		select @bitExpanded = isnull((select top 1 1 from #currentform where qstncore in (46863,46864,46865,46866,46867)),0) 

	--If active sample period is after 1/1/2013, then the survey should be using expanded questions (bitExpanded = 1)
	--**************************************************
	--** Code from QCL_SelectActivePeriodbySurveyId
	--**************************************************
		create table #periods (perioddef_id int, activeperiod bit)

		--Get a list of all periods for this survey
		INSERT INTO #periods (periodDef_id)
		SELECT periodDef_id
		FROM perioddef
		WHERE survey_id=@survey_id

		--Get a list of all periods that have not completed sampling
		SELECT distinct pd.PeriodDef_id
		INTO #temp
		FROM perioddef p, perioddates pd
		WHERE p.perioddef_id=pd.perioddef_id AND
				survey_id=@survey_id AND
	  			datsampleCREATE_dt is null

		--Find the active Period.  It is either a period that hasn't completed sampling
		--or a period that hasn't started but has the most recent first scheduled date
		--If no unfinished periods exist, set active period to the period with the most
		--recently completed sample

		IF EXISTS (SELECT top 1 *
					FROM #temp)
		BEGIN

			DECLARE @UnfinishedPeriod int

			SELECT @UnfinishedPeriod=pd.perioddef_id
			FROM perioddates pd, #temp t
			WHERE pd.perioddef_id=t.perioddef_id AND
		  			pd.samplenumber=1 AND
					pd.datsampleCREATE_dt is not null

			IF @UnfinishedPeriod is not null
			BEGIN
				--There is a period that is partially finished, so set it to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id = @UnfinishedPeriod
			END
			ELSE
			BEGIN
				--There is no period that is partially finished, so set the unstarted period
				--with the earliest scheduled sample date to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id =
					(SELECT top 1 pd.perioddef_id
					 FROM perioddates pd, #temp t
					 WHERE pd.perioddef_id=t.perioddef_id AND
				  			pd.samplenumber=1
					 ORDER BY datscheduledsample_dt)
			END
		END
		ELSE
		BEGIN
			--No unfinished periods exist, so we will set the active to be the most recently
			--finished
			UPDATE #periods
			SET ActivePeriod=1
			WHERE perioddef_id =
				(SELECT top 1 p.perioddef_id
				 FROM perioddates pd, perioddef p
				 WHERE p.survey_id=@survey_id AND
						pd.perioddef_id=p.perioddef_id
				 GROUP BY p.perioddef_id
				 ORDER BY Max(datsampleCREATE_dt) desc)
		END

		IF @surveyType_id in (@HCAHPS)
		BEGIN
			if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
				select @bitExpanded = 1 ---(HCAHPS specific)
		END

		drop table #periods
		drop table #temp

		--Create subset SurveyTypeQuestionMappings looking at only surveyType
		INSERT INTO #CAHPS_SurveyTypeQuestionMappings
		Select surveytype_id, qstncore, intorder, bitfirstonform
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id 
		and bitExpanded = @bitExpanded

	END
	ELSE
	BEGIN
		INSERT INTO #CAHPS_SurveyTypeQuestionMappings
		Select surveytype_id, qstncore, intorder, bitfirstonform
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id
	END

	--Look for questions missing from the form.
	IF @surveyType_id IN (@ACOCAHPS)
	BEGIN

		DECLARE @cnt50715 INT
		DECLARE @cnt50255 INT

		SELECT
		 @cnt50715 = SUM( CASE s.QstnCore WHEN 50715 THEN 1 ELSE 0 END),
		 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL and s.QstnCore NOT IN (50715,50255)

	END

	IF @surveyType_id IN (@HCAHPS)
	BEGIN

		DECLARE @cnt43350 INT
		DECLARE @cnt50860 INT
		SELECT
		 @cnt43350 = SUM( CASE s.QstnCore WHEN 43350 THEN 1 ELSE 0 END),
		 @cnt50860 = SUM( CASE s.QstnCore WHEN 50860 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		IF @cnt43350 = 0 AND @cnt50860 = 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both missing.  You must have either 43350 or 50860, but not both.')
		END
		IF @cnt43350 > 0 AND @cnt50860 > 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both assigned.  You must have either 43350 or 50860, but not both.')
		END

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		AND t.QstnCore IS NULL and s.QstnCore NOT IN (43350,50860)

	END

	IF @surveyType_id = @HHCAHPS
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END


	--Look for questions that are out of order.
	--First the questions that have to be at the beginning of the form.
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
	FROM #CAHPS_SurveyTypeQuestionMappings s 
	LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
	AND s.intOrder=t.Order_id
	AND s.SurveyType_id= @surveyType_id
	WHERE bitFirstOnForm=1
	AND t.QstnCore IS NULL

	--Now the questions that are at the end of the form.
	SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	INTO #OrderCheck
	from #CAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
	WHERE qm.SurveyType_id = @surveyType_id
	AND bitFirstOnForm=0
	AND qm.QstnCore=t.QstnCore

	DECLARE @OrderDifference INT

	SELECT @OrderDifference=OrderDiff
	FROM #OrderCheck
	WHERE OverAllOrder=1

	INSERT INTO #M (Error, strMessage)
	SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'
	FROM #OrderCheck
	WHERE OrderDiff<>@OrderDifference

	DROP TABLE #OrderCheck
	
	DROP TABLE #CurrentForm

	IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
	BEGIN
	 INSERT INTO #M (Error, strMessage)
	 SELECT 0,'All ' + @SurveyTypeDescription + ' Questions are on the form in the correct order.'

	 --IF all cores or on the survey, then check that the questions are mapped
	 --in a manner that ensures someone sampled at the units will get all of them
	 SELECT sampleunit_id
	 into #CAHPSUnits
	 FROM SampleUnit su, SamplePlan sp
	 WHERE sp.Survey_id=@Survey_id
	 AND sp.SamplePlan_id=su.SamplePlan_id
	 AND CAHPSType_id = @surveyType_id

	 DECLARE @sampleunit_id int

	 SELECT TOP 1 @sampleunit_id=sampleunit_id
	 FROM #CAHPSUnits

	 WHILE @@rowcount>0
	 BEGIN

		INSERT INTO #M (Error, strMessage)
		 SELECT 1,'QstnCore '+LTRIM(STR(a.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,523) +' or one of its ancestor units.'
		 from
		 (
		  SELECT stqm.QstnCore, intOrder
		  FROM
		  (
		   SELECT sq.Qstncore
		   FROM SAMPLEUNITTREEINDEX si JOIN sampleunitsection su
			ON si.sampleunit_id=@sampleunit_id
			 AND si.ancestorunit_id=su.sampleunit_id
			JOIN sel_qstns sq
			ON sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		   union
		   SELECT sq.Qstncore
		   FROM sampleunitsection su JOIN sel_qstns sq
			ON su.sampleunit_id=@sampleunit_id
			 AND sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		  ) as Q  RIGHT JOIN #CAHPS_SurveyTypeQuestionMappings stqm
		  ON Q.QstnCore=stqm.QstnCore
		  WHERE stqm.SurveyType_id=@surveyType_id AND Q.QstnCore IS NULL
		 ) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

		  IF @@ROWCOUNT=0
		   INSERT INTO #M (Error, strMessage)
		   SELECT 0,'All Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)

		  DELETE
		  FROM #CAHPSUnits
		  WHERE sampleunit_Id=@sampleunit_id

		  SELECT TOP 1 @sampleunit_id=sampleunit_id
		  FROM #CAHPSUnits

	 END

	 DROP TABLE #CAHPSUnits
	 DROP TABLE #CAHPS_SurveyTypeQuestionMappings

	END
	--End of Question checking

	IF @surveyType_id in (@HHCAHPS)
	BEGIN
		--check to make sure only english or hcahps spanish is used on HHACAHPS survey
		INSERT INTO #M (Error, strMessage)
		SELECT 1, l.Language + ' is not a valid Language for a HHCAHPS survey'
		FROM Languages l, SEL_QSTNS sq
		WHERE l.LangID = sq.LANGUAGE and
		  sq.SURVEY_ID = @Survey_id and
		  l.LangID not in (1,19)

		--check to make sure only one sample period on HHACAHPS survey
		INSERT INTO #M (Error, strMessage)
		select  1, p1.strPeriodDef_nm + ' has more than one Sample in one period.'
		from PeriodDef p1
		where p1.Survey_id = @Survey_id and
		  p1.intExpectedSamples <> 1
	END

	-- Check DQ Rules
	----Now check for Addr Error DQ rule
	IF @surveyType_id in (@HCAHPS)
	BEGIN

		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'FO'
					 AND br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr = "FO").'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ rule (AddrErr = "FO").'
	END

	IF @surveyType_id in (@HHCAHPS)
	BEGIN

		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'FO'
					 AND br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has DQ rule (AddrErr = "FO").'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule (AddrErr = "FO").'
	END

	IF @surveyType_id in (@ACOCAHPS)
	BEGIN
		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br
					 WHERE br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has a DQ or other Business Rule and should not.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule.'
	END

	IF @surveyType_id IN (@HHCAHPS)
	BEGIN
		--get Encounter MetaTable_ID this is so we can check for field existance before we check for
		--DQ rules.  If the field is not in the data structure we do not want to check for the error.
		SELECT @EncTable_ID = mt.Table_id
		FROM dbo.MetaTable mt
		WHERE mt.strTable_nm = 'ENCOUNTER'
		  AND mt.Study_id = @Study_id


		--check for DQ_Payer Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Payer'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
		 SELECT 0,'Survey has DQ_Payer rule (HHPay_Mcare <> ''1'' AND HHPay_Mcaid <> ''1'').'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does DQ_Payer rule (HHPay_Mcare <> ''1'' AND HHPay_Mcaid <> ''1'').'


		 --Check for DQ_visMo rules
		IF EXISTS (SELECT BusinessRule_id
			 FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			 WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			AND cc.Field_id = mf.Field_id
			AND cc.intOperator = op.Operator_Num
			AND mf.strField_Nm = 'HHVisitCnt'
			AND op.strOperator = '<'
			AND cc.strLowValue = '1'
			AND br.Survey_id = @Survey_id
		   )

		 INSERT INTO #M (Error, strMessage)
		 SELECT 0,'Survey has DQ_VisMo rule (HHVisitCnt < 1).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ_VisMo rule (HHVisitCnt < 1).'

		 --Check for DQ_Hospc rules
		 IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHHospice')
		BEGIN
		 IF EXISTS (SELECT BusinessRule_id
			  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			 AND cc.Field_id = mf.Field_id
			 AND cc.intOperator = op.Operator_Num
			 AND mf.strField_Nm = 'HHHospice'
			 AND op.strOperator = '='
			 AND cc.strLowValue = 'Y'
			 AND br.Survey_id = @Survey_id
			)

		  INSERT INTO #M (Error, strMessage)
		  SELECT 0,'Survey has DQ_Hospc rule (ENCOUNTERHHHospice = "Y").'
		 ELSE
		  INSERT INTO #M (Error, strMessage)
		  SELECT 1,'Survey does not have DQ_Hospc rule (ENCOUNTERHHHospice = "Y").'

		END

		 --Check for DQ_VisLk rules
		if exists ( SELECT BusinessRule_id
					FROM BusinessRule br
					inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
					inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
					inner join MetaField mf on cc.Field_id = mf.Field_id
					inner join Operator op on cc.intOperator = op.Operator_Num
					inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
					WHERE mf.strField_Nm = 'HHLookBackCnt'
					AND op.strOperator = 'IN'
					--AND br.Survey_id = @Survey_id
					group by BusinessRule_id
					having count(*)=2 and min(strListValue) = '0' and max(strListValue)= '1'
					)
		INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_VisLk rule (ENCOUNTERHHLookbackCnt IN (0,1) ).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_VisLk rule (ENCOUNTERHHLookbackCnt IN (0,1) ).'

		--Check for DQ_Age rules
		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HHEOMAge'
					 AND op.strOperator = '<'
					 AND cc.strLowValue = '18'
		   AND br.Survey_id = @Survey_id
		   )

			INSERT INTO #M (Error, strMessage)
		SELECT 0,'Survey has DQ_Age rule (ENCOUNTERHHEOMAge < 18).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Age rule (ENCOUNTERHHEOMAge < 18).'


		--Check for DQ_Mat rules
		 IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHMaternity')
		BEGIN
			IF EXISTS (SELECT BusinessRule_id
				FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
				AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
				AND cc.Field_id = mf.Field_id
				AND cc.intOperator = op.Operator_Num
				AND mf.strField_Nm = 'HHMaternity'
				AND op.strOperator = '='
				AND cc.strLowValue = 'Y'
				AND br.Survey_id = @Survey_id
			)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Mat rule (ENCOUNTERHHMaternity = "Y").'
			ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Mat rule (ENCOUNTERHHMaternity = "Y").'
		END

		IF EXISTS (SELECT Field_id
           FROM dbo.MetaData_View
           WHERE Table_id = @EncTable_ID
			AND Study_id = @Study_id
			AND strField_nm = 'HHNoPub')
		BEGIN
		   --Check for DQ_NoPub rules
			 IF EXISTS (SELECT BusinessRule_id
				  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
				 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
				 AND cc.Field_id = mf.Field_id
				 AND cc.intOperator = op.Operator_Num
				 AND mf.strField_Nm = 'HHNoPub'
				 AND op.strOperator = '='
				 AND cc.strLowValue = 'Y'
				 AND br.Survey_id = @Survey_id
				)

			  INSERT INTO #M (Error, strMessage)
			  SELECT 0,'Survey has DQ_NoPub rule (ENCOUNTERHHNoPub = "Y").'
			 ELSE
			  INSERT INTO #M (Error, strMessage)
			  SELECT 1,'Survey does not have DQ_NoPub rule (ENCOUNTERHHNoPub = "Y").'

		END
		-- Check for DQ_Dead
		IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHDeceased')
		BEGIN
		 IF EXISTS (SELECT BusinessRule_id
			  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			 AND cc.Field_id = mf.Field_id
			 AND cc.intOperator = op.Operator_Num
			 AND mf.strField_Nm = 'HHDeceased'
			 AND op.strOperator = '='
			 AND cc.strLowValue = 'Y'
			 AND br.Survey_id = @Survey_id
			)

		  INSERT INTO #M (Error, strMessage)
		  SELECT 0,'Survey has DQ_Dead rule (ENCOUNTERHHDeceased = "Y").'
		 ELSE
		  INSERT INTO #M (Error, strMessage)
		  SELECT 1,'Survey does not have DQ_Dead rule (ENCOUNTERHHDeceased = "Y").'
		END

	END

	IF @surveyType_id IN (@HCAHPS)
	BEGIN

		--check for DQ_Law rule
		IF EXISTS (	select *
					from (SELECT BusinessRule_id, cc.CriteriaPhrase_id
						   FROM BusinessRule br
						   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
						   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
						   inner join MetaField mf on cc.Field_id = mf.Field_id
						   inner join Operator op on cc.intOperator = op.Operator_Num
						   WHERE mf.strField_Nm = 'HAdmissionSource'
							 AND op.strOperator = '='
							 AND cc.strLowValue = '8'
							 AND br.Survey_id = @Survey_id
							) admit
					inner join (SELECT BusinessRule_id, cc.criteriaphrase_id
							   FROM BusinessRule br
							   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
							   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
							   inner join MetaField mf on cc.Field_id = mf.Field_id
							   inner join Operator op on cc.intOperator = op.Operator_Num
							   inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
							   WHERE mf.strField_Nm = 'HDischargeStatus'
								 AND op.strOperator = 'IN'
								 AND br.Survey_id = @Survey_id
							   group by BusinessRule_id, cc.criteriaclause_id, cc.criteriaphrase_id
							   having count(*)=2 and min(strListValue) = '21' and max(strListValue)= '87'
							   ) dischg
					 on admit.BusinessRule_id=dischg.BusinessRule_id 
						and admit.CriteriaPhrase_id <> dischg.CriteriaPhrase_id --> different CriteriaPhrase_id's means they have an OR relationship.
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Law rule (ENCOUNTERHAdmissionSource = 8 OR ENCOUNTERHDischargeStatus in ("21", "87")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Law rule (ENCOUNTERHAdmissionSource = 8 OR ENCOUNTERHDischargeStatus in ("21", "87")).'


		--check for DQ_SNF rule
		IF EXISTS
		(
		 SELECT br.BUSINESSRULE_ID--, cs.strCriteriaStmt_nm, count(*), min(strListValue),max(strListValue),round(stdev(convert(int,strlistvalue)),6)
		  FROM BusinessRule br
		  inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
		  inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
		  inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
		  inner join MetaField mf on cc.Field_id = mf.Field_id
		  inner join Operator op on cc.intOperator = op.Operator_Num
		  WHERE mf.strField_Nm = 'HDischargeStatus'
		   AND op.strOperator = 'IN'
		   AND br.Survey_id = @Survey_id
		  GROUP BY br.BUSINESSRULE_ID
		  having count(*)=6 and min(strListValue) = '03' and max(strListValue)= '92' and round(stdev(convert(int,strlistvalue)),6)=38.940981
		  -- the STDEV of (3, 3, 61, 64, 83, 92) is 38.940981. Another combination of 6 integers with 3 as the min and 92 as the max would come up with a different STDEV
		)
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'


		--check for DQ_Hospc rule
		if exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
			  AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = '50'
					 AND br.Survey_id = @Survey_id
		   )
		AND exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = '51'
					 AND br.Survey_id = @Survey_id
		   )

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Hospc rule (ENCOUNTERHDischargeStatus in ("50", "51")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Hospc rule (ENCOUNTERHDischargeStatus in ("50", "51")).'


		--check for DQ_Dead rule
		if exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br
				   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
				   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
				   inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
				   inner join MetaField mf on cc.Field_id = mf.Field_id
				   inner join Operator op on cc.intOperator = op.Operator_Num
				   WHERE mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND br.Survey_id = @Survey_id
				   group by BusinessRule_id, cc.criteriaclause_id
				   having count(*)=4 and min(strListValue) = '20' and max(strListValue)= '42' and round(stdev(convert(int,strlistvalue)),6)=10.531698
				   -- the STDEV of (20, 40, 41, 42) is 10.531698. Another combination of 4 integers that has 20 as the min and 40 as the max would come up with a different STDEV
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Dead rule (ENCOUNTERHDischargeStatus in ("20", "40", "41", "42")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Dead rule (ENCOUNTERHDischargeStatus in ("20", "40", "41", "42")).'

	END

END
--End of Non-CGCAHPS validation

SELECT * FROM #M

DROP TABLE #M

GO


