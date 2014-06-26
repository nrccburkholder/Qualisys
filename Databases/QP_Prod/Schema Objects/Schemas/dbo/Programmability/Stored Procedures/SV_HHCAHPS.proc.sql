CREATE PROCEDURE [dbo].[SV_HHCAHPS]
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


