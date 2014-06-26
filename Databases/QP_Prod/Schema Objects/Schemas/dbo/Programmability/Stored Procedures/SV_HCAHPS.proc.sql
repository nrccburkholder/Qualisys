CREATE PROCEDURE [dbo].[SV_HCAHPS]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/***Modified 10/01/2010 dmp - commented out check for QAS Batch addrerr rule,
 added code for Melissa Data addrerr rule. ***/

--If this is not an HCAHPS Survey, end the procedure
IF (SELECT SurveyType_id FROM Survey_def WHERE Survey_id=@Survey_id)<>2
BEGIN
    RETURN
END

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the 6 "H" fields are a part of the study
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a in the data structure.'
FROM (SELECT Field_id, strField_nm
      FROM MetaField
      WHERE strField_nm IN ('HServiceType','HVisitType','HAdmissionSource',
                            'HDischargeStatus','HAdmitAge','HCatAge')) a
      LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
                 WHERE sd.Survey_id=@Survey_id
                 AND sd.Study_id=m.Study_id
   AND m.strTable_nm = 'ENCOUNTER') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All HCHAPS fields are in the data structure'


--Make sure skip patterns are enforced.
INSERT INTO #M (Error, strMessage)
SELECT 1,'Skip Patterns are not enforced.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND bitEnforceSkip=0
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Skip Patterns are enforced'

--Check the ReSurvey Method
INSERT INTO #M (Error, strMessage)
SELECT 1,'Resurvey Method is not set to Calendar Month.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND ReSurveyMethod_id<>2


--Check for HouseHolding
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

--Make sure the Medicare number is populated.
INSERT INTO #M (Error, strMessage)
SELECT 1,'Medicare number is not populated.'
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
ON su.SUFacility_id=suf.SUFacility_id
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.bitHCAHPS=1
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
AND su.bitHCAHPS=1
AND ml.Active = 0
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Medicare number is Active'


--Make sure we have at least one HCAHPS sampleunit
IF (SELECT COUNT(*)
    FROM SampleUnit su, SamplePlan sp
    WHERE sp.Survey_id=@Survey_id
    AND sp.SamplePlan_id=su.SamplePlan_id
    AND bitHCAHPS=1)<1
INSERT INTO #M (Error, strMessage)
SELECT 1,'Survey must have at least one HCAHPS Sampleunit.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0,'Survey has one HCAHPS Sampleunit.'

--Check that FacilityState is populated for the HCAHPS units.
INSERT INTO #M (Error, strMessage)
SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a state designated.'
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
ON su.SUFacility_id=suf.SUFacility_id
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.bitHCAHPS=1
AND suf.State IS NULL

--Is AHA_id populated?
IF EXISTS (SELECT *
           FROM (SELECT SampleUnit_id, SUFacility_id
                 FROM SamplePlan sp, SampleUnit su
                 WHERE sp.Survey_id=@Survey_id
                   AND sp.SamplePlan_id=su.SamplePlan_id
                   AND bitHCAHPS=1) a
                LEFT JOIN SUFacility f
                       ON a.SUFacility_id=f.SUFacility_id
           WHERE f.AHA_id IS NULL)
INSERT INTO #M (Error, strMessage)
SELECT 2,'At least one HCAHPS Sampleunit does not have an AHA value.'

--What is the sampling algorithm
INSERT INTO #M (Error, strMessage)
SELECT 1,'Your sampling algorithm is not StaticPlus.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND SamplingAlgorithmID<>3

--Make sure the reporting date is either ServiceDate or DischargeDate
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

--Make sure all of the HCAHPS questions are on the form and in the correct location.
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

--Check for expanded hcahps questions
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

if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
select @bitExpanded = 1

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
into #HCAHPS_SurveyTypeQuestionMappings
from SurveyTypeQuestionMappings
where SurveyType_id = 2
and bitExpanded = @bitExpanded

--Look for questions missing from the form.

-- aa setup a mapping for questions and alternative questions
CREATE TABLE #AlternateQuestionMappings
(
 QstnCore int,
 AlQstnCore int
)
insert into #AlternateQuestionMappings values ( 50860, 43350 )
insert into #AlternateQuestionMappings values ( 43350, 50860 )
-- aa setup a mapping for questions and alternative questions

DECLARE @cnt43350 INT
DECLARE @cnt50860 INT
SELECT
 @cnt43350 = SUM( CASE s.QstnCore WHEN 43350 THEN 1 ELSE 0 END),
 @cnt50860 = SUM( CASE s.QstnCore WHEN 50860 THEN 1 ELSE 0 END)
