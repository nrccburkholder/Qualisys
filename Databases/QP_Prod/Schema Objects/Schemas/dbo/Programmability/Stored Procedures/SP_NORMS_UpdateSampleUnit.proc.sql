CREATE PROCEDURE SP_NORMS_UpdateSampleUnit @SampleUnit INT, @Services VARCHAR(3000), @Facility INT=NULL, @AltService VARCHAR(50)=NULL, @Employee VARCHAR(42)='JCamp'
AS

INSERT INTO AuditLog (Employee_id, Study_id, Survey_id, datChanged, AuditCategory_id, AuditType_id, Module_nm, Field_nm, Previous_Value, New_Value)
SELECT e.Employee_id, sd.Study_id, sd.Survey_id, GETDATE(), 15, 2, 'SampleUnitService', strSampleUnit_nm, '', 
		'Services='+@Services+' Facility='+ISNULL(CONVERT(VARCHAR,@Facility),'NULL')+' AltServname='+ISNULL(@AltService,'NULL')
FROM SampleUnit su, SamplePlan sp, Survey_def sd, Employee e
WHERE su.SampleUnit_id=@SampleUnit
AND su.SamplePlan_id=sp.SamplePlan_id
AND sp.Survey_id=sd.Survey_id
AND e.strNTLogin_nm=@Employee

DECLARE @sql VARCHAR(8000)

SET @AltService=ISNULL(@AltService,'NULL')

CREATE TABLE #Temp (Service_id INT, SampleUnit_id INT, AltService VARCHAR(50))

SET @sql='INSERT INTO #Temp '+CHAR(10)+
	' SELECT Service_id, '+CONVERT(VARCHAR,@SampleUnit)+', CASE WHEN strService_nm LIKE ''Other%'' THEN '''+@AltService+''' ELSE NULL END'+CHAR(10)+
	' FROM Service '+CHAR(10)+
	' WHERE Service_id in ('+@Services+')'
EXEC (@sql)

WHILE @@ROWCOUNT>0
BEGIN

INSERT INTO #Temp
SELECT DISTINCT ParentService_id, SampleUnit_id, NULL
FROM #Temp t, Service s
WHERE t.Service_id=s.Service_id
AND ParentService_id NOT IN (SELECT DISTINCT Service_id FROM #Temp)

END

DELETE SampleUnitService
WHERE SampleUnit_id=(SELECT TOP 1 SampleUnit_id FROM #Temp)

INSERT INTO SampleUnitService (SampleUnit_id, Service_id, strAltService_nm, datLastUpdated)
SELECT SampleUnit_id, Service_id, AltService, GETDATE()
FROM #Temp

DROP TABLE #Temp

UPDATE SampleUnit
SET SUFacility_id=@Facility, SUServices=@Services
WHERE SampleUnit_id=@SampleUnit


