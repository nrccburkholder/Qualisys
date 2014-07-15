use qp_prod
go
select *
into bak_CriteriaStmt_AllCAHPS_Release001
from CRITERIAstmt 

select *
into bak_CRITERIACLAUSE_AllCAHPS_Release001
from CRITERIACLAUSE 

select *
into bak_CRITERIAINLIST_AllCAHPS_Release001
from CRITERIAINLIST 

go
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 6.1. Identify all surveys that use these 3 DQ rules
select STRCRITERIASTMT_NM, convert(varchar(max),strCriteriaString), count(*) as numCriteria, count(distinct study_id) as numStudies
from CRITERIAstmt cs
inner join CRITERIACLAUSE cc on cs.criteriastmt_id=cc.criteriastmt_id
inner join metafield mf on cc.field_id=mf.field_id
left join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
where cs.STRCRITERIASTMT_NM in ('DQ_Dead','DQ_Law','DQ_SNF')
and mf.strField_nm = 'HDischargeStatus'
group by STRCRITERIASTMT_NM, convert(varchar(max),strCriteriaString)
order by 1, 3 desc
go

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 6.?. update survey validation with new codes.
go
alter PROCEDURE [dbo].[SV_HCAHPS]
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
go
alter PROCEDURE [dbo].[SV_HHCAHPS]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*** Change Log
 **Modified triggering data in where clause for checking if the LookBack rule is in effect
 **Modified 10/01/2010 dmp - commented out check for QAS Batch addrerr rule,
 added code for Melissa Data addrerr rule.
 **Removed Householding check 5/9/2011 dmp
 Will use householding to prevent sampling people with multiple MRNs
***/

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--If this is not an HHCAHPS Survey, end the procedure
IF (SELECT SurveyType_id FROM Survey_def WHERE Survey_id=@Survey_id)<>3
BEGIN
    RETURN
END

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))


--Make sure the 6 "HH" fields are a part of the study (Population Fields)
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a in the data structure.'
FROM (SELECT Field_id, strField_nm
      FROM MetaField
      WHERE strField_nm IN ('HHHelpedHandE','HHLangHandE')) a
      LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
                 WHERE sd.Survey_id=@Survey_id
                 AND sd.Study_id=m.Study_id
   AND m.strTable_nm = 'POPULATION') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All Population HHCHAPS fields are in the data structure'

--Make sure the 6 "HH" fields are a part of the study (Encounter Fields)
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a in the data structure.'
FROM (SELECT Field_id, strField_nm
      FROM MetaField
      WHERE strField_nm IN ('HHADL_Bath','HHADL_Deficit','HHADL_DressLow','HHADL_DressUp','HHADL_Feed',
   'HHADL_Toilet','HHADL_Transfer','HHAdm_Comm','HHAdm_Hosp','HHAdm_OthIP','HHAdm_OthLTC',
   'HHAdm_Rehab','HHAdm_SNF','HHAgencyNm','HHCatAge','HHDischargeStatus','HHDual','HHEOMAge',
   'HHESRD','HHHMO','HHLookbackCnt','HHPatServed','HHPay_Ins','HHPay_Mcaid','HHPay_Mcare',
   'HHPay_Other','HHSampleMonth','HHSampleYear','HHSurg','HHVisitCnt')) a
      LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
                 WHERE sd.Survey_id=@Survey_id
                 AND sd.Study_id=m.Study_id
   AND m.strTable_nm = 'ENCOUNTER') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All Encounter HHCHAPS fields are in the data structure'

--Check for HouseHolding
--Removed Householding check 5/9/2011 dmp
--Will use householding to prevent sampling people with multiple MRNs
--INSERT INTO #M (Error, strMessage)
--SELECT top 1 1,'HHCAHPS does not support Householding.  Please select "None"'
--FROM Survey_def sd inner join HouseHoldRule hhr
--ON sd.Survey_id=hhr.Survey_id
--WHERE sd.Survey_id=@Survey_id


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

INSERT INTO #M (Error, strMessage)
SELECT 1,'Medicare number is not Active'
FROM SamplePlan sp, SampleUnit su,SUFacility suf, MedicareLookup ml
WHERE sp.Survey_id=@Survey_id
AND su.SUFacility_id=suf.SUFacility_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND ml.MedicareNumber = suf.MedicareNumber
AND su.bitHHCAHPS=1
AND ml.Active = 0
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Medicare number is Active'

--make sure the medicare number is active
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


--Make sure we have at least one HHCAHPS sampleunit
IF (SELECT COUNT(*)
    FROM SampleUnit su, SamplePlan sp
    WHERE sp.Survey_id=@Survey_id
    AND sp.SamplePlan_id=su.SamplePlan_id
    AND bitHHCAHPS=1)<1
