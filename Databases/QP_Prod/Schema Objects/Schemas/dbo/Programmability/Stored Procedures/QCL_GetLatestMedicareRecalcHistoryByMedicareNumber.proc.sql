CREATE PROCEDURE [dbo].[QCL_GetLatestMedicareRecalcHistoryByMedicareNumber]
@MedicareNumber VARCHAR(20), @DateFilter DATETIME = null
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

if @DateFilter is null
	begin
--Get the most recent Calc History based on the Medicare Number
		SELECT Top 1 MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume
		FROM [dbo].MedicareRecalc_History
		WHERE MedicareNumber = @MedicareNumber
		ORDER BY DateCalculated DESC
	end
else
	begin
		SELECT Top 1 MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume
		FROM [dbo].MedicareRecalc_History
		WHERE MedicareNumber = @MedicareNumber and DateCalculated <= @DateFilter 
		ORDER BY DateCalculated DESC
	end
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


