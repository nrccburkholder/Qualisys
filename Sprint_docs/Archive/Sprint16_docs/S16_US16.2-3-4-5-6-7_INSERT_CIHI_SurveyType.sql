/*

S16.US16	As an Implementation Associate, I want a new survey type w/ appropriate defaults forCIHIS, so I can set up the survey correctly.

16.2	Create new Suvey type and properties' defaults 
16.3	Create new Metafields
16.4	Create standard default DQ rules
16.5	Create sample period defaults
16.6	Create standard methodologies
16.7	Create survey validation rules
			CREATE PROCEDURE [dbo].[SV_CAHPS_EnglishOrFrench]
			CREATE PROCEDURE [dbo].[SV_CIHI_DQRules]
			ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
			ALTER PROCEDURE [dbo].[SV_CAHPS_SamplePeriods]
			ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]

*/


USE [QP_Prod]
GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'SV_CAHPS_EnglishOrFrench')
	DROP PROCEDURE dbo.SV_CAHPS_EnglishOrFrench
GO


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_EnglishOrFrench]    Script Date: 1/16/2015 11:53:36 AM ******/
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

GO

declare @svpid int
declare @intOrder int
declare @SurveyTypeID int



begin tran

IF not exists (SELECT 1 FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_EnglishOrFrench')
BEGIN	
	Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_EnglishOrFrench','Check that only English or French is used on survey',@intOrder)
END


commit tran

GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'SV_CIHI_DQRules')
	DROP PROCEDURE dbo.SV_CIHI_DQRules
GO


GO
/****** Object:  StoredProcedure [dbo].[SV_CIHI_DQRules]    Script Date: 1/19/2015 8:21:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SV_CIHI_DQRules]
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


--If this is not an CIHI Survey, end the procedure                    
IF (@surveyType_id <> (SELECT SurveyType_ID FROM SurveyType WHERE SurveyType_dsc ='CIHI CPES-IC'))                 
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


declare @study_ID int --, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))


		--check for DQ_L NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_L NM'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LName IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LName IS NULL).'


		--check for DQ_F NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_F NM'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (FName IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (FName IS NULL).'


		--check for DQ_Addr Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Addr'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Addr IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Addr IS NULL).'


		--check for DQ_City Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_City'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (City IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (City IS NULL).'

		 --check for DQ_Prov Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_PROV'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Province IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Province IS NULL).'

		  --check for DQ_PstCd Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_PstCd'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Postal_Code IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (PostalCode IS NULL).'

		--check for DQ_Age Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Age'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Age IS NULL OR Age < 0).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Age IS NULL OR Age < 0).'

		  --check for DQ_Sex Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Sex'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Sex IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Sex IS NULL).'

		  --check for DQ_LangI Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_LangI'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LangID IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LandID IS NULL).'

		  --check for DQ_MRN Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_MRN'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (MRN IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (MRN IS NULL).'

		--check for DQ_MDAE Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_MDAE'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr IN (''NC'',''TL'',''FO'',''NU'')).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (AddrErr IN (''NC'',''TL'',''FO'',''NU'')).'

SELECT * FROM #M

DROP TABLE #M

GO

declare @svpid int
declare @intOrder int
declare @SurveyTypeID int


begin tran

IF not exists (SELECT 1 FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CIHI_DQRules')
BEGIN	
	Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CIHI_DQRules','Check DQ Rule',@intOrder)
END

commit tran

GO



/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 1/19/2015 1:10:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
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

declare @hospiceCAHPS int
SET @hospiceCAHPS = 11

declare @PCMHSubType int
SET @PCMHSubType = 9

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

-- get any associated subtype_id that is has questionnaire category type
select  @questionnaireType_id = sst.subtype_id 
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

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id

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

	IF (@surveyType_id = @HHCAHPS) OR (@SurveyType_id = @hospiceCAHPS) OR (@SurveyType_id = @CIHI)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END

	--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS)
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
	ELSE
	BEGIN
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


/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplePeriods]    Script Date: 1/19/2015 1:23:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_SamplePeriods]
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

GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ReportingDate]    Script Date: 1/19/2015 1:14:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
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

declare @hospiceCAHPS int
select @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

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

	IF @surveyType_id in (@hospiceCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ServiceDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ServiceDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ServiceDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ServiceDate.'
	END

	IF @surveyType_id in (@CIHI)
	BEGIN
		--Make sure the reporting date is DischargeDate                                     
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be DischargeDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be DischargeDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'DischargeDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to DischargeDate.'
	END

SELECT * FROM #M

DROP TABLE #M

GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Householding]    Script Date: 1/19/2015 1:03:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_Householding]
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

declare @hospiceCAHPS int
select @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

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


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@HCAHPS) or (@surveyType_id in (@CGCAHPS) and @subtype_id = @PCMHSubType)
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

END

IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS, @hospiceCAHPS, @CIHI)
	BEGIN

		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is defined and should not be.'
		FROM HouseHoldRule hhr
		WHERE hhr.Survey_id=@Survey_id
END

SELECT * FROM #M

DROP TABLE #M

GO


use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @Country_id int


SET @SurveyType_desc = 'CIHI CPES-IC'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL
SET @Country_id = 2

begin tran


/*
	Survey Type
*/

