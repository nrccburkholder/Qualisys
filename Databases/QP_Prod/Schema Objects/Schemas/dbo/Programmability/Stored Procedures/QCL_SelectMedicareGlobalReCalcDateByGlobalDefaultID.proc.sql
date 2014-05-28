CREATE PROCEDURE [dbo].[QCL_SelectMedicareGlobalReCalcDateByGlobalDefaultID]
@MedicareGlobalRecalcDefault_id int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareGlobalReCalcDate_id, MedicareGlobalRecalcDefault_id, ReCalcMonth
FROM [dbo].MedicareGlobalReCalcDates
Where MedicareGlobalRecalcDefault_id = @MedicareGlobalRecalcDefault_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


