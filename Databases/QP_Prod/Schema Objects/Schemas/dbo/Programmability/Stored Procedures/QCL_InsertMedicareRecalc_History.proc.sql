CREATE PROCEDURE [dbo].[QCL_InsertMedicareRecalc_History]
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

INSERT INTO [dbo].MedicareRecalc_History (MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume)
VALUES (@MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstRespRate, @EstIneligibleRate, @EstAnnualVolume, @SwitchToCalcDate, @AnnualReturnTarget, @ProportionCalcPct, @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @Member_ID, @DateCalculated, @HistoricRespRate, @ForcedCalculation, @PropSampleCalcDate, @MedicarePropDataType_ID, @HistoricAnnualVolume)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


