CREATE PROCEDURE [dbo].[QCL_UpdateMedicareGlobalReCalcDate]
@MedicareGlobalReCalcDate_id INT,
@MedicareGlobalRecalcDefault_id INT,
@ReCalcMonth INT
AS

SET NOCOUNT ON

UPDATE [dbo].MedicareGlobalReCalcDates SET
	MedicareGlobalRecalcDefault_id = @MedicareGlobalRecalcDefault_id,
	ReCalcMonth = @ReCalcMonth
WHERE MedicareGlobalReCalcDate_id = @MedicareGlobalReCalcDate_id

SET NOCOUNT OFF


