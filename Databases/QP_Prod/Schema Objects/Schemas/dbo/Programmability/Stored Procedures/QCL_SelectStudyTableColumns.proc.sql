CREATE PROCEDURE [dbo].[QCL_SelectStudyTableColumns]  
    @StudyId INT,  
    @TableId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
IF @TableId=0  
BEGIN  
    SELECT NULL AS Table_id, NULL AS Field_id, strTable_nm + strField_nm AS strField_nm, 
           strFieldDataType, bitKeyField_FLG, strField_DSC, intFieldLength, bitUserField_FLG, 
           bitMatchField_FLG, bitPostedField_FLG
    FROM MetaData_View
    WHERE Study_id = @StudyId
    ORDER BY strTable_nm + strField_nm
END  
ELSE  
BEGIN  
    SELECT Table_id, Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
           intFieldLength, bitUserField_FLG, bitMatchField_FLG, bitPostedField_FLG
    FROM MetaData_View  
    WHERE Study_id = @StudyId  
      AND Table_id = @TableId  
    ORDER BY bitKeyField_FLG DESC, strField_nm  
END  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