INSERT INTO #M (Error, strMessage)
SELECT 1,'Survey must have at least one HHCAHPS Sampleunit.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0,'Survey has one HHCAHPS Sampleunit.'


--Check that FacilityState is populated for the HHCAHPS units.
INSERT INTO #M (Error, strMessage)
SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a state designated.'
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
ON su.SUFacility_id=suf.SUFacility_id
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.bitHHCAHPS=1
AND suf.State IS NULL


--Check that all HHCAHPS sampleunits have targets assigned.
INSERT INTO #M (Error, strMessage)
SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a target return specified.'
FROM SamplePlan sp, SampleUnit su
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.bitHHCAHPS=1 and INTTARGETRETURN = 0



--still deciding if this rule should be removed for both HCHAPS and HHCAHPS
------------Is AHA_id populated?
----------IF EXISTS (SELECT *
----------           FROM (SELECT SampleUnit_id, SUFacility_id
----------             FROM SamplePlan sp, SampleUnit su
----------                 WHERE sp.Survey_id=@Survey_id
----------                   AND sp.SamplePlan_id=su.SamplePlan_id
----------                   AND bitHCAHPS=1) a
----------                LEFT JOIN SUFacility f
----------                       ON a.SUFacility_id=f.SUFacility_id
----------           WHERE f.AHA_id IS NULL)
----------INSERT INTO #M (Error, strMessage)
----------SELECT 2,'At least one HCAHPS Sampleunit does not have an AHA value.'

--What is the sampling algorithm
INSERT INTO #M (Error, strMessage)
SELECT 1,'Your sampling algorithm is not StaticPlus.'
FROM Survey_def
WHERE Survey_id=@Survey_id
AND SamplingAlgorithmID<>3

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

/* 9/25/2013 DBG.
If NCQA adds or removes questions from the standard survey, there are now datEncounterStart_dt and datEncounterEnd_dt fields in SurveyTypeQuestionMappings.
All (SurveyType_id=3) records currently have a date range of '1/1/1900' to '12/31/2999'.  If NCQA drops questions, you can change the datEncounterEnd_dt value to
the day before the next fielding period. New questions would need new records with the datEncounterStart_dt value of the first day of the new fielding period.

You'd then change the following query so it has "and @ExpectedEncStart between datEncounterStart_dt and datEncounterEnd_dt" in the where clause.
Figure out what @ExpectedEncStart is by looking at PeriodDef.datExpectedEncStart. See how the [SV_HCAHPS] procedure builds the #Period table
for an example of this.

*/
--Create subset SurveyTypeQuestionMappings looking at only surveyType
Select surveytype_id, qstncore, intorder, bitfirstonform
into #HHCAHPS_SurveyTypeQuestionMappings
from SurveyTypeQuestionMappings
where SurveyType_id = 3

--Look for questions missing from the form.
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
FROM #HHCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
WHERE s.SurveyType_id=3
  AND t.QstnCore IS NULL



--Look for questions that are out of order.
--First the questions that have to be at the beginning of the form.
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
FROM #HHCAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
AND s.intOrder=t.Order_id
AND s.SurveyType_id=3
WHERE bitFirstOnForm=1
AND t.QstnCore IS NULL

--Now the questions that are at the end of the form.
SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
INTO #OrderCheck
from #HHCAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
WHERE qm.SurveyType_id=3
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


IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
BEGIN
 INSERT INTO #M (Error, strMessage)
 SELECT 0,'All HHCAHPS Questions are on the form in the correct order.'

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
  SELECT 1,'QstnCore '+LTRIM(STR(stqm.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'
  FROM ( SELECT sq.Qstncore
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
      AND sq.survey_id=su.selqstnssurvey_id) Q
   RIGHT JOIN #HHCAHPS_SurveyTypeQuestionMappings stqm
   ON Q.QstnCore=stqm.QstnCore
  WHERE stqm.SurveyType_id=3
     AND Q.QstnCore IS NULL

  IF @@ROWCOUNT=0
   INSERT INTO #M (Error, strMessage)
   SELECT 0,'All HHCAHPS Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)

  DELETE
  FROM #HCAHPSUnits
  WHERE sampleunit_Id=@sampleunit_id

  SELECT TOP 1 @sampleunit_id=sampleunit_id
  FROM #HCAHPSUnits
 END
END

--check to make sure only english or hcahps spanish is used on survey
INSERT INTO #M (Error, strMessage)
SELECT 1, l.Language + ' is not a valid Language for a HHCAHPS survey'
FROM Languages l, SEL_QSTNS sq
WHERE l.LangID = sq.LANGUAGE and
  sq.SURVEY_ID = @Survey_id and
  l.LangID not in (1,19)

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
 IF EXISTS(SELECT * FROM #ActiveMethodology
 WHERE standardmethodologyid in (select StandardMethodologyID
        from StandardMethodologyBySurveyType
  where SurveyType_id = 3
        )
   )
  INSERT INTO #M (Error, strMessage)
  SELECT 0,'Survey uses a standard HHCAHPS methodology.'
 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid =5)
  INSERT INTO #M (Error, strMessage)
  SELECT 2,'Survey uses a custom methodology.'
 ELSE
  INSERT INTO #M (Error, strMessage)
  SELECT 1,'Survey does not use a standard HHCAHPS methodology.'
END

DROP TABLE #ActiveMethodology


--Now check for Addr Error DQ rule - foreign address for Melissa Data address cleaning
--Changed for June 2011 sampling. No longer DQ foreign addresses. Now fail validation if rule exists
--dmp 07/08/2011
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

--Commented out 10/01/2010, dmp, no longer using QAS Batch address cleaning
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



--get Encounter MetaTable_ID this is so we can check for field existance before we check for
--DQ rules.  If the field is not in the data structure we do not want to check for the error.
SELECT @EncTable_ID = mt.Table_id
FROM dbo.MetaTable mt
WHERE mt.strTable_nm = 'ENCOUNTER'
  AND mt.Study_id = @Study_id

--check for DQ_Payer Rule
/** 11/24/2010 dmp
Need to vary criteria to accomodate client with missing payer info
(CMS indicates records with no payer info must be eligible for sample now).
Changing to validate rule with correct name exists, but no longer validating criteria. **/


--IF EXISTS (SELECT BusinessRule_id
--           FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
--           WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
--             AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
--             AND cc.Field_id = mf.Field_id
--             AND cc.intOperator = op.Operator_Num
--             AND mf.strField_Nm = 'HHPay_Mcare'
--             AND op.strOperator = '<>'
--             AND cc.strLowValue = '1'
--             AND br.Survey_id = @Survey_id
--   )
--and exists (SELECT BusinessRule_id
--           FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
--           WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
--             AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
--             AND cc.Field_id = mf.Field_id
--             AND cc.intOperator = op.Operator_Num
--             AND mf.strField_Nm = 'HHPay_Mcaid'
--             AND op.strOperator = '<>'
--             AND cc.strLowValue = '1'
--             AND br.Survey_id = @Survey_id
--   )

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


IF EXISTS (SELECT Field_id
           FROM dbo.MetaData_View
           WHERE Table_id = @EncTable_ID
       AND Study_id = @Study_id
       AND strField_nm = 'HHHospice')
BEGIN
 --Check for DQ_Hospc rules
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

IF EXISTS (SELECT Field_id
           FROM dbo.MetaData_View
           WHERE Table_id = @EncTable_ID
       AND Study_id = @Study_id
       AND strField_nm = 'HHMaternity')
BEGIN
--Check for DQ_Mat rules
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
       AND strField_nm = 'HHDeceased')
BEGIN
 --Check for DQ_Dead rules
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


INSERT INTO #M (Error, strMessage)
select  1, p1.strPeriodDef_nm + ' has more then one Sample in one period.'
from PeriodDef p1
where p1.Survey_id = @Survey_id and
  p1.intExpectedSamples <> 1

--Get the result set
SELECT * FROM #M

--Cleanup
DROP TABLE #M
DROP TABLE #HHCAHPS_SurveyTypeQuestionMappings
go
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 6.2. Add values to criteria IN list

-- DQ_Dead
begin tran

-- get list of all CRITERIASTMT_ID that use HDischargeStatus in DQ_Dead rule
-- drop table #CSdead
select distinct cs.CRITERIASTMT_ID, cc.criteriaclause_id, convert(varchar(3000),strCriteriaString) as strCriteriaString, convert(varchar(30),null) as CritType
into #CSdead
from CRITERIAstmt cs
inner join CRITERIACLAUSE cc on cs.criteriastmt_id=cc.criteriastmt_id
inner join metafield mf on cc.field_id=mf.field_id
where cs.STRCRITERIASTMT_NM in ('DQ_Dead')
and mf.strfield_nm in ('HDischargeStatus')

insert into #CSdead
select cs.criteriastmt_id, cc.criteriaclause_id, convert(varchar(3000),cs.strCriteriaString) as strCriteriaString, convert(varchar(30),null) as CritType
from #CSdead csd
inner join CriteriaStmt cs on csd.criteriastmt_id=cs.criteriastmt_id 
inner join CriteriaClause cc on csd.criteriastmt_id=cc.criteriastmt_id and csd.criteriaclause_id<>cc.criteriaclause_id
inner join metafield mf on cc.field_id=mf.field_id
where mf.strfield_nm in ('DischargeStatus')