FROM #HCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
WHERE s.SurveyType_id=2
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
FROM #HCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
WHERE s.SurveyType_id=2
  AND t.QstnCore IS NULL and s.QstnCore NOT IN (43350,50860)

--Look for questions that are out of order.
--First the questions that have to be at the beginning of the form.
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
FROM #HCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
AND s.intOrder=t.Order_id
AND s.SurveyType_id=2
WHERE bitFirstOnForm=1
AND t.QstnCore IS NULL

--Now the questions that are at the end of the form.
SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
INTO #OrderCheck
from #HCAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
WHERE qm.SurveyType_id=2
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
 SELECT 0,'All HCAHPS Questions are on the form in the correct order.'

 --IF all 27 cores or on the survey, then check that the 27 questions are mapped
 --in a manner that ensures someone sampled at the HCAHP units will get all of them
 SELECT sampleunit_id
 into #HCAHPSUnits
 FROM SampleUnit su, SamplePlan sp
 WHERE sp.Survey_id=@Survey_id
 AND sp.SamplePlan_id=su.SamplePlan_id
 AND bitHCAHPS=1

 DECLARE @sampleunit_id int

 SELECT TOP 1 @sampleunit_id=sampleunit_id
 FROM #HCAHPSUnits

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
  ) as Q  RIGHT JOIN #HCAHPS_SurveyTypeQuestionMappings stqm
  ON Q.QstnCore=stqm.QstnCore
  WHERE stqm.SurveyType_id=2 AND Q.QstnCore IS NULL
 ) AS a
 LEFT JOIN #AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

  IF @@ROWCOUNT=0
   INSERT INTO #M (Error, strMessage)
   SELECT 0,'All HCAHPS Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)

  DELETE
  FROM #HCAHPSUnits
  WHERE sampleunit_Id=@sampleunit_id

  SELECT TOP 1 @sampleunit_id=sampleunit_id
  FROM #HCAHPSUnits
 END
END
--End of Question checking

--Now to check the active methodology
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
        where SurveyType_id = 2
        )
   )
  INSERT INTO #M (Error, strMessage)
  SELECT 0,'Survey uses a standard HCAHPS methodology.'
 ELSE
  INSERT INTO #M (Error, strMessage)
  SELECT 1,'Survey does not use a standard HCAHPS methodology.'
END

DROP TABLE #ActiveMethodology

--------------------
----Now check for Addr Error DQ rule
----Added 10/02/2010 dmp, foreign address rule for Melissa Data address cleaning
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

--------------------

--Commented out as we are no longer using QAS Batch
----Now check for Addr Error DQ rule
--IF EXISTS (SELECT BusinessRule_id
--           FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
--           WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
--             AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
--             AND cc.Field_id = mf.Field_id
--             AND cc.intOperator = op.Operator_Num
--             AND mf.strField_Nm = 'AddrErr'
--             AND op.strOperator = '='
--             AND cc.strLowValue = 'C0'
--             AND br.Survey_id = @Survey_id
--   )
--    INSERT INTO #M (Error, strMessage)
--    SELECT 0,'Survey has DQ rule (AddrErr = "C0").'
--ELSE
--    INSERT INTO #M (Error, strMessage)
--    SELECT 1,'Survey does not have DQ rule (AddrErr = "C0").'


--Commented out as we are now using QAS address cleaning.
--error code is now C0
------Now check for Addr Error DQ rule
----IF EXISTS (SELECT BusinessRule_id
----           FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
----           WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
----             AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
----       AND cc.Field_id = mf.Field_id
----             AND cc.intOperator = op.Operator_Num
----             AND mf.strField_Nm = 'AddrErr'
----             AND op.strOperator = '='
----             AND cc.strLowValue = 'E501'
----             AND br.Survey_id = @Survey_id
----   )
----   OR
----   EXISTS (SELECT BusinessRule_id
----           FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
----           WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
----             AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
----             AND cc.CriteriaClause_id = ci.CriteriaClause_id
----             AND cc.Field_id = mf.Field_id
----             AND cc.intOperator = op.Operator_Num
----             AND mf.strField_Nm = 'AddrErr'
----             AND op.strOperator = 'IN'
----             AND ci.strListValue = 'E501'
----             AND br.Survey_id = @Survey_id
----   )
----    INSERT INTO #M (Error, strMessage)
----    SELECT 0,'Survey has DQ rule (AddrErr = "E501").'
----ELSE
----    INSERT INTO #M (Error, strMessage)
----    SELECT 1,'Survey does not have DQ rule (AddrErr = "E501").'
-----------------------------------------------

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

-- AA 2011-05-26 Added check to make sure the DQ_SNF rules are in place --
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
-- AA --


--Get the result set
SELECT * FROM #M

--Cleanup
DROP TABLE #M
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


