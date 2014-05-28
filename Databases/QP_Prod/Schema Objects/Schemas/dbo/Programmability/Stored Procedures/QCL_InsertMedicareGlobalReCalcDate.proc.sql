CREATE PROCEDURE [dbo].[QCL_InsertMedicareGlobalReCalcDate]
@MedicareGlobalRecalcDefault_id INT,
@ReCalcMonth INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].MedicareGlobalReCalcDates (MedicareGlobalRecalcDefault_id, ReCalcMonth)
VALUES (@MedicareGlobalRecalcDefault_id, @ReCalcMonth)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


