CREATE PROCEDURE SP_NORMS_SampleUnitDef2 @Survey INT
AS

SET NOCOUNT ON

DECLARE @intSamplePlan_id INT, @SampleUnit INT, @Service INT

SELECT @intSamplePlan_id=SamplePlan_id FROM SamplePlan WHERE Survey_id=@Survey

CREATE TABLE #SampleUnits (
	SampleUnit_id 		INT,
	strSampleUnit_nm 	VARCHAR(50),
	intTier 		INT,
	intTreeOrder 		INT, 
	SUFacility_id 		INT, 
	strFacility_nm 		VARCHAR(100), 
	Services 		VARCHAR(2000), 
	AltServiceName 		VARCHAR(50),
	datLastUpdated		VARCHAR(50))

--EXEC SP_SampleUnits @intSamplePlan_id

INSERT INTO #SampleUnits (SampleUnit_id, strSampleUnit_nm, intTier, intTreeOrder)
SELECT SampleUnit_id, SUBSTRING('                    ',1,(intLevel-1)*2)+strSampleUnit_nm, intLevel, intOrder
FROM nrc47.qp_comments.dbo.sampleunit
WHERE Survey_id=@Survey

UPDATE t
SET t.SUFacility_id=suf.SUFacility_id, t.strFacility_nm=suf.strFacility_nm, Services=su.SUServices
FROM #SampleUnits t, SampleUnit su, SUFacility suf
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.SUFacility_id=suf.SUFacility_id

/*
--Build a comma seperated list of Services for each sampleunit
SELECT sus.SampleUnit_id, sus.Service_id, ParentService_id
INTO #sus
FROM SampleUnitService sus, #SampleUnits t, Service s
WHERE t.SampleUnit_id=sus.SampleUnit_id
AND sus.Service_id=s.Service_id

print 'start of loop'
select getdate()

SELECT TOP 1 @SampleUnit=SampleUnit_id, @Service=Service_id FROM #sus ORDER BY SampleUnit_id, ParentService_id

WHILE @@ROWCOUNT>0
BEGIN

	IF (SELECT Services FROM #SampleUnits WHERE SampleUnit_id=@SampleUnit) IS NULL
		UPDATE #SampleUnits SET Services=CONVERT(VARCHAR,@Service) WHERE SampleUnit_id=@SampleUnit
	ELSE
		UPDATE #SampleUnits SET Services=Services+','+CONVERT(VARCHAR,@Service) WHERE SampleUnit_id=@SampleUnit
	
	DELETE #sus WHERE SampleUnit_id=@SampleUnit AND Service_id=@Service
	
	SELECT TOP 1 @SampleUnit=SampleUnit_id, @Service=Service_id FROM #sus ORDER BY SampleUnit_id, ParentService_id

END

print 'end of loop'
select getdate()
*/
UPDATE su
SET su.AltServiceName=sus.strAltService_nm
FROM SampleUnitService sus, #Sampleunits su
WHERE sus.SampleUnit_id=su.SampleUnit_id
AND sus.strAltService_nm IS NOT NULL

UPDATE su
SET su.datLastUpdated=CONVERT(VARCHAR,sus.datLastUpdated)
FROM SampleUnitService sus, #Sampleunits su
WHERE sus.SampleUnit_id=su.SampleUnit_id

SELECT SampleUnit_id, strSampleUnit_nm, intTier, intTreeOrder, SUFacility_id, strFacility_nm, Services, ISNULL(AltServiceName,'') AltServiceName, datLastUpdated
FROM #SampleUnits
ORDER BY intTreeOrder

--Now to get the list of all Facilities for the given client
SELECT SUFacility_id, strFacility_nm+' - '+City+', '+State strFacility_nm
FROM SUFacility suf, Study s, Survey_def sd
WHERE sd.Survey_id=@Survey
AND sd.Study_id=s.Study_id
--AND s.Client_id=suf.Client_id

DROP TABLE #SampleUnits


