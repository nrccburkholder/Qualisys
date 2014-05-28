CREATE PROC SP_SYS_MetaTable @Study_id INT
AS

SELECT Table_id, strTable_nm
FROM MetaTable
WHERE Study_id=@Study_id


