CREATE PROCEDURE [dbo].[QCL_DeleteMedicareGlobalRecalcDateByMedicareGlobalCalcDefaultID]  
@MedicareGlobalRecalcDefault_ID INT  
AS  
  
SET NOCOUNT ON  
  
DELETE [dbo].MedicareGlobalReCalcDates  
WHERE MedicareGlobalRecalcDefault_ID = @MedicareGlobalRecalcDefault_ID  
  
SET NOCOUNT OFF


