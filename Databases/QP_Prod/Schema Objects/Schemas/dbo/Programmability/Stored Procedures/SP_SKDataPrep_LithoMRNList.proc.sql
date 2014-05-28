CREATE PROCEDURE SP_SKDataPrep_LithoMRNList
	@Study_id		INT,
	@datPrinted		DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @sql VARCHAR(8000)

SELECT strLithoCode, Survey_id, CASE bitFirstSurvey WHEN 1 THEN 'First' ELSE 'Second' END MailStep, sp.SampleSet_id, sp.Pop_id
INTO #Work
FROM SentMailing sm, SamplePop sp, ScheduledMailing schm, MailingStep ms
WHERE sp.Study_id=@Study_id
AND sp.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id=sm.SentMail_id
AND schm.MailingStep_id=ms.MailingStep_id
AND CONVERT(DATETIME,DATEDIFF(DAY,0,sm.datPrinted))=@datPrinted

SELECT t.Survey_id, SampleUnit_id
INTO #RootUnits
FROM (SELECT DISTINCT Survey_id FROM #Work) t, SamplePlan sp, SampleUnit su
WHERE t.Survey_id=sp.Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.ParentSampleUnit_id IS NULL

SELECT @sql='SELECT strLithoCode, MailStep, POPULATIONMRN MRN, ENCOUNTERVisitNum VisitNum, FACILITYFacilityName FacilityName, FACILITYFacilityName2 HealthAuthorityName
FROM S'+LTRIM(STR(@Study_id))+'.Big_View b, #Work t, SelectedSample ss, #RootUnits ru
WHERE t.SampleSet_id=ss.SampleSet_id
AND t.Pop_id=ss.Pop_id
AND t.Survey_id=ru.Survey_id
AND ru.SampleUnit_id=ss.SampleUnit_id
AND ss.Enc_id=b.ENCOUNTEREnc_id'
EXEC (@sql)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


