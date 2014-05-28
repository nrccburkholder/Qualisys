CREATE PROCEDURE [dbo].[QCL_DeleteMedicareGlobalCalcDefault]
@MedicareGlobalCalcDefault_id INT
AS

SET NOCOUNT ON

DELETE [dbo].MedicareGlobalCalcDefaults
WHERE MedicareGlobalCalcDefault_id = @MedicareGlobalCalcDefault_id

SET NOCOUNT OFF