-- all of those that use an "IN" operator (intOperator = 7) and contain '20' and '41'
update #CSdead
set CritType='HDisch in (20,41)'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSdead cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=2 and min(strListValue) = '20' and max(strListValue)= '41'
)

-- all of those that use an "IN" operator (intOperator = 7) and contain '20' and '41'
update #CSdead
set CritType='Disch in (20,41)'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSdead cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'DischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=2 and min(strListValue) = '20' and max(strListValue)= '41'
)

-- all of those that use an "IN" operator (intOperator = 7) and contain '20' and '42'
update #CSdead
set CritType='Disch in (20,42)'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSdead cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'DischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=2 and min(strListValue) = '20' and max(strListValue)= '42'
)

-- all of those that use an "IN" operator (intOperator = 7) and contain '40' and '42'
update #CSdead
set CritType='Disch in (40,42)'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSdead cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'DischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=2 and min(strListValue) = '40' and max(strListValue)= '42'
)

-- all of those that use an "=" operator (intOperator = 1) and a value of 20
update #CSdead
set CritType='HDisch = 20'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSdead cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	where intOperator = 1
	and strLowValue = '20'
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
)

-- all of those that use an "IN" operator (intOperator = 7) and contain '20', '40', '41' and '42' - which is already ok. so nothing to do
delete #CSdead
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSdead cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=4 and min(strListValue) = '20' and max(strListValue)= '42' and round(stdev(convert(int,strlistvalue)),6)=10.531698)
	-- the STDEV of (20, 40, 41, 42) is 10.531698. Another combination of 4 integers would come up with a different STDEV

if exists (select * from #CSdead where crittype is null)
begin
	rollback tran
	print 'somethings going on with DQ_Dead ... '
	select Error from #CSdead
end

-- add new values to the HDischargeStatus criteria clauses that are already "IN" statements
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '40' from #CSdead where CritType='HDisch in (20,41)' union
select criteriaclause_id, '42' from #CSdead where CritType='HDisch in (20,41)'

-- change the criteria clause from "=" to "IN" 
update cc set intOperator=7, strLowValue=NULL
from #CSdead cs
inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
where CritType = 'HDisch = 20'

-- and add all values for criteria claues that are "=" statements
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '20' from #CSdead where CritType = 'HDisch = 20' union
select criteriaclause_id, '40' from #CSdead where CritType = 'HDisch = 20' union
select criteriaclause_id, '41' from #CSdead where CritType = 'HDisch = 20' union
select criteriaclause_id, '42' from #CSdead where CritType = 'HDisch = 20'


insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '40' from #CSdead where CritType='Disch in (20,41)' union
select criteriaclause_id, '42' from #CSdead where CritType='Disch in (20,41)'

insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '40' from #CSdead where CritType='Disch in (20,42)' union
select criteriaclause_id, '41' from #CSdead where CritType='Disch in (20,42)'

insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '20' from #CSdead where CritType='Disch in (40,42)' union
select criteriaclause_id, '41' from #CSdead where CritType='Disch in (40,42)'


commit tran

-- DQ_Law
begin tran

-- get list of all CRITERIASTMT_ID that use HDischargeStatus in DQ_Law rule
-- drop table #CSlaw
select distinct cs.CRITERIASTMT_ID, cc.criteriaclause_id, convert(varchar(3000),strCriteriaString) as strCriteriaString, convert(varchar(30),null) as CritType
into #CSLaw
from CRITERIAstmt cs
inner join CRITERIACLAUSE cc on cs.criteriastmt_id=cc.criteriastmt_id
inner join metafield mf on cc.field_id=mf.field_id
where cs.STRCRITERIASTMT_NM in ('DQ_Law')
and mf.strfield_nm in ('HDischargeStatus')

insert into #CSlaw
select cs.criteriastmt_id, cc.criteriaclause_id, convert(varchar(3000),cs.strCriteriaString) as strCriteriaString, convert(varchar(30),null) as CritType
from #CSlaw csd
inner join CriteriaStmt cs on csd.criteriastmt_id=cs.criteriastmt_id 
inner join CriteriaClause cc on csd.criteriastmt_id=cc.criteriastmt_id and csd.criteriaclause_id<>cc.criteriaclause_id
inner join metafield mf on cc.field_id=mf.field_id
where mf.strfield_nm in ('DischargeStatus')


-- all of the HDischargeStatus clauses that use an "=" operator (intOperator = 1) and a value of 21
update #CSlaw
set CritType='HDisch = 21'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSlaw cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	where intOperator = 1
	and strLowValue = '21'
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
)

