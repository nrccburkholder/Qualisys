CREATE -- <--start with ALTER for updates to the SP
PROCEDURE [dbo].[SV_ACOCAHPS]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/***Modified 10/01/2010 dmp - commented out check for QAS Batch addrerr rule,
 added code for Melissa Data addrerr rule. ***/

--If this is not an ACOCAHPS Survey, end the procedure
IF (SELECT SurveyType_id FROM Survey_def WHERE Survey_id=@Survey_id)<>(select SurveyType_ID from SurveyType where SurveyType_dsc = 'ACOCAHPS')
BEGIN
    RETURN
END

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the 5 "A" fields are a part of the study                                 REQUIRED METAFIELDS PRESENT
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a in the data structure.'
FROM (SELECT Field_id, strField_nm
      FROM MetaField
      WHERE strField_nm IN ('ACO_FieldDate','ACO_FinderNum','ACO_ACOID',
                            'ACO_ACOName','ACO_FocalType')) a
      LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
                 WHERE sd.Survey_id=@Survey_id
                 AND sd.Study_id=m.Study_id
   AND m.strTable_nm = 'ENCOUNTER') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All ACOCAHPS fields are in the data structure'

--Make sure skip patterns are enforced.                                              SKIP PATTERNS ??? same as "Resurvey Exclusion is 0"?
INSERT INTO #M (Error, strMessage)
SELECT 1,'Skip Patterns are not enforced.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND bitEnforceSkip=0
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Skip Patterns are enforced'

--Check the ReSurvey Method                                                          RESURVEY METHOD
INSERT INTO #M (Error, strMessage)
SELECT 1,'Resurvey Method is not set to Resurvey Days.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND ReSurveyMethod_id<>(select ReSurveyMethod_id from ReSurveyMethod where ReSurveyMethodName = 'Resurvey Days')

--Check for HouseHolding
INSERT INTO #M (Error, strMessage)
SELECT 1,'Householding is defined and should not be.'
FROM HouseHoldRule hhr
WHERE hhr.Survey_id=@Survey_id

--Make sure we have at least one ACOCAHPS sampleunit                                 ONE ACO SAMPLE UNIT
IF (SELECT COUNT(*)
    FROM SampleUnit su, SamplePlan sp
    WHERE sp.Survey_id=@Survey_id
    AND sp.SamplePlan_id=su.SamplePlan_id
    AND bitACOCAHPS=1)<1
INSERT INTO #M (Error, strMessage)
SELECT 1,'Survey must have at least one ACOCAHPS Sampleunit.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0,'Survey has one ACOCAHPS Sampleunit.'

/*
--What is the sampling algorithm                                                     SAMPLING ALGORITHM ???
INSERT INTO #M (Error, strMessage)
SELECT 1,'Your sampling algorithm is not StaticPlus.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND SamplingAlgorithmID<>3
*/

--What is the sampling method                                                        SAMPLING METHOD
if exists(select 1 from PeriodDef where survey_id=@survey_id and SamplingMethod_id <> (select SamplingMethod_id from SamplingMethod where strSamplingMethod_nm = 'Census'))
INSERT INTO #M (Error, strMessage)
SELECT 1,'Your sampling method is not Census.'

--Make sure the reporting date is ACO_FieldDate                                      REPORTING DATE IS ACO_FIELDDATE
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

--Make sure all of the ACOCAHPS questions are on the form and in the correct location.      ALL ACO QUESTIONS
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





--Create subset SurveyTypeQuestionMappings looking at only surveyType

