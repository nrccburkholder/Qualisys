/*

	S67 ATL-1219 CG-CAHPS Submission File Updates
	As a CG-CAHPS vendor, we need to create files following the updated specifications, so our data will be accepted.

	ATL-1388 Insert QstnCores into SuveyTypeQuestionMappings
	ATL-1387 Modify survey validation to include new question combinations

	Tim Butler
*/


USE [QP_Prod]
GO

DECLARE @Surveytype_id int
DECLARE @Subtype_id int = 0


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'


/*

6-month Child 3.0
6-month Adult 3.0

*/
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 3.0'

IF not exists (SELECT 1 from [dbo].[SurveyTypeQuestionMappings] where surveytype_id = @SurveyType_ID and QstnCore = 55064 and subtype_id = @subtype_id)
	INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])
	VALUES(@SurveyType_ID,55064,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)

IF not exists (SELECT 1 from [dbo].[SurveyTypeQuestionMappings] where surveytype_id = @SurveyType_ID and QstnCore = 55065 and subtype_id = @subtype_id)
	INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])
	VALUES(@SurveyType_ID,55065,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)


select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 3.0'

IF not exists (SELECT 1 from [dbo].[SurveyTypeQuestionMappings] where surveytype_id = @SurveyType_ID and QstnCore = 55064 and subtype_id = @subtype_id)
	INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])
	VALUES(@SurveyType_ID,55064,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)

GO

USE [QP_Prod]
GO


/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 1/23/2017 10:26:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
	02/25/2015 -- TSB:  modified the select into #CAHPS_SurveyTypeQuestionMappings to only include Questions whose datEncounterEnd_dt is 
				greater than today's date. This is related to S19 US19 which deactivated five question cores and added a new one.

	04/30/2015 -- TSB: modified CAHPS Type variables to come from SELECT from SurveyType to ensure Id consistency.  Changed @PCHMSubType to read from
				SubType table with name "PCMH Distinction".  S24 US13.1

	
	03/15/2016 -- S44 US 19 Modify Survey Validation for CGCAHPS QuestionForm.
					As an Implementation Associate, I want survey validation specific to CGCAHPS and specified questionnaire types, so that I can ensure the survey is set up compliantly
					TSB
	
	01/23/2017 -- S67  Modify Survey Validation for CGCAHPS QuestionForm.
					As an Implementation Associate, I want survey validation specific to CGCAHPS and specified questionnaire types, so that I can ensure the survey is set up compliantly
					TSB

*/

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

declare @CGCAHPS int
SELECT  @CGCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

declare @HCAHPS int
SELECT  @HCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'HCAHPS IP'

declare @HHCAHPS int
SELECT  @HHCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'Home Health CAHPS'

declare @ACOCAHPS int
SELECT  @ACOCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'

declare @ICHCAHPS int
SELECT  @ICHCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ICHCAHPS'

declare @hospiceCAHPS int
SELECT @hospiceCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'Hospice CAHPS'

declare @oasCAHPS int
SELECT @oasCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'OAS CAHPS'

declare @PCMHSubType int
SELECT @PCMHSubType = [Subtype_id]
FROM [dbo].[Subtype]
where [Subtype_nm] = 'PCMH Distinction'


declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

DECLARE @questionnaireType_id int
DECLARE @questionnaireType_nm varchar(50)

-- get any associated subtype_id that is has questionnaire category type
select  @questionnaireType_id = sst.subtype_id, @questionnaireType_nm = st.Subtype_nm
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 2

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

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
	[bitFirstOnForm] [bit] NULL,
	[SubType_id] [INT] NOT NULL)

	IF @surveyType_id in (@HCAHPS)
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
		Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id 
		and bitExpanded = @bitExpanded
		and [datEncounterEnd_dt] >= GETDATE()

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and [datEncounterEnd_dt] >= GETDATE()

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id
			and [datEncounterEnd_dt] >= GETDATE()

		END

	END

	--Look for questions missing from the form.