update #CSlaw
set CritType='Disch = 21'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSlaw cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	where intOperator = 1
	and strLowValue = '21'
	and mf.strField_nm = 'DischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
)

-- all of the HDischargeStatus clauses that use an "IN" operator (intOperator = 7) and contain '21' and '87' - which is already ok. so nothing to do
delete #CSlaw
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSlaw cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=2 and min(strListValue) = '21' and max(strListValue)= '87'
)

if exists (select * from #CSlaw where crittype is null)
begin
	rollback tran
	print 'somethings going on with DQ_Law ... '
	select Error from #CSlaw
end

-- change the HDischargeStatus criteria clause from "=" to "IN" 
update cc set intOperator=7, strLowValue=NULL
from #CSlaw cs
inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
where CritType = 'HDisch = 21'

-- and add all values for criteria claues that are "=" statements
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '21' from #CSlaw where CritType = 'HDisch = 21' union
select criteriaclause_id, '87' from #CSlaw where CritType = 'HDisch = 21' 

-- change the HDischargeStatus criteria clause from "=" to "IN" 
update cc set intOperator=7, strLowValue=NULL
from #CSlaw cs
inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
where CritType = 'Disch = 21'

-- and add all values for criteria claues that are "=" statements
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '21' from #CSlaw where CritType = 'Disch = 21' union
select criteriaclause_id, '87' from #CSlaw where CritType = 'Disch = 21' 

commit tran

-- DQ_SNF
begin tran

-- get list of all CRITERIASTMT_ID that use HDischargeStatus in DQ_SNF rule
-- drop table #CSsnf
select distinct cs.CRITERIASTMT_ID, cc.criteriaclause_id, convert(varchar(3000),strCriteriaString) as strCriteriaString, convert(varchar(30),null) as CritType
into #CSsnf
from CRITERIAstmt cs
inner join CRITERIACLAUSE cc on cs.criteriastmt_id=cc.criteriastmt_id
inner join metafield mf on cc.field_id=mf.field_id
where cs.STRCRITERIASTMT_NM in ('DQ_snf')
and mf.strfield_nm in ('HDischargeStatus')

insert into #CSsnf
select cs.criteriastmt_id, cc.criteriaclause_id, convert(varchar(3000),cs.strCriteriaString) as strCriteriaString, convert(varchar(30),null) as CritType
from #CSsnf csd
inner join CriteriaStmt cs on csd.criteriastmt_id=cs.criteriastmt_id 
inner join CriteriaClause cc on csd.criteriastmt_id=cc.criteriastmt_id and csd.criteriaclause_id<>cc.criteriaclause_id
inner join metafield mf on cc.field_id=mf.field_id
where mf.strfield_nm in ('DischargeStatus')

-- all of the HDischargeStatus clauses that use an "IN" operator (intOperator = 7) and contain '03', '3', '61', and '64'
update #CSsnf
set CritType='HDisch in (03..64)'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSsnf cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=4 and min(strListValue) = '03' and max(strListValue)= '64' and round(stdev(convert(int,strlistvalue)),6)=34.374167 
	-- the STDEV of (3, 3, 61, 64) is 34.374167. Another combination of 4 integers would come up with a different STDEV
)

update #CSsnf
set CritType='Disch in (03..64)'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSsnf cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'DischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=4 and min(strListValue) = '03' and max(strListValue)= '64' and round(stdev(convert(int,strlistvalue)),6)=34.374167 
	-- the STDEV of (3, 3, 61, 64) is 34.374167. Another combination of 4 integers would come up with a different STDEV
)

-- all of the HDischargeStatus clauses that use an "IN" operator (intOperator = 7) and contain '03', '3', '61', '64', '83', '92' - which is the desired state, so nothing to do
delete #CSsnf
where criteriaclause_id in (
	select cs.criteriaclause_id -- , min(strListValue), max(strListValue), round(stdev(convert(int,strlistvalue)),6)
	from #CSsnf cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
	where intOperator = 7
	and mf.strField_nm = 'HDischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
	having count(*)=6 and min(strListValue) = '03' and max(strListValue)= '92' and round(stdev(convert(int,strlistvalue)),6)=38.940981)
	-- the STDEV of (3, 3, 61, 64, 83, 92) is 38.940981. Another combination of 6 integers would come up with a different STDEV

update #CSsnf
set CritType='Disch = 61'
where criteriaclause_id in (
	select cs.criteriaclause_id
	from #CSsnf cs 
	inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
	inner join metafield mf on cc.field_id=mf.field_id
	where intOperator = 1
	and strLowValue = '61'
	and mf.strField_nm = 'DischargeStatus'
	group by cs.criteriastmt_id, cs.criteriaclause_id
)

