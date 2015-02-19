CREATE PROCEDURE [dbo].[QCL_GetLatestMedicareRecalcHistoryByMedicareNumber]
@MedicareNumber VARCHAR(20), @DateFilter DATETIME = null, @userCensusForced BIT = 0
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		SELECT Top 1 MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, 
Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume, UserCensusForced
		FROM [dbo].MedicareRecalc_History
		WHERE MedicareNumber = @MedicareNumber 
		and ((@DateFilter is null) or (DateCalculated <= @DateFilter))
		and ((@userCensusForced = 0) or (UserCensusForced > 0))
		ORDER BY DateCalculated DESC

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
