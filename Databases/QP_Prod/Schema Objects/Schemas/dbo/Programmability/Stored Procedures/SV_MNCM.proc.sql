CREATE PROCEDURE [dbo].[SV_MNCM] @survey_ID int as
begin


/**
12/10/2010 dmp
Commenting out question checking section.
Some CG-CAHPS surveys use an older alternate question (39161) instead of 40716,
and are near the 1024 column limit so can't add the newer question.
**/

/*
Test Code:
SV_MNCM 187
*/

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--If this is not an MNCM Survey, end the procedure
IF (SELECT SurveyType_id FROM Survey_def WHERE Survey_id=@Survey_id)<>4
BEGIN
    RETURN
END

CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))

/* 9/25/2013 DBG.
If you ever add question checking back and NCQA adds or removes questions from the standard survey, there are now datEncounterStart_dt and datEncounterEnd_dt fields
in SurveyTypeQuestionMappings. All (SurveyType_id=4) records currently have a date range of '1/1/1900' to '12/31/2999'.  If NCQA drops questions, you can change the
datEncounterEnd_dt value to the day before the next fielding period. New questions would need new records with the datEncounterStart_dt value of the first day of the
new fielding period.

You'd then change the following query so it has "and @ExpectedEncStart between datEncounterStart_dt and datEncounterEnd_dt" in the where clause.
Figure out what @ExpectedEncStart is by looking at PeriodDef.datExpectedEncStart. See how the [SV_HCAHPS] procedure builds the #Period table
for an example of this.

*/

/** Commenting out question checking

--Make sure all of the MNCM questions are on the form and in the correct location.
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
Select surveytype_id, qstncore, intorder, bitfirstonform
into #MNCM_SurveyTypeQuestionMappings
from SurveyTypeQuestionMappings
where SurveyType_id = 4

--Look for questions missing from the form.
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
FROM #MNCM_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
WHERE s.SurveyType_id=4
  AND t.QstnCore IS NULL

--Look for questions that are out of order.
--First the questions that have to be at the beginning of the form.
INSERT INTO #M (Error, strMessage)
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
FROM #MNCM_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
ON s.QstnCore=t.QstnCore
AND s.intOrder=t.Order_id
AND s.SurveyType_id=4
WHERE bitFirstOnForm=1
AND t.QstnCore IS NULL

--Now the questions that are at the end of the form.
SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
INTO #OrderCheck
from #MNCM_SurveyTypeQuestionMappings qm, #CurrentForm t
WHERE qm.SurveyType_id=4
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
 SELECT 0,'All MNCM Questions are on the form in the correct order.'

 --IF all 27 cores or on the survey, then check that the 27 questions are mapped
 --in a manner that ensures someone sampled at the HCAHP units will get all of them
 SELECT sampleunit_id
 into #MNCMUnits
 FROM SampleUnit su, SamplePlan sp
 WHERE sp.Survey_id=@Survey_id
 AND sp.SamplePlan_id=su.SamplePlan_id
 AND bitMNCM=1

 DECLARE @sampleunit_id int

 SELECT TOP 1 @sampleunit_id=sampleunit_id
 FROM #MNCMUnits

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
   RIGHT JOIN #MNCM_SurveyTypeQuestionMappings stqm
   ON Q.QstnCore=stqm.QstnCore
  WHERE stqm.SurveyType_id=4
     AND Q.QstnCore IS NULL

  IF @@ROWCOUNT=0
   INSERT INTO #M (Error, strMessage)
   SELECT 0,'All MNCM Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)

  DELETE
  FROM #MNCMUnits
  WHERE sampleunit_Id=@sampleunit_id

  SELECT TOP 1 @sampleunit_id=sampleunit_id
  FROM #MNCMUnits
 END
END
--End of Question checking

**/




--Make sure we have at least one MNCM sampleunit
IF (SELECT COUNT(*)
    FROM SampleUnit su, SamplePlan sp
    WHERE sp.Survey_id=@Survey_id
    AND sp.SamplePlan_id=su.SamplePlan_id
    AND bitMNCM=1)<1
INSERT INTO #M (Error, strMessage)
SELECT 1,'Survey must have at least one MNCM Sampleunit.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0,'Survey has one MNCM Sampleunit.'


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
  SELECT 2,'Survey uses a custom methodology.'         --changed to warning 06/24/2013 dmp
 ELSE IF EXISTS(
   SELECT *
   FROM #ActiveMethodology
   WHERE standardmethodologyid in
    (select StandardMethodologyID
     from StandardMethodologyBySurveyType
     where SurveyType_id = 4
    )
   )
  INSERT INTO #M (Error, strMessage)
  SELECT 0,'Survey uses a standard MNCM methodology.'
 ELSE
  INSERT INTO #M (Error, strMessage)
  SELECT 2,'Survey does not use a standard MNCM methodology.'        --changed to warning 06/24/2013 dmp
END

select * from #M

DROP TABLE #ActiveMethodology
end


