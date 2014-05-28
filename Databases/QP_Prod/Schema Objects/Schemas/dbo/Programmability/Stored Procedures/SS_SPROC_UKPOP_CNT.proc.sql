CREATE PROCEDURE SS_SPROC_UKPOP_CNT
AS

TRUNCATE TABLE SS_UKPOP_CNT

--DROP TABLE SS_TEMP
SELECT /*top 25*/ STUDY_ID, TABLE_ID, 0 AS intDone, t2.*
INTO SS_TEMP
FROM METATABLE T1 INNER JOIN INFORMATION_SCHEMA.TABLES t2
	ON 'S' + LTRIM(STR(STUDY_ID)) = T2.table_schema 
WHERE STRTABLE_NM = 'POPULATION' AND table_name = 'unikeys' order by study_id

/*------------------------------*/
DECLARE @study INT, @SQL NVARCHAR(4000)

WHILE (SELECT COUNT(*) FROM SS_TEMP WHERE intDone = 0) > 0
BEGIN
	SET @study = (SELECT TOP 1 study_id FROM SS_TEMP WHERE intDone = 0)
	SET @SQL = 
		'INSERT INTO ss_ukpop_cnt (sampleset_id, sampleunit_id, ukpop_cnt) ' + CHAR(10) +
		'SELECT sampleset_id, sampleunit_id, COUNT(*) AS ukpop_cnt FROM s' + ltrim(str(@study)) + '.UNIKEYS T1 INNER JOIN ss_TEMP T2 ON T1.TABLE_ID = T2.TABLE_ID GROUP BY SAMPLESET_ID, SAMPLEUNIT_ID'
			
	--PRINT @SQL
	EXEC sp_executesql @sql

	UPDATE SS_temp SET intDone = 1 WHERE study_id = @study
	SET @study = (SELECT TOP 1 study_id FROM SS_TEMP WHERE intDone = 0)
END
/*------------------------------*/


