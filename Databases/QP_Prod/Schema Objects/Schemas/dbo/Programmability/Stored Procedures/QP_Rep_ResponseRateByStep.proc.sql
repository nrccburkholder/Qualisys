CREATE PROCEDURE QP_Rep_ResponseRateByStep
 @Associate VARCHAR(50),
 @Client VARCHAR(50),
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @FirstSampleSet VARCHAR(50),
 @LastSampleSet VARCHAR(50)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @intSurvey_id INT, @intSamplePlan_id INT
SELECT @intSurvey_id=sd.Survey_id, @intSamplePlan_id=sp.SamplePlan_id
FROM Sampleplan sp, Survey_def sd, Study s, Client c
WHERE c.strClient_nm=@Client
  AND s.strStudy_nm=@Study
  AND sd.strSurvey_nm=@Survey
  AND c.Client_id=s.Client_id
  AND s.Study_id=sd.Study_id
  AND sp.Survey_id=sd.Survey_id

CREATE TABLE #SampleUnits (SampleUnit_id INT, strSampleUnit_nm VARCHAR(100), intTier INT, intTreeOrder INT, intTargetReturn INT)
EXEC sp_SampleUnits @intSamplePlan_id, 4

UPDATE su SET intTargetReturn = s.intTargetReturn
FROM #SampleUnits su, SampleUnit s
WHERE su.SampleUnit_id = s.SampleUnit_id

DELETE t
FROM #SampleUnits t, SampleUnit su
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.bitSuppress=1

CREATE TABLE #UnitSelection (strUnitSelectType CHAR(1))
INSERT #UnitSelection VALUES ('D')
IF (SELECT bitDynamic FROM Survey_def WHERE Survey_id=@intSurvey_id)=0
  INSERT #UnitSelection VALUES ('I')

SELECT ss.SampleUnit_id AS Unit_id, su.strSampleUnit_nm AS [Sample Unit], ms.strMailingStep_nm AS [Mailing Step],
  COUNT(*) AS Mailed, 
  SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 0 ELSE 1 END) AS Undeliverable, 
  SUM(CASE WHEN qf.datReturned IS NULL THEN 0 ELSE 1 END) AS Returned, 
  su.intTargetReturn AS Target,
--  SUM(CASE WHEN qf.datReturned IS NULL THEN 0 ELSE 1 END)/SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 1.0 ELSE 0.0 END) AS [Response Rate],
-- Modified 6/26/3 BD set outgo = 1 if outgo = 0
  SUM(CASE WHEN qf.datReturned IS NULL THEN 0 ELSE 1 END)/CASE (SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 1.0 ELSE 0.0 END)) WHEN 0 THEN 1.0 ELSE 
		(SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 1.0 ELSE 0.0 END)) END AS [Response Rate],LangID, 
  su.intTreeOrder AS dummyOrder, ms.intSequence AS dummySequence
FROM MailingStep ms, SentMailing sm LEFT OUTER JOIN QuestionForm qf on sm.SentMail_id=qf.SentMail_id, 
  ScheduledMailing scm, SamplePop sp, SelectedSample ss, #UnitSelection us, SampleSet sst, #SampleUnits su
WHERE ms.intSequence=1
  AND ms.Survey_id=@intSurvey_id
  AND ms.bitThankYouItem=0
  AND sm.datMailed IS NOT NULL
  AND ms.MailingStep_id=scm.MailingStep_id
  AND sm.SentMail_id=scm.SentMail_id
  AND scm.SamplePop_Id=sp.SamplePop_id
  AND sp.SampleSet_id=ss.SampleSet_id
  AND sp.Pop_id=ss.Pop_id
  AND ss.strUnitSelectType=us.strUnitSelectType
  AND ss.SampleSet_id=sst.SampleSet_id
  AND sst.datSampleCreate_dt BETWEEN @FirstSampleSet AND DATEADD(SECOND,1,@LastSampleSet)
  AND ss.SampleUnit_id=su.SampleUnit_id
GROUP BY LangID, su.intTreeOrder, ms.intSequence, ss.SampleUnit_id, su.intTargetReturn, su.strSampleUnit_nm, ms.strMailingStep_nm
UNION
SELECT null AS Unit_id, '' AS [Sample Unit], ms.strMailingStep_nm AS [Mailing Step], 
  COUNT(*) AS Mailed, 
  SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 0 ELSE 1 END) AS Undeliverable, 
  SUM(CASE WHEN qf.datReturned IS NULL THEN 0 ELSE 1 END) AS Returned,
  su.intTargetReturn AS Target,
--  SUM(CASE WHEN qf.datReturned IS NULL THEN 0 ELSE 1 END)/SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 1.0 ELSE 0.0 END) AS [Response Rate],
-- Modified 6/26/3 BD set outgo = 1 if outgo = 0
  SUM(CASE WHEN qf.datReturned IS NULL THEN 0 ELSE 1 END)/CASE (SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 1.0 ELSE 0.0 END)) WHEN 0 THEN 1.0 ELSE 
		(SUM(CASE WHEN sm.datUnDeliverable IS NULL THEN 1.0 ELSE 0.0 END)) END AS [Response Rate],LangID, 
  su.intTreeOrder AS dummyOrder, ms.intSequence AS dummySequence
FROM MailingStep ms, SentMailing sm LEFT OUTER JOIN QuestionForm qf on sm.SentMail_id=qf.SentMail_id, 
  ScheduledMailing scm, SamplePop sp, SelectedSample ss, #UnitSelection us, SampleSet sst, #SampleUnits su
WHERE ms.intSequence<>1
  AND ms.Survey_id=@intSurvey_id
  AND ms.bitThankYouItem=0
  AND sm.datMailed IS NOT NULL
  AND ms.MailingStep_id=scm.MailingStep_id
  AND sm.SentMail_id=scm.SentMail_id
  AND scm.SamplePop_Id=sp.SamplePop_id
  AND sp.SampleSet_id=ss.SampleSet_id
  AND sp.Pop_id=ss.Pop_id
  AND ss.strUnitSelectType=us.strUnitSelectType
  AND ss.SampleSet_id=sst.SampleSet_id
  AND sst.datSampleCreate_dt BETWEEN @FirstSampleSet AND DATEADD(SECOND,1,@LastSampleSet)
  AND ss.SampleUnit_id=su.SampleUnit_id
GROUP BY LangID, su.intTreeOrder, ms.intSequence, ss.SampleUnit_id, su.intTargetReturn, su.strSampleUnit_nm, ms.strMailingStep_nm
ORDER BY dummyOrder,dummySequence

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


