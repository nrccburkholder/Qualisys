CREATE PROCEDURE [dbo].[QCL_DeleteMedicareGlobalReCalcDate]
@MedicareGlobalReCalcDate_id INT
AS

SET NOCOUNT ON

DELETE [dbo].MedicareGlobalReCalcDates
WHERE MedicareGlobalReCalcDate_id = @MedicareGlobalReCalcDate_id

SET NOCOUNT OFF


