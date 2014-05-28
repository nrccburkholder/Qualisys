CREATE PROCEDURE QP_Rep_eseSurveys
 @Associate VARCHAR(50),
 @Client VARCHAR(50),
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @BeginDate DATETIME,
 @EndDate DATETIME
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @intSurvey_id INT, @intStudy_id INT, @strsql VARCHAR(2000)
SELECT @intSurvey_id=sd.Survey_id, @intStudy_id=s.Study_id 
FROM Survey_def sd, Study s, Client c
WHERE c.strClient_nm=@Client
  AND s.strStudy_nm=@Study
  AND sd.strSurvey_nm=@Survey
  AND c.Client_id=s.Client_id
  AND s.Study_id=sd.Study_id

CREATE TABLE #sp (strLithoCode VARCHAR(15), SamplePop_id INT, Pop_id INT, strSampleUnit_nm VARCHAR(42), Enc_id INT)

INSERT INTO #sp
SELECT strLithoCode, SamplePop_id, NULL, NULL, NULL
FROM sentmailing sm, scheduledmailing schm, mailingstep ms
WHERE ms.Survey_id=@intSurvey_id
AND ms.mailingstep_id=schm.mailingstep_id
AND schm.sentmail_id=sm.sentmail_id
AND sm.datgenerated BETWEEN @BeginDate AND @EndDate+'23:59:59:000'

UPDATE t
SET t.Pop_id=sp.Pop_id, t.strSampleUnit_nm=su.strSampleUnit_nm
FROM #sp t, Samplepop sp, SelectedSample ss, SampleUnit su
WHERE t.SamplePop_id=sp.SamplePop_id
AND sp.SampleSet_id=ss.SampleSet_id
AND sp.Pop_id=ss.Pop_id
--AND ss.intExtracted_flg=1
AND ss.strUnitSelectType='D'
AND ss.SampleUnit_id=su.SampleUnit_id

IF EXISTS (SELECT * FROM MetaData_View WHERE Study_id=@intStudy_id AND strTable_nm='ENCOUNTER' AND Field_id=117)
BEGIN

SET @strsql='UPDATE t
SET t.Enc_id=ss.Enc_id
FROM #sp t, Samplepop sp, SelectedSample ss, SampleUnit su
WHERE t.SamplePop_id=sp.SamplePop_id
AND sp.SampleSet_id=ss.SampleSet_id
AND sp.Pop_id=ss.Pop_id
AND su.ParentSampleUnit_id IS NULL
AND ss.SampleUnit_id=su.SampleUnit_id'

EXEC (@strsql)

SET @strsql='SELECT strLithoCode, strSampleUnit_nm, fname, lname, addr, city, st, Zip5_Foreign, zip4, CONVERT(VARCHAR(11),servicedate,100) ServiceDate
FROM #sp t, s'+CONVERT(VARCHAR,@intStudy_id)+'.population p, s'+CONVERT(VARCHAR,@intStudy_id)+'.encounter e
WHERE t.Pop_id=p.Pop_id
AND t.Enc_id=e.Enc_id
AND Langid=99999
ORDER BY strLithoCode'

EXEC (@strsql)

END

ELSE 
BEGIN

SET @strsql='SELECT strLithoCode, strSampleUnit_nm, fname, lname, addr, city, st, Zip5_Foreign, zip4
FROM #sp t, s'+CONVERT(VARCHAR,@intStudy_id)+'.population p
WHERE t.Pop_id=p.Pop_id
AND Langid=99999
ORDER BY strLithoCode'

EXEC (@strsql)

END

DROP TABLE #sp
SET NOCOUNT OFF