--Check for expanded ACOCAHPS questions
--If they exist on survey, then pull question list that includes expanded questions (bitExpanded = 1)
declare @bitExpanded int
select @bitExpanded = isnull((select top 1 1 from #currentform where qstncore in (46863,46864,46865,46866,46867)),0)



--If active sample period is after 1/1/2013, then the survey should be using expanded questions (bitExpanded = 1)

--insert into #periods exec QCL_SelectActivePeriodbySurveyId2 @survey_id
--exec QCL_SelectActivePeriodbySurveyId2 @survey_id

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

/*if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
select @bitExpanded = 1 ---(HCAHPS specific)*/

drop table #periods


/* 9/25/2013 DBG.
If NCQA adds or removes questions from the standard survey, there are now datEncounterStart_dt and datEncounterEnd_dt fields in SurveyTypeQuestionMappings.
Some (SurveyType_id=2) records currently have a date range of '1/1/1900' to '12/31/2012 23:59:59.997' and others have a date range of '1/1/2013' to '12/31/2999',
depending on the value of bitExanded.

If NCQA drops questions, you can change the datEncounterEnd_dt value to the day before the next fielding period. New questions would need new records with the
datEncounterStart_dt value of the first day of the new fielding period.

You'd then change the following query so instead of "and bitExpanded = @bitExpanded" it has "and @ExpectedEncStart between datEncounterStart_dt and datEncounterEnd_dt"
in the where clause. Figure out what @ExpectedEncStart is by looking at PeriodDef.datExpectedEncStart and set @ExpectedEncStart instead of setting @bitExpanded.
*/

Select surveytype_id, qstncore, intorder, bitfirstonform
into #ACOCAHPS_SurveyTypeQuestionMappings
from SurveyTypeQuestionMappings
where SurveyType_id = 10
and bitExpanded = @bitExpanded

--Look for questions missing from the form.

-- aa setup a mapping for questions and alternative questions
CREATE TABLE #AlternateQuestionMappings
(
 QstnCore int,
 AlQstnCore int
)
/*  Originally:
insert into #AlternateQuestionMappings values ( 50255, 50715 )
insert into #AlternateQuestionMappings values ( 50715, 50255 )
*/
insert into #AlternateQuestionMappings values ( 50255, 50725 )
insert into #AlternateQuestionMappings values ( 50255, 50726 )
insert into #AlternateQuestionMappings values ( 50255, 50727 )
insert into #AlternateQuestionMappings values ( 50255, 50728 )
insert into #AlternateQuestionMappings values ( 50255, 50729 )
insert into #AlternateQuestionMappings values ( 50255, 50730 )
insert into #AlternateQuestionMappings values ( 50255, 50731 )
insert into #AlternateQuestionMappings values ( 50255, 50732 )
insert into #AlternateQuestionMappings values ( 50255, 50733 )
insert into #AlternateQuestionMappings values ( 50255, 50734 )
insert into #AlternateQuestionMappings values ( 50255, 50735 )
insert into #AlternateQuestionMappings values ( 50255, 50736 )
insert into #AlternateQuestionMappings values ( 50255, 50737 )
insert into #AlternateQuestionMappings values ( 50255, 50738 )
insert into #AlternateQuestionMappings values ( 50255, 50739 )
insert into #AlternateQuestionMappings values ( 50255, 50740 )
insert into #AlternateQuestionMappings values ( 50725, 50255 )
insert into #AlternateQuestionMappings values ( 50726, 50255 )
insert into #AlternateQuestionMappings values ( 50727, 50255 )
insert into #AlternateQuestionMappings values ( 50728, 50255 )
insert into #AlternateQuestionMappings values ( 50729, 50255 )
insert into #AlternateQuestionMappings values ( 50730, 50255 )
insert into #AlternateQuestionMappings values ( 50731, 50255 )
insert into #AlternateQuestionMappings values ( 50732, 50255 )
insert into #AlternateQuestionMappings values ( 50733, 50255 )
insert into #AlternateQuestionMappings values ( 50734, 50255 )
insert into #AlternateQuestionMappings values ( 50735, 50255 )
insert into #AlternateQuestionMappings values ( 50736, 50255 )
insert into #AlternateQuestionMappings values ( 50737, 50255 )
insert into #AlternateQuestionMappings values ( 50738, 50255 )
insert into #AlternateQuestionMappings values ( 50739, 50255 )
insert into #AlternateQuestionMappings values ( 50740, 50255 )

-- aa setup a mapping for questions and alternative questions

DECLARE @cnt50715 INT
DECLARE @cnt50255 INT
SELECT
 @cnt50715 = SUM( CASE s.QstnCore WHEN 50715 THEN 1 ELSE 0 END),
 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END)
FROM #ACOCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
WHERE s.SurveyType_id=10
   AND t.QstnCore IS NOT NULL
/*
IF @cnt50715 = 0 AND @cnt50255 = 0
BEGIN
 INSERT INTO #M VALUES (1, 'QstnCore 50715 and 50255 are both missing.  You must have either 50715 or 50255, but not both.')
END
IF @cnt50715 > 0 AND @cnt50255 > 0
BEGIN
 INSERT INTO #M VALUES (1, 'QstnCore 50715 and 50255 are both assigned.  You must have either 50715 or 50255, but not both.')
END
*/
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
FROM #ACOCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
WHERE s.SurveyType_id=10
  AND t.QstnCore IS NULL and s.QstnCore NOT IN (50715,50255)

--Look for questions that are out of order.
--First the questions that have to be at the beginning of the form.
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
FROM #ACOCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
AND s.intOrder=t.Order_id
AND s.SurveyType_id=10
WHERE bitFirstOnForm=1
AND t.QstnCore IS NULL

--Now the questions that are at the end of the form.
SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
INTO #OrderCheck
from #ACOCAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
WHERE qm.SurveyType_id=10
AND bitFirstOnForm=0
AND qm.QstnCore=t.QstnCore

-- aa debug
-- select * from #OrderCheck
-- aa debug

DECLARE @OrderDifference INT

SELECT @OrderDifference=OrderDiff
FROM #OrderCheck
WHERE OverAllOrder=1

INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'
FROM #OrderCheck
WHERE OrderDiff<>@OrderDifference

DROP TABLE #OrderCheck


IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
BEGIN
 INSERT INTO #M (Error, strMessage)
 SELECT 0,'All ACOCAHPS Questions are on the form in the correct order.'

 --IF all 27 cores or on the survey, then check that the 27 questions are mapped
 --in a manner that ensures someone sampled at the HCAHP units will get all of them
 SELECT sampleunit_id
 into #ACOCAHPSUnits
 FROM SampleUnit su, SamplePlan sp
 WHERE sp.Survey_id=@Survey_id
 AND sp.SamplePlan_id=su.SamplePlan_id
 AND bitACOCAHPS=1

 DECLARE @sampleunit_id int

 SELECT TOP 1 @sampleunit_id=sampleunit_id
 FROM #ACOCAHPSUnits

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
  ) as Q  RIGHT JOIN #ACOCAHPS_SurveyTypeQuestionMappings stqm
  ON Q.QstnCore=stqm.QstnCore
  WHERE stqm.SurveyType_id=10 AND Q.QstnCore IS NULL
 ) AS a
 LEFT JOIN #AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

  IF @@ROWCOUNT=0
   INSERT INTO #M (Error, strMessage)
   SELECT 0,'All ACOCAHPS Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)

  DELETE
  FROM #ACOCAHPSUnits
  WHERE sampleunit_Id=@sampleunit_id

  SELECT TOP 1 @sampleunit_id=sampleunit_id
  FROM #ACOCAHPSUnits
 END
