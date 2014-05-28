CREATE PROCEDURE [dbo].[SP_ApplyShell] @Study_id INT, @DataSet INT OUTPUT
AS

DECLARE @DataSet_id INT, @sql VARCHAR(8000)

--Add a record to Data_Set
INSERT INTO Data_Set (Study_id, datLoad_dt,intGood_Recs,intBad_Recs)
SELECT @Study_id, GETDATE(),0,0

SELECT @DataSet_id=SCOPE_IDENTITY()

SELECT @DataSet=@DataSet_id

--Update the address counts
SELECT @sql='DECLARE @intAddrNoChg INT, @intAddrCleaned INT, @intAddrError INT
	SELECT @intAddrNoChg=SUM(CASE WHEN AddrStat IS NULL THEN 1 ELSE 0 END), 
		@intAddrCleaned=SUM(CASE WHEN AddrStat IS NULL THEN 0 ELSE 1 END),
		@intAddrError=SUM(CASE WHEN AddrErr IS NULL THEN 0 ELSE 1 END)
	FROM S'+LTRIM(STR(@Study_id))+'.Population_Load
	UPDATE Data_Set SET intAddrNoChg=@intAddrNoChg, intAddrCleaned=@intAddrCleaned,
		intAddrError=@intAddrError 
	WHERE DataSEt_id='+LTRIM(STR(@DataSet_id))
EXEC (@sql)

--Now to run the apply procedure
EXEC SP_LoadApply @Study_id, 0

--Now to populate DataSetMember
EXEC SP_Apply_PopulateDataSetMember @Study_id, @DataSet_id

UPDATE dbo.DATA_SET SET DATAPPLY_DT = GETDATE() WHERE DATASET_ID = @DataSet_id


