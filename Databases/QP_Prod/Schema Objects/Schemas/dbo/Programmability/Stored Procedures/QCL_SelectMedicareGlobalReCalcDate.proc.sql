CREATE PROCEDURE [dbo].[QCL_SelectMedicareGlobalReCalcDate]
@MedicareGlobalReCalcDate_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareGlobalReCalcDate_id, MedicareGlobalRecalcDefault_id, ReCalcMonth
FROM [dbo].MedicareGlobalReCalcDates
WHERE MedicareGlobalReCalcDate_id = @MedicareGlobalReCalcDate_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