if not exists (	SELECT 1 FROM SurveyType WHERE SurveyType_dsc = @SurveyType_desc)
BEGIN

	INSERT INTO [dbo].[SurveyType]
			   ([SurveyType_dsc]
			   ,[CAHPSType_id]
			   ,[SeedMailings]
			   ,[SeedSurveyPercent]
			   ,[SeedUnitField])
		 VALUES
			   (@SurveyType_desc
			   ,NULL
			   ,@SeededMailings
			   ,@SeedSurveyPercent
			   ,@SeedUnitField)

	SELECT @SurveyType_ID = SCOPE_IDENTITY()


		UPDATE SurveyType
		SET CAHPSType_id = @SurveyType_ID
		WHERE SurveyType_ID = @SurveyType_ID

END


/*
	Survey Properties
*/

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SkipEnforcementRequired - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Skip Enforcement is required and controls are not enabled in Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyMethodDefault - CIHI CPES-IC','S','SurveyRules','CalendarMonths',2,NULL,'CIHI Resurvey method default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - CIHI CPES-IC','N','SurveyRules',NULL,12,NULL,'CIHI Resurvey Exclusion Days default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - CIHI CPES-IC','S','SurveyRules',1,NULL,NULL,'CIHI Resurvey Exclusion Days disabled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsCAHPS - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Rule to determine if this is a CAHPS survey type for Config Man')


insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: MedicareIdTextMayBeBlank - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Medicare Id Text May Be Blank for CIHI')

/*
	Methodologies
*/

declare @StandardMethodologyID int
declare @StandardMailingStepID int

insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('CPES-IC Mail Only, 2 Wave', 0, 'Mail Only')

set @StandardMethodologyID=scope_identity()

insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@StandardMethodologyID, @SurveyType_ID, 0)

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

set @StandardMailingStepID = scope_identity()

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 2, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

update StandardMailingStep set ExpireFromStep=@StandardMailingStepID where ExpireFromStep=-1



insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('CPES-IC Mail Only, 3 Wave w/ Letter', 0, 'Mail Only')

set @StandardMethodologyID=scope_identity()

insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@StandardMethodologyID, @SurveyType_ID, 0)

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

set @StandardMailingStepID = scope_identity()

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 2, 0, 1, 7, 0, 'Reminder', 0, 0, 84, @StandardMailingStepID, null, null, null, null, null, null, null, null, null, null, null, null, null, null)


insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 3, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

update StandardMailingStep set ExpireFromStep=@StandardMailingStepID where ExpireFromStep=-1

/*
	META fields
*/

declare @FIELDGROUP_ID int
declare @STRFIELD_NM varchar(20)
declare @STRFIELD_DSC varchar(80)
declare @STRFIELDDATATYPE char(1)
declare @INTFIELDLENGTH int
declare @STRFIELDEDITMASK varchar(20)
declare @INTSPECIALFIELD_CD int
declare @STRFIELDSHORT_NM char(8)
declare @BITSYSKEY bit
declare @bitPhase1Field bit
declare @intAddrCleanCode int
declare @intAddrCleanGroup int
declare @bitPII bit

insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('CIHI', NULL, 0)

SELECT @FIELDGROUP_ID = SCOPE_IDENTITY()


SET @STRFIELD_NM = 'CIHI_AdmitSrc'
SET @STRFIELD_DSC = 'Admit Source (DIR or ED) for CPES-IC'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 20
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'CIHIASrc'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


SET @STRFIELD_NM = 'CIHI_ServiceLine'
SET @STRFIELD_DSC = 'Service Line (MED, SURG, OBS) for CPES-IC'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 20
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'CIHIServ'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


SET @STRFIELD_NM = 'CIHI_AdmitAge'
SET @STRFIELD_DSC = 'Age of patient on admission date'
SET @STRFIELDDATATYPE = 'I'
SET @INTFIELDLENGTH = NULL
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'ADmAge'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 1

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


SET @STRFIELD_NM = 'CIHI_AgeCat'
SET @STRFIELD_DSC = 'Patient age category for CPES-IC'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 10
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'CIHIAgeC'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)

SET @STRFIELD_NM = 'CIHI_PIDType'
SET @STRFIELD_DSC = 'Type of Patient identifier (MRN or Other) for CIHI'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 3
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = NULL
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, NULL, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)

SET @STRFIELD_NM = 'HCN'
SET @STRFIELD_DSC = 'Canadian Healthcare Number'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 12
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = NULL
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, NULL, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)

SET @STRFIELD_NM = 'HCN_Issuer'
SET @STRFIELD_DSC = 'Canadian Jurisdiction issuing Healthcare Number'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 3
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = NULL
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, NULL, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


/*
	DQ Rules
*/

declare @DCStmtId int
declare @FieldId int
declare @strCriteriaStmt_nm varchar(8)
declare @strCriteriaString varchar(7000)
declare @busRule_cd char(1)
--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause

SET @strCriteriaStmt_nm = 'DQ_L Nm'
SET @strCriteriaString = '(POPULATIONLName IS NULL)'
SET @busRule_cd = 'Q'
IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_F Nm'
SET @strCriteriaString = '(POPULATIONFName IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId )


SET @strCriteriaStmt_nm = 'DQ_Addr'
SET @strCriteriaString = '(POPULATIONADDR IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_City'
SET @strCriteriaString = '(POPULATIONCITY IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_PROV'
SET @strCriteriaString = '(POPULATIONProvince IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_PstCd'
SET @strCriteriaString = '(POPULATIONPostal_Code IS NULL)'
SET @busRule_cd = 'Q'
IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_Age'
SET @strCriteriaString = '(POPULATIONAge IS NULL) OR (POPULATIONAGE < 0)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_SEX'
SET @strCriteriaString = '(POPULATIONSEX IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_LangI'
SET @strCriteriaString = '(POPULATIONLangID IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_MRN'
SET @strCriteriaString = '(POPULATIONMRN IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_MDAE'
SET @strCriteriaString = '(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


/*
	Survey Validation
*/

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SampleUnit'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_Householding'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SamplingEncounterDate'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_ReportingDate'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_FormQuestions'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SamplePeriods'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_EnglishOrFrench'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CIHI_DQRules'
and svpbst.SurveyValidationProcsToSurveyType_id is null

go


commit tran

go

USE QP_PROD
GO

declare @SurveyTypeID int

SELECT @SurveyTypeID = st.[SurveyType_ID]
from SurveyType st
WHERE st.SurveyType_dsc = 'CIHI CPES-IC'


begin tran

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51377,1,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51378,2,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51379,3,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51380,4,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51381,5,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51382,6,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51383,7,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51384,8,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51385,9,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51386,10,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51387,11,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51388,12,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51389,13,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51390,14,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51391,15,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51392,16,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51393,17,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51394,18,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51395,19,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51396,20,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51397,21,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51398,22,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51399,23,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51400,24,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51401,25,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51402,26,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51403,27,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51404,28,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51405,29,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51406,30,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51407,31,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51408,32,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51409,33,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51410,34,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51411,35,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51412,36,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51413,37,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51414,38,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51415,39,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51416,40,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51417,41,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51418,42,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51419,43,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51420,44,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51424,45,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)



commit tran