if exists (select * from #CSsnf where crittype is null)
begin
	rollback tran
	print 'somethings going on with DQ_SNF ... '
end
update #CSsnf set critType='unhandled' where critType is null

-- add the new values to the in list 
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '83' from #CSsnf where CritType = 'HDisch in (03..64)' union
select criteriaclause_id, '92' from #CSsnf where CritType = 'HDisch in (03..64)' 

-- add the new values to the in list 
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '83' from #CSsnf where CritType = 'Disch in (03..64)' union
select criteriaclause_id, '92' from #CSsnf where CritType = 'Disch in (03..64)' 

-- change the DischargeStatus criteria clause from "=" to "IN" 
update cc set intOperator=7, strLowValue=NULL
from #CSsnf cs
inner join CRITERIACLAUSE cc on cs.criteriaclause_id=cc.criteriaclause_id
where CritType = 'Disch = 61'

-- and add all values for criteria claues that are "=" statements
insert into CRITERIAINLIST (criteriaclause_id, strListValue)
select criteriaclause_id, '03' from #CSsnf where CritType = 'Disch = 61' union
select criteriaclause_id, '3' from #CSsnf where CritType = 'Disch = 61' union
select criteriaclause_id, '61' from #CSsnf where CritType = 'Disch = 61' union
select criteriaclause_id, '64' from #CSsnf where CritType = 'Disch = 61' union
select criteriaclause_id, '83' from #CSsnf where CritType = 'Disch = 61' union
select criteriaclause_id, '92' from #CSsnf where CritType = 'Disch = 61' 

commit tran

go
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- 6.3. Update criteria statement table
alter table #CSdead add flag bit
alter table #CSlaw add flag bit
alter table #CSsnf add flag bit

begin tran
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42")  AND ENCOUNTERDeceasedFlag = "Y")'														from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41")  AND ENCOUNTERDeceasedFlag = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42")  AND ENCOUNTERDischargeStatus IN ("20","40","41","42") )'								from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41")  AND ENCOUNTERDischargeStatus IN ("20","41") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42")  AND ENCOUNTERServiceIndicator = "Y")' 												from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41")  AND ENCOUNTERServiceIndicator = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42")  AND POPULATIONDeceasedFlag = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41")  AND POPULATIONDeceasedFlag = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") )' 																					from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERDeceasedFlag = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDeceasedFlag = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERDischargeStatus IN ("20","40","41","42") )'								from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDischargeStatus IN ("20","41") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERDeceasedFlag = "Y")' from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDischargeStatus IN ("20","42") ) OR (ENCOUNTERDeceasedFlag = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceIndicator = "Y")'	from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDischargeStatus IN ("40","42") ) OR (ENCOUNTERServiceIndicator = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceInd_10 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_10 = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceind_100 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceind_100 = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceInd_2 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_2 = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceInd_3 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_3 = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceInd_3 IS NOT NULL)' 												from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_3 IS NOT NULL)'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceInd_6 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_6 = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceIndicator <> "0")' 												from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator <> "0")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceIndicator = "Y")' 												from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceIndicator = "Y") OR (ENCOUNTERDischargeStatus IN ("20","40","41","42") )'	from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator = "Y") OR (ENCOUNTERDischargeStatus IN ("20","41") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceIndicator IS NOT NULL)' 											from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator IS NOT NULL)'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (POPULATIONDeceasedFlag = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (POPULATIONDeceasedFlag = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (POPULATIONServiceInd_9 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (POPULATIONServiceInd_9 = "Y")'
update CS set strCriteriaString='(ENCOUNTERDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERHDischargeStatus IN ("20","40","41","42") )'								from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERDischargeStatus IN ("20","41") ) OR (ENCOUNTERHDischargeStatus IN ("20","41") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42"))' 																						from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus = "20")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") )' 																					from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("41","20") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42") ) OR (ENCOUNTERServiceInd_2 = "Y")' 													from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("41","20") ) OR (ENCOUNTERServiceInd_2 = "Y")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("20","40","41","42"))' 																						from CriteriaStmt CS inner join #CSdead x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN (''20'',''41''))'