END
--End of Question checking

--Now to check the active methodology                                   ACTIVE METHODOLOGY IS CORRECT AND UNIQUE
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
 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid =5)
  INSERT INTO #M (Error, strMessage)
  SELECT 1,'Survey uses a custom methodology.'
 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology
 WHERE standardmethodologyid in (select StandardMethodologyID
        from StandardMethodologyBySurveyType
        where SurveyType_id = (select SurveyType_ID from SurveyType where SurveyType_dsc = 'ACOCAHPS')
        )
   )
  INSERT INTO #M (Error, strMessage)
  SELECT 0,'Survey uses a standard ACOCAHPS methodology.'
 ELSE
  INSERT INTO #M (Error, strMessage)
  SELECT 1,'Survey does not use a standard ACOCAHPS methodology.'
END

DROP TABLE #ActiveMethodology

--------------------
----Now check for Addr Error DQ rule
----Added 10/02/2010 dmp, foreign address rule for Melissa Data address cleaning
IF EXISTS (SELECT BusinessRule_id
           FROM BusinessRule br
             WHERE br.Survey_id = @Survey_id
   )
    INSERT INTO #M (Error, strMessage)
    SELECT 1,'Survey has a DQ or other Business Rule and should not.'
ELSE
    INSERT INTO #M (Error, strMessage)
    SELECT 0,'Survey does not have DQ rule.'

--------------------

--Get the result set
SELECT * FROM #M

--Cleanup
DROP TABLE #M
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


