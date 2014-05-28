CREATE PROCEDURE SP_NORMS_CurrentValues @Survey INT
AS

SET NOCOUNT ON

DECLARE @intSamplePlan_id INT, @sql VARCHAR(8000), @Service VARCHAR(50)

SELECT @intSamplePlan_id=SamplePlan_id FROM SamplePlan WHERE Survey_id=@Survey

CREATE TABLE #SampleUnits (SampleUnit_id INT,strSampleUnit_nm VARCHAR(50), datLastUpdated DATETIME, intTier INT, intTreeOrder INT)

EXEC SP_SampleUnits @intSamplePlan_id

UPDATE su
SET su.datLastUpdated=sus.datLastUpdated
FROM #SampleUnits su, SampleUnitService sus
WHERE su.SampleUnit_id=sus.SampleUnit_id

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

SELECT * FROM #SampleUnits

DROP TABLE #Serv
DROP TABLE #SampleUnits
DROP TABLE #Temp


