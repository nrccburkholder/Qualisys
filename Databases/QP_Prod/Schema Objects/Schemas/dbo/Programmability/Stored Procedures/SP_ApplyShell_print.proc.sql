CREATE PROCEDURE SP_ApplyShell_print @Study_id INT, @DataSet INT OUTPUT
AS

DECLARE @DataSet_id INT, @sql VARCHAR(8000)

--Add a record to Data_Set
INSERT INTO Data_Set (Study_id, datLoad_dt,intGood_Recs,intBad_Recs)
SELECT @Study_id, GETDATE(),0,0

SELECT @DataSet_id=SCOPE_IDENTITY()

SELECT @DataSet=@DataSet_id

select * from data_set where dataset_id=@dataset_id

--Update the address counts
SELECT @sql='DECLARE @intAddrNoChg INT, @intAddrCleaned INT, @intAddrError INT
	SELECT @intAddrNoChg=SUM(CASE WHEN AddrStat IS NULL THEN 1 ELSE 0 END), 
		@intAddrCleaned=SUM(CASE WHEN AddrStat IS NULL THEN 0 ELSE 1 END),
		@intAddrError=SUM(CASE WHEN AddrErr IS NULL THEN 0 ELSE 1 END)
	FROM S'+LTRIM(STR(@Study_id))+'.Population_Load
	UPDATE Data_Set SET intAddrNoChg=@intAddrNoChg, intAddrCleaned=@intAddrCleaned,
		intAddrError=@intAddrError 
	WHERE DataSEt_id='+LTRIM(STR(@DataSet_id))
PRINT @sql
EXEC (@sql)

select * from data_set where dataset_id=@dataset_id

PRINT 'updated the dataset record, now to run the apply proc.'

select @Study_id
select @Dataset_id

select GETDATE()

--Now to run the apply procedure
EXEC sp_LoadApply_print @Study_id, 0

select GETDATE()
print 'apply proc completed'

select GETDATE()
--Now to populate DataSetMember
EXEC SP_Apply_PopulateDataSetMember @Study_id, @DataSet_id
select GETDATE()

print 'datasetmember should be populated'


