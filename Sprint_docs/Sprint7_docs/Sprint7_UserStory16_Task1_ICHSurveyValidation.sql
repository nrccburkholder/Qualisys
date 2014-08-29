USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 8/26/2014 10:23:23 AM ******/
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
	[SubType_id] [INT] NULL)

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

	--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF @surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType
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
			OR exists (select 1 from MAILINGSTEP where survey_id = @survey_id and STRMAILINGSTEP_NM like '%Phone%'))
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%mail%') 
			OR exists (select 1 from MAILINGSTEP where survey_id = @survey_id and STRMAILINGSTEP_NM like '%1st Survey%'))
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

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_Sections]    Script Date: 8/26/2014 3:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_Sections]
@Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced @Survey_id into SampleUnitSection where clause, and changed errors to warnings (1 to 2),
				and introduced into SampleUnitSection where clause criteria to prevent warning about phone section if
				no phone maling step is present, and about mail sections if no 1st survey mailing step is present;
				ignoring dummy question sections also
*/

SELECT 2 bitError, 'Section ' + convert(varchar,Section_ID)+' (' + Replace(Label,' ','') + ') NOT mapped to a Sample Unit' strMessage
FROM Sel_Qstns SQ
Where SQ.Survey_id=@Survey_id
AND  SQ.Subtype=3
AND  SQ.LABEL not like '%dummy%'
AND  NOT EXISTS
(SELECT * FROM SampleUnitSection SUS
WHERE SUS.SelQstnsSection = SQ.Section_ID
AND SUS.SELQSTNSSURVEY_ID=@Survey_id)
AND (SQ.LABEL not like '%phone%' OR exists (select 1 from MAILINGSTEP where survey_id = @survey_id and STRMAILINGSTEP_NM like '%Phone%'))
AND (SQ.LABEL not like '%mail%' OR exists (select 1 from MAILINGSTEP where survey_id = @survey_id and STRMAILINGSTEP_NM like '%1st Survey%'))
GROUP BY Section_ID, Label
IF @@ROWCOUNT=0
SELECT 0 bitError, 'Sections validation' strMessage

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_SurveyProperties]    Script Date: 8/29/2014 10:07:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************************************
Proc: SV_SurveyProperties
Created: ???
Purpose: called during survey validation.  This proc checks for generic rules that apply to all surveys 
		 contained within Qualisys

Modified:
	MWB 12/21/2009
		Added Householding field checks if householding is turned on.  
	MWB 03/11/2010
		Modified qstncore count to look at both Qualisys and Datamart for total questions.
		Does not account for questions that may have been removed from the datamart questions table.
	CJB 08/29/2014
		Added check for those survey types requiring USPS Address Change service 
  
***********************************************************************************************************/  
ALTER PROCEDURE [dbo].[SV_SurveyProperties]    
@Survey_id INT    
AS    

declare @Study_ID int, @qstncoreCnt int
    
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))    
Create table #tot_Qstncores (qstncore int, Type Varchar(1))  

IF NOT EXISTS(SELECT * FROM survey_def WHERE Survey_id=@Survey_id AND cutofftable_id=SampleEncounterTable_id and cutofffield_id=SampleEncounterField_id)    
INSERT INTO #M (Error, strMessage)    
SELECT 2 Error,'Sample Encounter Date Field and Report Date Field are different.'    
ELSE    
INSERT INTO #M (Error, strMessage)    
SELECT 0 Error,'Sample Encounter Date Field and Report Date Field are the same.'    

--===================================================================================
--CHECK TOTAL NUMBER OF QUESTIONS TO MAKE SURE THEY ARE NOT OVER THE 1024 LIMIT

Select @Study_ID = Study_Id from SURVEY_DEF where SURVEY_ID = @Survey_id

  
insert into #tot_Qstncores    
select distinct sq.qstncore, 'Q'  
from sel_qstns sq  
where sq.SURVEY_ID in (SELECT SURVEY_ID from SURVEY_DEF where STUDY_ID = @study_Id)    
  
