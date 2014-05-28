/*Created 1/8/3 BD 
  When an export is manually executed, the MRD table is not deleted.
  Therefore, we do not know if the table is still needed.
  This procedure will move any MRD tables older than 1 week from qp_prod
     to qp_report and then drop the original table from qp_prod.
*/

CREATE PROCEDURE SP_DBM_ClearOutMRDTables
AS

--determine the tables to be moved to qp_report
SELECT su.name usr, su.name + '.' + so.name tbl, id ident
INTO #MRD
FROM qp_prod.dbo.sysobjects so, qp_prod.dbo.sysusers su
WHERE so.name LIKE 'mrd%'
AND so.type = 'U'
AND so.uid = su.uid
AND so.crdate < DATEADD(MONTH,-1,GETDATE())

SET NOCOUNT ON

DECLARE @sql VARCHAR(8000), @tbl VARCHAR(42), @col VARCHAR(42), @tblid INT, @dt VARCHAR(50), @user VARCHAR(10)

--begin table loop
WHILE (SELECT count(*) FROM #mrd) > 0
BEGIN

--select the first table
SET @tbl = (SELECT top 1 tbl FROM #mrd)

--get the user
SELECT @user = usr FROM #mrd WHERE tbl = @tbl

--check to see if the user exists in the current database.  If it does not, I add it
IF NOT EXISTS (SELECT * FROM sysusers WHERE name = @user)
BEGIN
SET @sql = 'EXEC sp_grantdbaccess ' + @user
PRINT @sql
EXEC (@sql)

END

--delete the table from the work table
DELETE #mrd WHERE tbl = @tbl

SET NOCOUNT OFF

--select into qp_report
SET @sql = 'SELECT * INTO ' + @tbl + ' FROM qp_prod.' + @tbl

PRINT @sql
EXEC (@sql)

IF @@ERROR <> 0
  BEGIN
    DROP TABLE #columns
    DROP TABLE #mrd
    RETURN
  END

SET NOCOUNT ON

SET @sql = 'DROP TABLE qp_prod.' + @tbl
PRINT @sql
EXEC (@sql)

--end table loop
END

DROP TABLE #mrd


