CREATE PROCEDURE QP_Rep_LithoSampleUnits @Associate VARCHAR(42), @Litho VARCHAR(1000)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Study_id INT, @Survey_id INT, @strsql VARCHAR(8000)

--SELECT @Litho = CONVERT(VARCHAR,@Lithonum)

SELECT @Study_id = (SELECT TOP 1 Study_id FROM SentMailing sm(NOLOCK), QuestionForm qf(NOLOCK), Survey_def sd(NOLOCK)
WHERE sm.strLithoCode IN (@Litho)
AND sm.SentMail_id = qf.SentMail_id
AND qf.Survey_id = sd.Survey_id)

SELECT SampleUnit_id, sp.SampleSet_id, strUnitSelectType, sp.Pop_id, Survey_id 
INTO #SampleUnits 
FROM SentMailing sm(NOLOCK), QuestionForm qf(NOLOCK), SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK)
WHERE strLithoCode IN (@Litho)
AND sm.SentMail_id = qf.SentMail_id
AND qf.SamplePop_id = sp.SamplePop_id
AND sp.Pop_id = ss.Pop_id
AND sp.SampleSet_id = ss.SampleSet_id

SELECT * FROM #SampleUnits

IF EXISTS (SELECT * FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')
SET @strsql = 'SELECT strClient_nm, Survey_id, tsu.SampleUnit_id, su.strSampleUnit_nm, tsu.strUnitSelectType, e.* ' +
	' FROM #SampleUnits tsu, SampleUnit su(NOLOCK), SelectedSample ss(NOLOCK), ' +
	' s' + CONVERT(VARCHAR,@Study_id) + '.Encounter e(NOLOCK), Study s(NOLOCK), Client c(NOLOCK) ' +
	' WHERE tsu.Pop_id = ss.Pop_id ' +
	' AND tsu.SampleSet_id = ss.SampleSet_id ' +
	' AND tsu.SampleUnit_id = ss.SampleUnit_id ' +
	' AND ss.Enc_id = e.Enc_id ' +
	' AND su.SamplePlan_id = (SELECT DISTINCT SamplePlan_id FROM SampleUnit(NOLOCK) WHERE SampleUnit_id IN (SELECT SampleUnit_id FROM #SampleUnits)) ' +
	' AND su.SampleUnit_id = ss.SampleUnit_id ' +
	' AND s.Study_id = ' + CONVERT(VARCHAR,@Study_id) +
	' AND s.Client_id = c.Client_id '
ELSE
SET @strsql = 'SELECT strClient_nm, Survey_id, tsu.SampleUnit_id, su.strSampleUnit_nm, tsu.strUnitSelectType, p.* ' +
	' FROM #SampleUnits tsu, SampleUnit su(NOLOCK), SelectedSample ss(NOLOCK), ' +
	' s' + CONVERT(VARCHAR,@Study_id) + '.Population p(NOLOCK), Study s(NOLOCK), Client c(NOLOCK) ' +
	' WHERE tsu.Pop_id = ss.Pop_id ' +
	' AND tsu.SampleSet_id = ss.SampleSet_id ' +
	' AND tsu.SampleUnit_id = ss.SampleUnit_id ' +
	' AND ss.Pop_id = p.Pop_id ' +
	' AND su.SamplePlan_id = (SELECT DISTINCT SamplePlan_id FROM SampleUnit(NOLOCK) WHERE SampleUnit_id IN (SELECT SampleUnit_id FROM #SampleUnits)) ' +
	' AND su.SampleUnit_id = ss.SampleUnit_id ' +
	' AND s.Study_id = ' + CONVERT(VARCHAR,@Study_id) +
	' AND s.Client_id = c.Client_id '

PRINT @strsql
EXEC(@strsql)

DROP TABLE #SampleUnits

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


