CREATE PROCEDURE [dbo].[QCL_InsertMedicareGlobalCalcDefault]
@RespRate DECIMAL (8,4),
@IneligibleRate DECIMAL  (8,4),
@ProportionChangeThreshold DECIMAL  (8,4),
@AnnualReturnTarget INT,
@ForceCensusSamplePercentage DECIMAL (8,4)
AS

SET NOCOUNT ON

INSERT INTO [dbo].MedicareGlobalCalcDefaults (RespRate, IneligibleRate, ProportionChangeThreshold, AnnualReturnTarget, ForceCensusSamplePercentage)
VALUES (@RespRate, @IneligibleRate, @ProportionChangeThreshold, @AnnualReturnTarget, @ForceCensusSamplePercentage)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


