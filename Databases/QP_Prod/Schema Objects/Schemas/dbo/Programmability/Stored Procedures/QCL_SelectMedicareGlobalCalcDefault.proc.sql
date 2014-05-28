CREATE PROCEDURE [dbo].[QCL_SelectMedicareGlobalCalcDefault]
@MedicareGlobalCalcDefault_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareGlobalCalcDefault_id, RespRate, IneligibleRate, ProportionChangeThreshold, AnnualReturnTarget, ForceCensusSamplePercentage
FROM [dbo].MedicareGlobalCalcDefaults
WHERE MedicareGlobalCalcDefault_id = @MedicareGlobalCalcDefault_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


