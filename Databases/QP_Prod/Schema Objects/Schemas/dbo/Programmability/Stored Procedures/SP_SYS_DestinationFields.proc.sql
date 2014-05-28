CREATE PROCEDURE SP_SYS_DestinationFields @Study_id INT, @CheckTables TINYINT=0    
AS    

--If @CheckTables=0, then the procedure is used for DTS definition.
--If @CheckTables=1, then the procedure is used to create or modify the _Load tables.
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
IF @CheckTables=0

SELECT Table_id, strTable_nm, Field_id, strField_nm, bitMatchField_flg,     
 CASE STRFIELDDATATYPE WHEN 'S' THEN 3 WHEN 'D' THEN 2 ELSE 1 END DataType_id,    
 ISNULL(intFieldLength,1) intLength, bitPII, bitAllowUS    
FROM MetaData_View    
WHERE Study_id=@Study_id    
AND strField_dsc NOT LIKE 'Key Field For%'  
AND strField_nm NOT LIKE '%NameStat%'  
AND strField_nm NOT LIKE '%NameErr%'  
AND strField_nm NOT LIKE '%PhonStat%'  
AND strField_nm NOT LIKE '%AddrStat%'  
AND strField_nm NOT LIKE '%AddrErr%'  
--AND strField_nm NOT LIKE '%NewRecordDate%'  

ELSE IF @CheckTables=1

SELECT Table_id, strTable_nm, Field_id, strField_nm, bitKeyField_flg,     
 CASE STRFIELDDATATYPE WHEN 'S' THEN 3 WHEN 'D' THEN 2 ELSE 1 END DataType_id,    
 ISNULL(intFieldLength,1) intLength, bitPII, bitAllowUS    
FROM MetaData_View    
WHERE Study_id=@Study_id    

ELSE

SELECT Table_id, strTable_nm, Field_id, strField_nm, bitKeyField_flg,bitMatchField_flg,
 CASE STRFIELDDATATYPE WHEN 'S' THEN 3 WHEN 'D' THEN 2 ELSE 1 END DataType_id,    
 ISNULL(intFieldLength,1) intLength, bitPII, bitAllowUS
FROM MetaData_View    
WHERE Study_id=@Study_id