update #CSdead 
set flag=1
where strCriteriaString in ('(ENCOUNTERHDischargeStatus IN ("20","41")  AND ENCOUNTERDeceasedFlag = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41")  AND ENCOUNTERDischargeStatus IN ("20","41") )',
'(ENCOUNTERHDischargeStatus IN ("20","41")  AND ENCOUNTERServiceIndicator = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41")  AND POPULATIONDeceasedFlag = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") )',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDeceasedFlag = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDischargeStatus IN ("20","41") )',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDischargeStatus IN ("20","42") ) OR (ENCOUNTERDeceasedFlag = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERDischargeStatus IN ("40","42") ) OR (ENCOUNTERServiceIndicator = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_10 = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceind_100 = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_2 = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_3 = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_3 IS NOT NULL)',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceInd_6 = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator <> "0")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator = "Y") OR (ENCOUNTERDischargeStatus IN ("20","41") )',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (ENCOUNTERServiceIndicator IS NOT NULL)',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (POPULATIONDeceasedFlag = "Y")',
'(ENCOUNTERHDischargeStatus IN ("20","41") ) OR (POPULATIONServiceInd_9 = "Y")',
'(ENCOUNTERDischargeStatus IN ("20","41") ) OR (ENCOUNTERHDischargeStatus IN ("20","41") )',
'(ENCOUNTERHDischargeStatus = "20")',
'(ENCOUNTERHDischargeStatus IN ("41","20") )',
'(ENCOUNTERHDischargeStatus IN ("41","20") ) OR (ENCOUNTERServiceInd_2 = "Y")',
'(ENCOUNTERHDischargeStatus IN (''20'',''41''))'
)

if exists (select * from #CSdead where flag is null)
begin
	print 'There are one or more versions of DQ_Dead that weren''t accounted for in the procedure.'
	select * from #CSdead where flag is null
end

update CS set strCriteriaString='(ENCOUNTERAdmitSource = "8") OR (ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERDischargeStatus IN ("21","87")) OR (ENCOUNTERHDischargeStatus IN ("21","87"))'							from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERAdmitSource = "8") OR (ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERDischargeStatus = "21") OR (ENCOUNTERHDischargeStatus = "21")'
update CS set strCriteriaString='(ENCOUNTERHAdmissionSource = "8" AND ENCOUNTERHDischargeStatus IN ("21","87"))'																										from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHAdmissionSource = "8" AND ENCOUNTERHDischargeStatus = "21")'
update CS set strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERDischargeStatus IN ("21","87")) OR (ENCOUNTERAdmitSource = "8") OR (ENCOUNTERHDischargeStatus IN ("21","87"))'							from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERDischargeStatus = "21") OR (ENCOUNTERAdmitSource = "8") OR (ENCOUNTERHDischargeStatus = "21")'
update CS set strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus IN ("21","87"))'																										from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus = "21")'
update CS set strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus IN ("21","87")) OR (ENCOUNTERAdmitSource = "8") OR (ENCOUNTERDischargeStatus IN ("21","87"))'							from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus = "21") OR (ENCOUNTERAdmitSource = "8") OR (ENCOUNTERDischargeStatus = "21")'
update CS set strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus IN ("21","87")) OR (POPULATIONAddr IN ("PO BOX 8","PO BOX 5000","4001 KINGS AVE","PO BOX 8700","1444 W LACEY BLVD") )'	from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus = "21") OR (POPULATIONAddr IN ("PO BOX 8","PO BOX 5000","4001 KINGS AVE","PO BOX 8700","1444 W LACEY BLVD") )'
update CS set strCriteriaString='(ENCOUNTERHAdmissionSource = "8" OR ENCOUNTERHDischargeStatus IN ("21","87"))'																											from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHAdmissionSource = ''8'' OR ENCOUNTERHDischargeStatus = ''21'')'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("21","87") AND ENCOUNTERHAdmissionSource = "8")'																										from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus = "21" AND ENCOUNTERHAdmissionSource = "8")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("21","87"))'																																			from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus = "21")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("21","87")) OR (ENCOUNTERHAdmissionSource = "8")'																										from CriteriaStmt CS inner join #CSlaw x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus = "21") OR (ENCOUNTERHAdmissionSource = "8")'

update #CSlaw
set flag=1
where strCriteriaString in ('(ENCOUNTERAdmitSource = "8") OR (ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERDischargeStatus = "21") OR (ENCOUNTERHDischargeStatus = "21")',
'(ENCOUNTERHAdmissionSource = "8" AND ENCOUNTERHDischargeStatus = "21")',
'(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERDischargeStatus = "21") OR (ENCOUNTERAdmitSource = "8") OR (ENCOUNTERHDischargeStatus = "21")',
'(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus = "21")',
'(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus = "21") OR (ENCOUNTERAdmitSource = "8") OR (ENCOUNTERDischargeStatus = "21")',
'(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus = "21") OR (POPULATIONAddr IN ("PO BOX 8","PO BOX 5000","4001 KINGS AVE","PO BOX 8700","1444 W LACEY BLVD") )',
'(ENCOUNTERHAdmissionSource = ''8'' OR ENCOUNTERHDischargeStatus = ''21'')',
'(ENCOUNTERHDischargeStatus = "21" AND ENCOUNTERHAdmissionSource = "8")',
'(ENCOUNTERHDischargeStatus = "21")',
'(ENCOUNTERHDischargeStatus = "21") OR (ENCOUNTERHAdmissionSource = "8")'
)

