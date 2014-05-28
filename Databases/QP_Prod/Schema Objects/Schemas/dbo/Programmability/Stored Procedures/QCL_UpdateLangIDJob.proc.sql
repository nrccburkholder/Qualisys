CREATE PROCEDURE QCL_UpdateLangIDJob 
AS

DECLARE @sql VARCHAR(8000), @Study VARCHAR(10), @Pop VARCHAR(20), @LangID VARCHAR(10), @LCID INT        
        
SELECT TOP 1 @LCID=LangIDChange_id, @Study=LTRIM(STR(Study_id)), @Pop=LTRIM(STR(Pop_id)), @LangID=LTRIM(STR(LangID))
FROM tbl_QCL_LangIDChange
ORDER BY LangIDChange_id
WHILE @@ROWCOUNT>0
BEGIN -- Loop 1

--Now to update the langid in the population table
SELECT @sql='UPDATE S'+@Study+'.Population         
SET LangID='+@LangID+'
WHERE Pop_id='+@Pop
EXEC (@sql)        
      
DELETE tbl_QCL_LangIDChange WHERE LangIDChange_id=@LCID

SELECT TOP 1 @LCID=LangIDChange_id, @Study=LTRIM(STR(Study_id)), @Pop=LTRIM(STR(Pop_id)), @LangID=LTRIM(STR(LangID))
FROM tbl_QCL_LangIDChange
ORDER BY LangIDChange_id

END -- Loop 1


