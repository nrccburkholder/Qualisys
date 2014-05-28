CREATE PROCEDURE SP_SYS_ClearLoadTables @Study_id INT
AS

DECLARE @sql VARCHAR(8000)
DECLARE @tbl TABLE (Table_Name VARCHAR(100))

INSERT INTO @tbl
SELECT 'S'+LTRIM(STR(@Study_id))+'.'+Table_Name
FROM Information_Schema.Tables
WHERE Table_Schema='S'+LTRIM(STR(@Study_id))
AND Table_Name LIKE '%[_]Load'
AND Table_Type='Base Table'

SELECT @sql=''
SELECT @sql=@sql+' TRUNCATE TABLE '+Table_Name
FROM @tbl

EXEC (@sql)


