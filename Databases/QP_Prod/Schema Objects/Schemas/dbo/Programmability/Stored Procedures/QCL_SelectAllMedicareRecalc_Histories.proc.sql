CREATE PROCEDURE [dbo].[QCL_SelectAllMedicareRecalc_Histories]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, 
		EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, 
		SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, 
		ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume
FROM [dbo].MedicareRecalc_History

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


