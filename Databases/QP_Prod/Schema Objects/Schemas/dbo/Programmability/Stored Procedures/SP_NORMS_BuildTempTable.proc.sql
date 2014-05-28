CREATE PROCEDURE SP_NORMS_BuildTempTable AS

DECLARE @sql VARCHAR(8000), @Service VARCHAR(50)

SET @sql='ALTER TABLE #SampleUnits ADD SUFacility_id INT, strFacility_nm VARCHAR(100)'

SELECT TOP 1 @Service=strService_nm FROM #Serv WHERE ParentService_id<10000 ORDER BY strService_nm

WHILE @@ROWCOUNT>0
BEGIN

	IF @Service LIKE '%-Other%'
		SET @sql=@sql+',['+@Service+'] VARCHAR(50)'
	ELSE
		SET @sql=@sql+',['+@Service+'] BIT'

	UPDATE #Serv SET ParentService_id=20000 WHERE strService_nm=@Service
	
	SELECT TOP 1 @Service=strService_nm FROM #Serv WHERE ParentService_id<10000 ORDER BY strService_nm

END

EXEC (@sql)


