CREATE PROCEDURE [dbo].[QCL_SelectAllMedicareGlobalCalcDefaults]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareGlobalCalcDefault_id, RespRate, IneligibleRate, ProportionChangeThreshold, AnnualReturnTarget, ForceCensusSamplePercentage
FROM [dbo].MedicareGlobalCalcDefaults

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


