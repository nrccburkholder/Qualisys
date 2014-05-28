CREATE PROCEDURE QP_Rep_ResponseRate_FullTree  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50),  
 @FirstSampleSet VARCHAR(50),  
 @LastSampleSet VARCHAR(50)  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
DECLARE @intSurvey_id INT, @intSampleSet_id1 INT, @intSampleSet_id2 INT, @intSamplePlan_id INT  
SELECT @intSurvey_id=sd.Survey_id   
FROM Survey_def sd, Study s, Client c  
WHERE c.strClient_nm=@Client  
  AND s.strStudy_nm=@Study  
  AND sd.strSurvey_nm=@Survey  
  AND c.Client_id=s.Client_id  
  AND s.Study_id=sd.Study_id  
  
SELECT @intSampleSet_id1=SampleSet_id  
FROM SampleSet  
WHERE Survey_id=@intSurvey_id  
  AND ABS(DATEDIFF(SECOND,datSampleCreate_Dt,CONVERT(DATETIME,@FirstSampleSet)))<=1  
  
SELECT @intSampleSet_id2=SampleSet_id  
FROM SampleSet  
WHERE Survey_id=@intSurvey_id  
  AND ABS(DATEDIFF(SECOND,datSampleCreate_Dt,CONVERT(DATETIME,@LastSampleSet)))<=1  
  
SELECT Sampleset_id, Sampleunit_id, INTSampled, INTUD, intReturned   
INTO #rr  
FROM DATAMART.QP_Comments.dbo.RespRateCOUNT   
WHERE Survey_id=@intSurvey_id  
  AND Sampleset_id BETWEEN @intSampleSet_id1 AND @intSampleSet_id2  
  
SELECT @intSamplePlan_id=SamplePlan_id   
FROM SamplePlan   
WHERE Survey_id=@intSurvey_id  
  
CREATE TABLE #SampleUnits  
 (SampleUnit_id INT,  
  strSampleUnit_nm VARCHAR(255),  
  INTTier INT,  
  INTTreeOrder INT,  
  INTTargetReturn INT)  
  
EXEC sp_SampleUnits @intSamplePlan_id  
  
UPDATE su SET INTtargetreturn = s.inttargetreturn  
FROM #Sampleunits su, Sampleunit s  
WHERE su.Sampleunit_id = s.Sampleunit_id  
  
SELECT ''''+ISNULL(CONVERT(VARCHAR(250),strSampleUnit_nm),'Total outgo') AS SampleUnit,  
  #rr.Sampleunit_id AS [Unit ID],  
--  su.intTreeOrder AS dummyOrder,  
  ISNULL(su.intTreeOrder,0) AS dummyOrder,  
  SUM(intSampled) AS Sampled,   
  SUM(intUD) AS Nondel,   
  SUM(intReturned) AS Returned,  
  su.inttargetreturn AS Target,  
--  sum(intReturned)/CONVERT(float,sum(intSampled)) AS RespRate,  
  SUM(intReturned)/CONVERT(FLOAT,SUM(intSampled-intUD)) AS 'Current RespRate'  
INTO #a  
FROM #rr LEFT OUTER JOIN #Sampleunits su ON #rr.Sampleunit_id=su.Sampleunit_id  
GROUP BY strSampleUnit_nm, #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder  
HAVING SUM(intSampled)-SUM(intUD)>0  
UNION  
SELECT ''''+ISNULL(CONVERT(VARCHAR(250),strSampleUnit_nm),'Total outgo') AS SampleUnit,  
  #rr.Sampleunit_id AS [Unit ID],  
  su.intTreeOrder AS dummyOrder,  
  SUM(intSampled) AS Sampled,   
  SUM(intUD) AS Nondel,   
  SUM(intReturned) AS Returned,  
  su.inttargetreturn AS Target,  
--  sum(intReturned)/CONVERT(float,sum(intSampled)) AS RespRate,  
  CONVERT(INT,null) AS 'Current RespRate'  
FROM #rr LEFT OUTER JOIN #Sampleunits su ON #rr.Sampleunit_id=su.Sampleunit_id  
GROUP BY strSampleUnit_nm, #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder  
HAVING SUM(intSampled)-SUM(intUD)=0  
--ORDER BY su.intTreeOrder  
  
CREATE TABLE #display (SampleUnit VARCHAR(250), [Unit ID] INT, dummyorder INT, Sampled INT, Nondel INT, Returned INT, Target INT, [Current RespRate] FLOAT)  
  
INSERT INTO #display (SampleUnit, [unit id], dummyorder, sampled, nondel, returned, [Current RespRate])  
SELECT ''''+'Total Outgo',0,-1,sum(intSampled), sum(intUD), sum(intReturned), (sum(intReturned)*1.0)/(sum(intSampled)-sum(intUD))  
FROM DATAMART.QP_Comments.dbo.RespRateCOUNT  
WHERE Survey_id=@intSurvey_id  
  AND Sampleset_id BETWEEN @intSampleSet_id1 AND @intSampleSet_id2  
  
/*  
INSERT INTO #display (SampleUnit, [unit id])  
SELECT  ''''+strSampleUnit_nm, SampleUnit_id  
FROM #SampleUnits  
ORDER BY intTreeOrder  
*/  
INSERT INTO #display (SampleUnit, [unit id], dummyorder)  
SELECT  ''''+strSampleUnit_nm, SampleUnit_id, inttreeorder  
FROM #SampleUnits  
ORDER BY intTreeOrder  
  
UPDATE d  
SET d.[Unit id] = a.[unit id], d.dummyorder = a.dummyorder, d.Sampled = a.Sampled, d.nondel = a.nondel, d.Returned = a.Returned, d.target = a.target, d.[current resprate] = a.[current resprate]  
FROM #display d, #a a  
WHERE d.[unit id] = a.[unit id]  
  
UPDATE d  SET d.target = su.intTargetReturn  
from #display d, SampleUnit su  
WHERE target IS NULL  
AND d.[unit id] = su.SampleUnit_id  
  
SELECT * FROM #display ORDER BY dummyorder  
  
DROP TABLE #rr  
DROP TABLE #Sampleunits  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