if exists (select * from #CSlaw where flag is null)
begin
	print 'There are one or more versions of DQ_Law that weren''t accounted for in the procedure.'
	select * from #CSlaw where flag is null
end

update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")  AND ENCOUNTERDischargeDate >= "2011-07-01")'															from CriteriaStmt CS inner join #CSsnf x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64")  AND ENCOUNTERDischargeDate >= "2011-07-01")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")  AND ENCOUNTERDischargeDate >= "2011-07-01") OR (ENCOUNTERDischargeStatus IN ("3","03","61","64","83","92"))'	from CriteriaStmt CS inner join #CSsnf x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64")  AND ENCOUNTERDischargeDate >= "2011-07-01") OR (ENCOUNTERDischargeStatus = "61")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")  AND ENCOUNTERDischargeDate >= "2011-07-01") OR (ENCOUNTERDischargeStatus IN ("3","03","61","64","83","92") )'from CriteriaStmt CS inner join #CSsnf x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64")  AND ENCOUNTERDischargeDate >= "2011-07-01") OR (ENCOUNTERDischargeStatus IN ("3","03","61","64") )'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")  AND ENCOUNTERDischargeDate >= "2011-07-01")'															from CriteriaStmt CS inner join #CSsnf x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN ("64","61","03","3")  AND ENCOUNTERDischargeDate >= "2011-07-01")'
update CS set strCriteriaString='(ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")) AND (ENCOUNTERDischargeDate >= "2011-07-01")'														from CriteriaStmt CS inner join #CSsnf x on CS.CriteriaStmt_id=x.criteriastmt_id and x.strCriteriaString='(ENCOUNTERHDischargeStatus IN (''3'',''03'',''61'',''64'')) AND (ENCOUNTERDischargeDate >= ''2011-07-01'')'

update #CSsnf
set flag=1
where strCriteriaString in ('(ENCOUNTERHDischargeStatus IN ("3","03","61","64")  AND ENCOUNTERDischargeDate >= "2011-07-01")',
'(ENCOUNTERHDischargeStatus IN ("3","03","61","64")  AND ENCOUNTERDischargeDate >= "2011-07-01") OR (ENCOUNTERDischargeStatus = "61")',
'(ENCOUNTERHDischargeStatus IN ("3","03","61","64")  AND ENCOUNTERDischargeDate >= "2011-07-01") OR (ENCOUNTERDischargeStatus IN ("3","03","61","64") )',
'(ENCOUNTERHDischargeStatus IN ("64","61","03","3")  AND ENCOUNTERDischargeDate >= "2011-07-01")',
'(ENCOUNTERHDischargeStatus IN (''3'',''03'',''61'',''64'')) AND (ENCOUNTERDischargeDate >= ''2011-07-01'')'
)

if exists (select * from #CSSNF where flag is null)
begin
	print 'There are one or more versions of DQ_SNF that weren''t accounted for in the procedure.'
	select * from #CSSNF where flag is null
end

-- rollback tran
-- commit tran

-- all hcahps criteria statements that reference HDischargeStatus and whether or not they'll be updated...
select distinct css.strClient_nm, css.strStudy_nm, css.strSurvey_Nm, sd.study_id, sd.survey_id, sd.surveytype_id, css.ClientActive, css.StudyActive, css.SurveyActive
, case when ClientActive=1 and StudyActive=1 and SurveyActive=1 and sd.strSurvey_nm not like 'x%' then 1 else 0 end as Active
, br.busrule_cd, cs.criteriastmt_id, cs.strCriteriaStmt_nm
, isnull(updt.strCriteriaString,convert(varchar(7000), cs.strCriteriaString)) as 'OriginalString'
, case when updt.criteriastmt_id is null then null else convert(varchar(7000), cs.strCriteriaString) end as 'UpdatedString'
into #DanasReport
from survey_def sd
inner join clientstudysurvey_view css on sd.survey_id=css.survey_id
inner join businessrule br on sd.survey_id=br.survey_id
inner join criteriastmt cs on br.criteriastmt_id=cs.criteriastmt_id
left outer join (select criteriastmt_id,strCriteriaString from #csdead union
				select criteriastmt_id,strCriteriaString from #cslaw union
				select criteriastmt_id,strCriteriaString from #cssnf) updt
		on updt.criteriastmt_id = cs.criteriastmt_id 
where surveytype_id=2
and cs.strCriteriaString like '%hdischargestatus%'

select * from #danasreport

rollback tran