insert into #tot_Qstncores    
select distinct q.qstncore, 'D'  
from datamart.qp_comments.dbo.questions q    
where q.SURVEY_ID in (SELECT SURVEY_ID from datamart.qp_comments.dbo.clientstudysurvey where STUDY_ID = @study_Id)    


Select @qstncoreCnt = COUNT(DISTINCT qstncore) from #tot_Qstncores

if (@qstncoreCnt) > 1000  
 BEGIN  
  INSERT INTO #M (Error, strMessage)    
  SELECT 1 Error,'Qstncore count is greater than 1000.  Please do not exceed 1000'    
 END  
ELSE    
 BEGIN  
  if (@qstncoreCnt) > 700  
  INSERT INTO #M (Error, strMessage)    
  SELECT 2 Error,'Qstncore count is greater than 700.  Please do not exceed 1000'    
  ELSE    
  INSERT INTO #M (Error, strMessage)    
  SELECT 0 Error,'You currently have ' + cast(@qstncoreCnt as varchar(15)) + ' questions fielded for study_ID ' + cast(@study_Id as varchar(15))  
 END  

--END: CHECK TOTAL NUMBER OF QUESTIONS TO MAKE SURE THEY ARE NOT OVER THE 1024 LIMIT 
--===================================================================================
  

--Check for HouseHolding            
if exists 
	(
	SELECT	'x'
	FROM	Survey_def sd         
	WHERE	sd.Survey_id=@Survey_id and 
			strHouseholdingType <> 'N'                       
	)     
BEGIN       
	--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns                
	INSERT INTO #M (Error, strMessage)                
	SELECT 1,'When Householding is turned on ' + strField_nm+ ' must be an included householding column.'                
	FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a                
	  LEFT JOIN HouseHoldRule hhr                
	ON a.Field_id=hhr.Field_id                
	AND hhr.Survey_id=@Survey_id                
	WHERE hhr.Field_id IS NULL           
END

if dbo.SurveyProperty('UseUSPSAddrChangeServiceDefault', null, @Survey_id) = 1
BEGIN
	if exists(select 1 from survey_def where UseUSPSAddrChangeService = 0 and survey_id = @Survey_id)
	insert into #M (Error, strMessage)
		select 1,'This survey must have USPS Address Change Service turned on'
	else
	insert into #M (Error, strMessage)
		select 0,'This survey does have USPS Address Change Service turned on as it should'

	declare @FirstStepCover varchar(42)

	select @firstStepCover=rtrim(description)
	from (                  select distinct st.CoverID, st.Language, sc.description
							from sel_cover sc
							inner join sel_textbox st on sc.survey_id=st.survey_id and sc.selcover_id=st.coverid
							inner join mailingmethodology mm on st.survey_id=mm.survey_id
							inner join mailingstep ms on mm.methodology_id=ms.methodology_id and st.coverid=ms.selcover_id
							where st.survey_id=@survey_id
							and ms.intSequence=1) coverlang
	left outer join (select distinct st.CoverID, st.Language
							from sel_textbox st 
							inner join mailingmethodology mm on st.survey_id=mm.survey_id
							inner join mailingstep ms on mm.methodology_id=ms.methodology_id and st.coverid=ms.selcover_id
							where st.survey_id=@survey_id
							and ms.intSequence=1
							and st.richtext like '%ELECTRONIC SERVICE REQUESTED%') esr
		  on coverlang.coverid=esr.coverid and coverlang.language=esr.language
	where esr.coverid is null

	if @@rowcount>0
	  	insert into #M (Error, strMessage)
		select 1,'The phrase "ELECTRONIC SERVICE REQUESTED" isn''t on the "'+@firstStepCover+'" cover letter'
	else
	  	insert into #M (Error, strMessage)
		select 0,'The phrase "ELECTRONIC SERVICE REQUESTED" was found on the first letter'

END
    
SELECT * FROM #M    
    
DROP TABLE #M

GO