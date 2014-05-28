CREATE PROCEDURE SP_NORMS_PopulateTempTable AS

UPDATE t
SET t.SUFacility_id=suf.SUFacility_id, t.strFacility_nm=suf.strFacility_nm
FROM #SampleUnits t, SampleUnit su, SUFacility suf
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.SUFacility_id=suf.SUFacility_id

DECLARE @sql VARCHAR(8000), @Service VARCHAR(50)

SELECT TOP 1 @Service=strService_nm FROM #Serv WHERE ParentService_id>10000 

WHILE @@ROWCOUNT>0
BEGIN

	IF @Service LIKE '%-Other%'
	SET @sql='UPDATE t '+CHAR(10)+
		' SET t.['+@Service+']=CASE WHEN strAltService_nm IS NULL THEN ''TRUE'' WHEN strAltService_nm='''' THEN ''TRUE'' ELSE strAltService_nm END '+CHAR(10)+
		' FROM #Serv s, #SampleUnits t, SampleUnitService sus '+CHAR(10)+
		' WHERE t.SampleUnit_id=sus.SampleUnit_id '+CHAR(10)+
		' AND s.Service_id=sus.Service_id '+CHAR(10)+
		' AND s.strService_nm='''+@Service+''''
	ELSE
	SET @sql='UPDATE t '+CHAR(10)+
		' SET t.['+@Service+']=1 '+CHAR(10)+
		' FROM #Serv s, #SampleUnits t, SampleUnitService sus '+CHAR(10)+
		' WHERE t.SampleUnit_id=sus.SampleUnit_id '+CHAR(10)+
		' AND s.Service_id=sus.Service_id '+CHAR(10)+
		' AND s.strService_nm='''+@Service+''''

	EXEC (@sql)
	
	UPDATE #Serv SET ParentService_id=1 WHERE strService_nm=@Service
	
	SELECT TOP 1 @Service=strService_nm FROM #Serv WHERE ParentService_id>10000 

END


