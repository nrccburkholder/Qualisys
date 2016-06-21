DECLARE @DataFile_id int
SET @DataFile_id = 409094	

----Re-queueing the file at AwaitingAddressClean state
--BEGIN TRANSACTION
--UPDATE [dbo].[DataFileState]
--SET State_id = 2, StateDescription = 'AwaitingAddressClean', StateParameter = 'Debugging Timeouts', datOccurred = GetDate()
--WHERE              DataFile_id = @DataFile_id 
--            AND State_id = 11
--            AND StateParameter ='Address Cleaning Exception: The operation has timed out'
--COMMIT TRANSACTION

SELECT Study_id, intRecords, * FROM dbo.DataFile DF
INNER JOIN dbo.Package P ON DF.Package_id = P.Package_id
WHERE DataFile_id = @DataFile_id

SELECT * FROM [dbo].[DataFileState_History]
WHERE DataFile_id = @DataFile_id
ORDER BY datOccurred

SELECT * FROM [dbo].[DataFileState]
WHERE DataFile_id = @DataFile_id

SELECT COUNT(*), COUNT(AddrStat) FROM s2934.population_load
WHERE DataFile_id = @DataFile_id
