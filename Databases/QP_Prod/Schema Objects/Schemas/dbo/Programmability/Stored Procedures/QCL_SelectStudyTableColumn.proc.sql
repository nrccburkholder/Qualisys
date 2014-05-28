CREATE PROCEDURE [dbo].[QCL_SelectStudyTableColumn]  
    @TableId INT,  
    @FieldId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT Table_id, Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
      intFieldLength, bitUserField_FLG, bitMatchField_FLG, bitPostedField_FLG
FROM MetaData_View  
WHERE Table_id = @TableId  
  AND Field_id = @FieldId
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


