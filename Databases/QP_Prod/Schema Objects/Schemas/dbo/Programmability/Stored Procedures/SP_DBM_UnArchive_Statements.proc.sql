--CREATED 10/25/2 BD Builds the insert statements to move the records from QP_Archive back to QP_Prod
CREATE PROCEDURE SP_DBM_UnArchive_Statements
AS
SELECT *
INTO #tables
FROM RestoreTables

SET NOCOUNT ON

PRINT 'BEGIN TRAN'

DECLARE @sql VARCHAR(8000), @table VARCHAR(42), @ident BIT, @list VARCHAR(2000), @column VARCHAR(42)

CREATE TABLE #columns (columnname VARCHAR(42))

WHILE (SELECT COUNT(*) FROM #tables) > 0
BEGIN --1

TRUNCATE TABLE #columns

SET @sql = ''

SET @table = (SELECT TOP 1 strtable_nm FROM #tables ORDER BY populateorder)

SET @ident = (SELECT identinsert FROM #tables WHERE strtable_nm = @table)

DELETE #tables WHERE strtable_nm = @table

IF @ident = 1
BEGIN --2

SET @sql = 'SET identity_insert dbo.' + @table + ' ON' + CHAR(10) 

END --2

INSERT INTO #columns
SELECT sc.name 
FROM qp_archive.dbo.sysobjects so, qp_archive.dbo.syscolumns sc
WHERE so.name = @table
AND so.id = sc.id
AND sc.xtype <> 189

IF @table = 'scheduledmailing'
DELETE #columns WHERE columnname = 'sentmail_id'

SET @list = ''

WHILE (SELECT COUNT(*) FROM #columns) > 0
BEGIN --3

SET @column = (SELECT TOP 1 columnname FROM #columns)

DELETE #columns WHERE columnname = @column

IF @list = ''
SET @list = @list + @column
ELSE
SET @list = @list + ',' + @column

END --3

SET @sql = @sql + 'INSERT INTO dbo.' + @table + CHAR(10) +
' (' + @list + ')' + CHAR(10) +
' SELECT ' + @list + CHAR(10) +
' FROM qp_archive.dbo.' + @table + CHAR(10) +
'  IF @@ERROR <> 0 ' + CHAR(10) +  
'   BEGIN' + CHAR(10) +
'    ROLLBACK TRANSACTION' + CHAR(10) +
'    RETURN' + CHAR(10) +
'   END' + CHAR(10) 

IF @ident = 1
BEGIN --4

SET @sql = @sql + 'SET identity_insert dbo.' + @table + ' OFF' + CHAR(10) 

END --4

IF @table = 'sentmailing'
BEGIN --5

SET @sql = @sql + '  update dbo.scheduledmailing ' + CHAR(10) +
'  SET sentmail_id = sm.sentmail_id ' + CHAR(10) +
'  FROM dbo.sentmailing sm, qp_archive.dbo.scheduledmailing qascm ' + CHAR(10) +
'  WHERE sm.scheduledmailing_id = dbo.scheduledmailing.scheduledmailing_id ' + CHAR(10) +
'  AND qascm.scheduledmailing_id = dbo.scheduledmailing.scheduledmailing_id ' + CHAR(10) +
'  IF @@ERROR <> 0 ' + CHAR(10) +
'  BEGIN ' + CHAR(10) +
'   ROLLBACK TRANSACTION ' + CHAR(10) +
'   RETURN ' + CHAR(10) +
'  END'

END --5

PRINT @sql

END --1


