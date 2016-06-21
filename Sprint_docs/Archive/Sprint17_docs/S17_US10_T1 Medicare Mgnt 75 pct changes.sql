/*
CJB 1/26/2015

Medicare Mgnt. 75%	
When a calculated proportion for a CCN changes from one quarter to the next from a value >75% to a value <75%, 
our system SHOULD take that CCN off census sampling. Currently this does NOT happen, as the CCN continues 
census sampling, even if the proportion is <75%. (As a reminder, 75% is the threshold for census sampling.)	

for the sake of more accurately performing HCAHPS proportional sampling each quarter. This enhancement is 
needed for the Medicare Management tab/section within Configuration Manager. 

10.1	We designed this in Sprint 15 - Implement the design

*/

begin tran

IF NOT EXISTS (
            SELECT 1
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'MedicareRecalc_History'
              AND COLUMN_NAME = 'UserCensusForced'
)
ALTER TABLE MedicareRecalc_History 
ADD UserCensusForced int NULL
DEFAULT null

GO

ALTER PROCEDURE [dbo].[QCL_GetLatestMedicareRecalcHistoryByMedicareNumber]
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

GO

ALTER PROCEDURE [dbo].[QCL_InsertMedicareRecalc_History]
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
@HistoricAnnualVolume INT, 
@UserCensusForced INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].MedicareRecalc_History (MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume, UserCensusForced)
VALUES (@MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstRespRate, @EstIneligibleRate, @EstAnnualVolume, @SwitchToCalcDate, @AnnualReturnTarget, @ProportionCalcPct, @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @Member_ID, @DateCalculated, @HistoricRespRate, @ForcedCalculation, @PropSampleCalcDate, @MedicarePropDataType_ID, @HistoricAnnualVolume, @UserCensusForced)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF

GO

ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareRecalc_Histories]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, 
		EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, 
		SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, 
		ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume, UserCensusForced
FROM [dbo].MedicareRecalc_History

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

ALTER PROCEDURE [dbo].[QCL_SelectMedicareRecalc_History]
@MedicareReCalcLog_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume, UserCensusForced
FROM [dbo].MedicareRecalc_History
WHERE MedicareReCalcLog_ID = @MedicareReCalcLog_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

ALTER PROCEDURE [dbo].[QCL_SelectMedicareRecalcHistoryBySampleDate]
@MedicareNumber VARCHAR(20), @SampleDate DATETIME
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT Top 1 MedicareReCalcLog_ID, MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstRespRate, EstIneligibleRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, CensusForced, Member_ID, DateCalculated, HistoricRespRate, ForcedCalculation, PropSampleCalcDate, MedicarePropDataType_ID, HistoricAnnualVolume, UserCensusForced
	FROM [dbo].MedicareRecalc_History
	WHERE MedicareNumber = @MedicareNumber 
	  AND PropSampleCalcDate <= @SampleDate 
	ORDER BY PropSampleCalcDate DESC, DateCalculated DESC

	SET NOCOUNT OFF
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

GO

ALTER PROCEDURE [dbo].[QCL_UpdateMedicareRecalc_History]
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
@HistoricAnnualVolume INT, 
@UserCensusForced INT
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
	HistoricAnnualVolume = @HistoricAnnualVolume, 
	UserCensusForced = @UserCensusForced
WHERE MedicareReCalcLog_ID = @MedicareReCalcLog_ID

SET NOCOUNT OFF

GO

commit tran
