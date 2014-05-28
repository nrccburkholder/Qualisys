CREATE PROCEDURE QCL_SelectStandardMethodology
 @StandardMethodologyId INT  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom  
FROM StandardMethodology sm
WHERE sm.StandardMethodologyId=@StandardMethodologyId
  
SET NOCOUNT OFF  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