/*	IF @surveyType_id IN (@ACOCAHPS)
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
*/
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

		--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF @surveyType_id IN (@CGCAHPS)
	BEGIN

		DECLARE @cnt50531 INT
		DECLARE @cnt52325 INT

		IF @questionnaireType_nm = '6-month Child 2.0' or @questionnaireType_nm = '6-month Child 2.0 w/ PCMH'
		begin
		
			SELECT
			 @cnt50531 = SUM( CASE s.QstnCore WHEN 50531 THEN 1 ELSE 0 END),
			 @cnt52325 = SUM( CASE s.QstnCore WHEN 52325 THEN 1 ELSE 0 END)
			FROM #CAHPS_SurveyTypeQuestionMappings s 
			LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NOT NULL

			IF @cnt50531 = 0 AND @cnt52325 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50531 and 52325 are both missing.  You must have either 50531 or 52325, but not both.')
			END
			IF @cnt50531 > 0 AND @cnt52325 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50531 and 52325 are both assigned.  You must have either 50531 or 52325, but not both.')
			END

			INSERT INTO #M (Error, strMessage)
			SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
			FROM #CAHPS_SurveyTypeQuestionMappings s 
			LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NULL 
			and s.QstnCore NOT IN (50531,52325)
			

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 50531)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 52325

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 52325)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 50531

		end
		ELSE
		IF @questionnaireType_nm = '6-month Child 3.0' 
		begin

			DECLARE @cnt50532 INT
			DECLARE @cnt54052 INT

			SELECT
			 @cnt50531 = SUM( CASE s.QstnCore WHEN 50531 THEN 1 ELSE 0 END),
			 @cnt52325 = SUM( CASE s.QstnCore WHEN 52325 THEN 1 ELSE 0 END),
			 @cnt50532 = SUM( CASE s.QstnCore WHEN 50532 THEN 1 ELSE 0 END),
			 @cnt54052 = SUM( CASE s.QstnCore WHEN 54052 THEN 1 ELSE 0 END)
			FROM #CAHPS_SurveyTypeQuestionMappings s 
			LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NOT NULL

			IF @cnt50531 = 0 AND @cnt52325 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50531 and 52325 are both missing.  You must have either 50531 or 52325, but not both.')
			END
			IF @cnt50531 > 0 AND @cnt52325 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50531 and 52325 are both assigned.  You must have either 50531 or 52325, but not both.')
			END

			IF @cnt50532 = 0 AND @cnt54052 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50532 and 54052 are both missing.  You must have either 50532 or 54052, but not both.')
			END
			IF @cnt50532 > 0 AND @cnt54052 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50532 and 54052 are both assigned.  You must have either 50532 or 54052, but not both.')
			END

			INSERT INTO #M (Error, strMessage)
			SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
			FROM #CAHPS_SurveyTypeQuestionMappings s 
			LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NULL 
			and s.QstnCore NOT IN (50531,52325, 50532,54052)
			
			IF EXISTS (select 1 from #CurrentForm where QstnCore = 50532)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 54052

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 54052)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 50532

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 50531)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 52325

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 52325)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 50531

		end
		ELSE
		IF @questionnaireType_nm = '12-month Adult 2.0' or @questionnaireType_nm = '12-month Adult 2.0 w/ PCMH' 
		begin

			DECLARE @cnt44234 INT
			DECLARE @cnt48664 INT

			DECLARE @cnt44235 INT
			DECLARE @cnt48665 INT

			SELECT
			 @cnt44234 = SUM( CASE s.QstnCore WHEN 44234 THEN 1 ELSE 0 END),
			 @cnt48664 = SUM( CASE s.QstnCore WHEN 48664 THEN 1 ELSE 0 END),
			 @cnt44235 = SUM( CASE s.QstnCore WHEN 44235 THEN 1 ELSE 0 END),
			 @cnt48665 = SUM( CASE s.QstnCore WHEN 48665 THEN 1 ELSE 0 END)
			FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
			ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NOT NULL

			IF @cnt44234 = 0 AND @cnt48664 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 44234 and 48664 are both missing.  You must have either 44234 or 48664, but not both.')
			END
			IF @cnt44234 > 0 AND @cnt48664 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 44234 and 48664 are both assigned.  You must have either 44234 or 48664, but not both.')
			END

			IF @cnt44235 = 0 AND @cnt48665 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 44235 and 48665 are both missing.  You must have either 44235 or 48665, but not both.')
			END
			IF @cnt44235 > 0 AND @cnt48665 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 44235 and 48665 are both assigned.  You must have either 44235 or 48665, but not both.')
			END

			INSERT INTO #M (Error, strMessage)
			SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
			FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
			ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NULL 
			and s.QstnCore NOT IN (44234,48664,44235,48665)


			IF EXISTS (select 1 from #CurrentForm where QstnCore = 44234)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 48664

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 48664)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 44234

			IF EXISTS (select 1 from #CurrentForm where QstnCore =44235)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 48665

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 48665)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 44235

		end
		ELSE		
		IF @questionnaireType_nm = '6-month Adult 3.0' 
		begin

			DECLARE @cnt50253 INT
			DECLARE @cnt55064 INT

			DECLARE @cnt50255 INT
			DECLARE @cnt55065 INT


			SELECT
			 @cnt50253 = SUM( CASE s.QstnCore WHEN 50253 THEN 1 ELSE 0 END),
			 @cnt55064 = SUM( CASE s.QstnCore WHEN 55064 THEN 1 ELSE 0 END),
			 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END),
			 @cnt55065 = SUM( CASE s.QstnCore WHEN 55065 THEN 1 ELSE 0 END)
			FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
			ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NOT NULL


			IF @cnt50253 = 0 AND @cnt55064 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50253 and 55064 are both missing.  You must have either 50253 or 55064, but not both.')
			END
			IF @cnt50253 > 0 AND @cnt55064 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50253 and 55064 are both assigned.  You must have either 50253 or 55064, but not both.')
			END

			IF @cnt50255 = 0 AND @cnt55065 = 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50255 and 55065 are both missing.  You must have either 50255 or 55065, but not both.')
			END
			IF @cnt50255 > 0 AND @cnt55065 > 0
			BEGIN
			 INSERT INTO #M VALUES (1, 'QstnCore 50255 and 55065 are both assigned.  You must have either 50255 or 55065, but not both.')
			END

			INSERT INTO #M (Error, strMessage)
			SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
			FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
			ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnairetype_id
			AND t.QstnCore IS NULL 
			and s.QstnCore NOT IN (50253,55064,50255,55065)


			IF EXISTS (select 1 from #CurrentForm where QstnCore =50253)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 55064

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 55064)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 50253

			IF EXISTS (select 1 from #CurrentForm where QstnCore =50255)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 55065

			IF EXISTS (select 1 from #CurrentForm where QstnCore = 55065)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore = 50255

		end
		ELSE
		BEGIN

			INSERT INTO #M (Error, strMessage)
			SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
			FROM #CAHPS_SurveyTypeQuestionMappings s 
			LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
			WHERE s.SurveyType_id = @surveyType_id
			and s.SubType_id = @questionnaireType_id
			AND t.QstnCore IS NULL

		END


	END

	IF (@surveyType_id = @HHCAHPS) OR (@SurveyType_id = @hospiceCAHPS) OR (@SurveyType_id = @CIHI) OR (@SurveyType_id = @oasCAHPS)
	BEGIN
		IF (@SurveyType_id = @oasCAHPS)
			IF EXISTS (select 1 from #CurrentForm  where QstnCore = 54117)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore in (54181,54182,54183)
			ELSE
				IF EXISTS (select 1 from #CurrentForm where QstnCore in (54181,54182,54183))
					delete from #CAHPS_SurveyTypeQuestionMappings  where QstnCore = 54117
		
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END

	IF (@SurveyType_id = @ACOCAHPS)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		and s.SubType_id = @questionnaireType_id
		AND t.QstnCore IS NULL

		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		and s.SubType_id = @questionnaireType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck 
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
		from #CAHPS_SurveyTypeQuestionMappings qm 
		INNER JOIN #CurrentForm t ON qm.SurveyType_id = @surveyType_id
		WHERE qm.SubType_id = @questionnaireType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END
	ELSE -- NOT (IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS))
	BEGIN

		IF @surveyType_id <> @CGCAHPS -- we don't check order for CGCAHPS
		begin
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
			INSERT INTO #OrderCheck
			SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
			from #CAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
			WHERE qm.SurveyType_id = @surveyType_id
			AND bitFirstOnForm=0
			AND qm.QstnCore=t.QstnCore
		END
	END


	DECLARE @OrderDifference INT

	SELECT @OrderDifference=OrderDiff
	FROM #OrderCheck
	WHERE OverAllOrder=1

	IF (@SurveyType_id = @oasCAHPS)
		IF NOT EXISTS (select 1 from #CurrentForm where QstnCore in (54181,54182,54183))
			delete from #OrderCheck where QstnCore in (54118,54119,54120,54121,54122)
		ELSE
			IF NOT EXISTS (select 1 from #CurrentForm where QstnCore = 54117)
				delete from #OrderCheck where QstnCore in (54181,54182,54183,54118,54119,54120,54121,54122)

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
		 SELECT 1,'QstnCore '+LTRIM(STR(a.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'
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
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%phone%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Phone'))
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%mail%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Mail'))
		  AND not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%dummy%') 
		 ) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

		  IF @@ROWCOUNT=0
		   INSERT INTO #M (Error, strMessage)
		   SELECT 0,'All Questions are mapped properly for Sampleunit ' + convert(varchar,@sampleunit_id)

		  DELETE
		  FROM #CAHPSUnits
		  WHERE sampleunit_Id=@sampleunit_id

		  SELECT TOP 1 @sampleunit_id=sampleunit_id
		  FROM #CAHPSUnits

	 END

	 DROP TABLE #CAHPSUnits
	 

	END
	--End of Question checking

	DROP TABLE #CAHPS_SurveyTypeQuestionMappings

ENDOFPROC:

SELECT * FROM #M

DROP TABLE #M

GO