CREATE PROCEDURE SP_SYS_MonitorDBSize
AS

/*
EXEC sp_MSforeachdb @command1="insert into MonitorDBSize select GETDATE(),'?',(sum(convert(bigint,used))*8)/1024 from ?..sysindexes where indid in (0,1,255)"  
*/

SELECT name INTO #dbs FROM master.dbo.sysdatabases

DECLARE @sql VARCHAR(8000), @db VARCHAR(100)

SELECT TOP 1 @db=name FROM #dbs
WHILE @@ROWCOUNT>0
BEGIN

SELECT @sql='USE '+@db+' DECLARE @s VARCHAR(2000) SELECT @s=''CREATE TABLE #temp (a INT, b INT, c INT, usedextents INT, d VARCHAR(50), e VARCHAR(1000)) 
INSERT INTO #temp EXEC (''''DBCC showfilestats'''') 
INSERT INTO QP_Prod.dbo.MonitorDBSize 
SELECT GETDATE(), '''''+@db+''''',SUM(usedextents*64/1024),LEFT(e,1) FROM #temp GROUP BY LEFT(e,1)
DROP TABLE #temp'' EXEC (@s)'

EXEC (@sql)

DELETE #dbs WHERE name=@db

SELECT TOP 1 @db=name FROM #dbs

END

DROP TABLE #dbs


