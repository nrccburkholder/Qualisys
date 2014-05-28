CREATE PROCEDURE SP_SYS_GetIdentityValue 
	@Study_id INT
AS

SET NOCOUNT ON

DECLARE @Table_Name VARCHAR(100)

CREATE TABLE #IdentValues (Table_Name VARCHAR(100), IdentValue INT)

INSERT INTO #IdentValues (Table_Name)
SELECT 'S'+LTRIM(STR(@Study_id))+'.'+Table_Name
FROM Information_Schema.Tables
WHERE Table_Schema='S'+LTRIM(STR(@Study_id))
AND Table_Name LIKE '%[_]Load'
AND Table_Name NOT LIKE 'Big%'

DECLARE @tbls TABLE (Tbl VARCHAR(100))

INSERT INTO @tbls SELECT DISTINCT Table_Name FROM #IdentValues

SELECT TOP 1 @Table_Name=Tbl FROM @tbls
WHILE @@ROWCOUNT>0
BEGIN

	DELETE @tbls WHERE Tbl=@Table_Name
	
	EXEC ('UPDATE #IdentValues SET IdentValue=IDENT_CURRENT('''+@Table_Name+''') WHERE Table_Name='''+@Table_Name+'''')
	
	SELECT TOP 1 @Table_Name=Tbl FROM @tbls

END

SELECT * FROM #IdentValues

DROP TABLE #IdentValues


