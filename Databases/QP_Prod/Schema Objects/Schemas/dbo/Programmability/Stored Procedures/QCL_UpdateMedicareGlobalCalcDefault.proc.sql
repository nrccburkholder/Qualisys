CREATE PROCEDURE [dbo].[QCL_UpdateMedicareGlobalCalcDefault]
@MedicareGlobalCalcDefault_id INT,
@RespRate DECIMAL (8,4),
@IneligibleRate DECIMAL (8,4),
@ProportionChangeThreshold DECIMAL (8,4),
@AnnualReturnTarget INT,
@ForceCensusSamplePercentage DECIMAL (8,4)
AS

SET NOCOUNT ON

UPDATE [dbo].MedicareGlobalCalcDefaults SET
	RespRate = @RespRate,
	IneligibleRate = @IneligibleRate,
	ProportionChangeThreshold = @ProportionChangeThreshold,
	AnnualReturnTarget = @AnnualReturnTarget,
	ForceCensusSamplePercentage = @ForceCensusSamplePercentage
WHERE MedicareGlobalCalcDefault_id = @MedicareGlobalCalcDefault_id

SET NOCOUNT OFF


