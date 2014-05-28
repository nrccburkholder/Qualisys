CREATE PROCEDURE QP_Rep_DataStructure02    
 @Associate VARCHAR(50),    
 @Client VARCHAR(50),    
 @Study VARCHAR(50)    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
DECLARE @intStudy_id INT    
SELECT @intStudy_id=s.Study_id    
FROM Study s, Client c    
WHERE c.strClient_nm=@Client    
  AND s.strStudy_nm=@Study    
  AND c.Client_id=s.Client_id    


-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (    
	SELECT 'Study Data Structure' AS SheetNameDummy, STRTABLE_NM [Table] , STRFIELD_NM [MetaField], BITUSESADDRESS [Addr Cleaning], STRFIELDDATATYPE [Field Type], INTFIELDLENGTH [MetaField Length], BITKEYFIELD_FLG [Key Field], BITMATCHFIELD_FLG [Match Field]
,
	 BITPOSTEDFIELD_FLG Posted    
	FROM MetaData_view2     
	WHERE Study_id = @intStudy_id
		)
	
	SELECT 'Study Data Structure' AS SheetNameDummy, STRTABLE_NM [Table] , STRFIELD_NM [MetaField], BITUSESADDRESS [Addr Cleaning], STRFIELDDATATYPE [Field Type], INTFIELDLENGTH [MetaField Length], BITKEYFIELD_FLG [Key Field], BITMATCHFIELD_FLG [Match Field]
,
	 BITPOSTEDFIELD_FLG Posted    
	FROM MetaData_view2     
	WHERE Study_id = @intStudy_id    
	ORDER BY table_id, strField_nm

ELSE
	SELECT 'Study Data Structure' AS SheetNameDummy, '' [Table], '' [MetaField], '' [Addr Cleaning], '' [Field Type], '' [MetaField Length], '' [Key Field], '' [Match Field], '' Posted    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


