CREATE PROCEDURE [dbo].[QCL_UpdateMedicareRecalc_History]
@MedicareReCalcLog_ID INT,
@MedicareNumber VARCHAR(20),
@MedicareName VARCHAR(200),
@MedicarePropCalcType_ID INT,
@EstRespRate decimal(8,4),
@EstIneligibleRate decimal(8,4),
@EstAnnualVolume INT,
@SwitchToCalcDate DATETIME,
@AnnualReturnTarget INT,
@ProportionCalcPct decimal(8,4),
@SamplingLocked TinyInt,
@ProportionChangeThreshold decimal(8,4),
@CensusForced TinyInt,
@Member_ID INT,
@DateCalculated DATETIME,
@HistoricRespRate decimal(8,4),
@ForcedCalculation TinyInt,
@PropSampleCalcDate DATETIME,
@MedicarePropDataType_ID INT,
@HistoricAnnualVolume INT
AS

SET NOCOUNT ON

UPDATE [dbo].MedicareRecalc_History SET
	MedicareNumber = @MedicareNumber,
	MedicareName = @MedicareName,
	MedicarePropCalcType_ID = @MedicarePropCalcType_ID,
	EstRespRate = @EstRespRate,
	EstIneligibleRate = @EstIneligibleRate,
	EstAnnualVolume = @EstAnnualVolume,
	SwitchToCalcDate = @SwitchToCalcDate,
	AnnualReturnTarget = @AnnualReturnTarget,
	ProportionCalcPct = @ProportionCalcPct,
	SamplingLocked = @SamplingLocked,
	ProportionChangeThreshold = @ProportionChangeThreshold,
	CensusForced = @CensusForced,
	Member_ID = @Member_ID,
	DateCalculated = @DateCalculated,
	HistoricRespRate = @HistoricRespRate,
	ForcedCalculation = @ForcedCalculation,
	PropSampleCalcDate= @PropSampleCalcDate,
	MedicarePropDataType_ID = @MedicarePropDataType_ID,
	HistoricAnnualVolume = @HistoricAnnualVolume
WHERE MedicareReCalcLog_ID = @MedicareReCalcLog_ID

SET NOCOUNT OFF


