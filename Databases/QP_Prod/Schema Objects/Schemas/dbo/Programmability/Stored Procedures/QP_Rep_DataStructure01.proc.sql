CREATE PROCEDURE QP_Rep_DataStructure01    
 @Associate VARCHAR(50),    
 @Client VARCHAR(50),    
 @Study VARCHAR(50)    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

DECLARE @intStudy_id INT    
SELECT @intStudy_id=s.study_id    
FROM study s, client c    
WHERE c.strclient_nm=@Client    
  AND s.strstudy_nm=@Study    
  AND c.client_id=s.client_id    
    

-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (SELECT 'Study Data Structure' AS SheetNameDummy, STRTABLE_NM [Master Table], STRFIELD_NM [Master Field], LOOKUPTABLENAME [Link Table], LOOKUPFIELDNAME [Link Field] 
		FROM MetaLookup_view WHERE study_id = @intStudy_id
		)

		SELECT 'Study Data Structure' AS SheetNameDummy, STRTABLE_NM [Master Table], STRFIELD_NM [Master Field], LOOKUPTABLENAME [Link Table], LOOKUPFIELDNAME [Link Field] 
		FROM MetaLookup_view WHERE study_id = @intStudy_id ORDER BY 1,3,2	
ELSE 
	SELECT 'Study Data Structure' AS SheetNameDummy, '' [Master Table], '' [Master Field], '' [Link Table], '' [Link Field] 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


