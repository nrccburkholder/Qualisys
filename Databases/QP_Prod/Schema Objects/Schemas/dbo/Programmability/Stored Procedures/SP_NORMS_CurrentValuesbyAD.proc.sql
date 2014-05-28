CREATE PROCEDURE SP_NORMS_CurrentValuesbyAD
AS

SET NOCOUNT ON

CREATE TABLE #SampleUnits (AD VARCHAR(42), HasDefinition CHAR(1), strClient_nm VARCHAR(42), Client_id INT, strStudy_nm VARCHAR(42), Study_id INT, strSurvey_nm VARCHAR(42), Survey_id INT, SampleUnit_id INT,strSampleUnit_nm VARCHAR(60), datLastUpdated DATETIME, intTier INT, intTreeOrder INT)

SELECT SamplePlan_id
INTO #SamplePlans
FROM SamplePlan sp, Survey_def sd
WHERE sp.Survey_id=sd.Survey_id

DECLARE @SamplePlan INT, @sql VARCHAR(100)

SELECT TOP 1 @SamplePlan=SamplePlan_id FROM #SamplePlans

WHILE @@ROWCOUNT>0
BEGIN

SET @sql='EXEC SP_SampleUnits '+CONVERT(VARCHAR,@SamplePlan)
EXEC (@sql)

DELETE #SamplePlans WHERE SamplePlan_id=@SamplePlan

SELECT TOP 1 @SamplePlan=SamplePlan_id FROM #SamplePlans

END

UPDATE su
SET su.datLastUpdated=sus.datLastUpdated
FROM #SampleUnits su, SampleUnitService sus
WHERE su.SampleUnit_id=sus.SampleUnit_id

UPDATE t
SET t.Survey_id=sp.Survey_id
FROM #SampleUnits t, SampleUnit su, SamplePlan sp
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.SamplePlan_id=sp.SamplePlan_id

UPDATE t
SET t.AD=e.strNTLogin_nm, t.strClient_nm=c.strClient_nm, t.Client_id=c.Client_id, t.strStudy_nm=s.strStudy_nm, t.Study_id=s.Study_id, t.strSurvey_nm=sd.strSurvey_nm
FROM #SampleUnits t, Survey_def sd, Client c, Study s LEFT OUTER JOIN Employee e
ON s.adEmployee_id=e.Employee_id
WHERE t.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id
AND s.Client_id=c.Client_id

UPDATE t
SET HasDefinition=1
FROM #SampleUnits t, SampleUnitService sus
WHERE t.SampleUnit_id=sus.SampleUnit_id

SELECT SampleUnit_id, sus.Service_id, s.strService_nm
INTO #Temp
FROM SampleUnitService sus, Service s
WHERE sus.Service_id=s.Service_id

SELECT *
INTO #Serv
FROM Service

UPDATE t
SET t.strService_nm=t2.strService_nm+'-'+t.strService_nm
FROM #Serv t, #Serv t2
WHERE t.ParentService_id=t2.Service_id

UPDATE #Serv
SET strService_nm=strService_nm+'('+CONVERT(VARCHAR,Service_id)+')', ParentService_id=1

EXEC SP_NORMS_BuildTempTable 
EXEC SP_NORMS_PopulateTempTable

--ALTER TABLE #SampleUnits DROP COLUMN intTier, intTreeOrder, SUFacility_id

SELECT * FROM #SampleUnits ORDER BY AD, strClient_nm, strStudy_nm, strSurvey_nm

DROP TABLE #Serv
DROP TABLE #SampleUnits
DROP TABLE #SamplePlans
DROP TABLE #Temp


