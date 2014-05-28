CREATE PROCEDURE [dbo].[QCL_SelectMedicareRecalcHistoryBySampleDate]
@MedicareNumber VARCHAR(20), @SampleDate DATETIME
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT Top 1 MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume
	FROM [dbo].MedicareRecalc_History
	WHERE MedicareNumber = @MedicareNumber 
	  AND PropSampleCalcDate <= @SampleDate 
	ORDER BY PropSampleCalcDate DESC, DateCalculated DESC

	SET NOCOUNT OFF
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END


