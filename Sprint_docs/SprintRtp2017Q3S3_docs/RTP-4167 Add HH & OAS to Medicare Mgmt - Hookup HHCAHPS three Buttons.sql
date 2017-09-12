/*
	RTP-4167 Add HH & OAS to Medicare Mgmt - Hookup HHCAHPS three Buttons.sql
	Jing Fu, 8/23/2017
	Table:
		- Modify table SamplingUnlocked_Log

	SP:
		- Modify stored procedure QCL_InsertSamplingUnlockedLog
		- Modify stored procedure QCL_SelectAllMedicareGlobalReCalcDates
		- Create stored procedure QCL_GetLatestMedicareRecalcSurveyTypeHistoryByMedicareNumber
		- Create stored procedure QCL_GetLatestMedicareRecalcSurveyTypeHistoryByMedicareNumber
		- Create stored procedure QCL_SelectAllMedicareRecalcSurveyType_Histories
*/

Use [QP_Prod]
GO

PRINT 'Start table changes'
GO
PRINT 'Modify SamplingUnlocked_Log table'
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SamplingUnlocked_Log' AND COLUMN_NAME = 'SurveyType_ID')
	ALTER TABLE [dbo].[SamplingUnlocked_Log] 
	ADD [SurveyType_ID] [INT]
	CONSTRAINT [DF_SamplingUnlocked_Log_SurveyTypeID]  DEFAULT (2) WITH VALUES NOT NULL
GO

PRINT 'End table changes'
GO


PRINT 'Start stored procedure changes'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

PRINT 'Modify stored procedure QCL_InsertSamplingUnlockedLog'
GO
ALTER PROCEDURE [dbo].[QCL_InsertSamplingUnlockedLog]
@MedicareNumber		VARCHAR(20),
@MemberID					INT,
@DateUnlocked			DATETIME,
@SurveyType_ID			INT = 2
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO dbo.SamplingUnlocked_log (MedicareNumber, MemberID, DateUnlocked, SurveyType_ID)
	VALUES (@MedicareNumber, @MemberID, @DateUnlocked, @SurveyType_ID)

	SELECT SCOPE_IDENTITY()

	SET NOCOUNT OFF
END
GO

--PRINT 'Modify stored procedure QCL_SelectAllMedicareGlobalReCalcDates'
--GO
--ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareGlobalReCalcDates]
--AS
--BEGIN
--	SET NOCOUNT ON
--	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--	SELECT MedicareGlobalReCalcDate_id, MedicareGlobalRecalcDefault_id, ReCalcMonth
--	FROM [dbo].MedicareGlobalReCalcDates
--	WHERE MedicareGlobalRecalcDefault_id = 
--		(SELECT MIN(MedicareGlobalRecalcDefault_ID) FROM [dbo].MedicareGlobalReCalcDates)

--	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--	SET NOCOUNT OFF
--END
--GO


PRINT ' Create stored procedure QCL_GetLatestMedicareRecalcSurveyTypeHistoryByMedicareNumber'
GO
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_GetLatestMedicareRecalcSurveyTypeHistoryByMedicareNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_GetLatestMedicareRecalcSurveyTypeHistoryByMedicareNumber]
GO
CREATE PROCEDURE [dbo].[QCL_GetLatestMedicareRecalcSurveyTypeHistoryByMedicareNumber]
@MedicareNumber		VARCHAR(20), 
@DateFilter					DATETIME = NULL
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @name VARCHAR(200)
	SELECT @name = MedicareName FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber

	SELECT Top 1 MedicareReCalcLog_ID, SurveyType_ID AS SurveyTypeID, MedicareNumber, @name AS MedicareName, MedicarePropCalcType_ID, 
	MedicarePropDataType_ID, EstRespRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, 
	ProportionChangeThreshold, Member_ID, DateCalculated, HistoricRespRate, HistoricAnnualVolume, ForcedCalculation, PropSampleCalcDate, 
	SwitchFromRateOverrideDate, 	SamplingRateOverride
	FROM MedicareRecalcSurveyType_History
	WHERE MedicareNumber = @MedicareNumber 
	AND ((@DateFilter IS NULL ) OR (DateCalculated <= @DateFilter))
	ORDER BY DateCalculated DESC

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF

END
GO

 PRINT 'Create stored procedure QCL_SelectMedicareRecalcSurveyTypeHistoryBySampleDate'
 GO
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectMedicareRecalcSurveyTypeHistoryBySampleDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectMedicareRecalcSurveyTypeHistoryBySampleDate]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMedicareRecalcSurveyTypeHistoryBySampleDate]
@MedicareNumber VARCHAR(20), 
@SampleDate			DATETIME,
@SurveyTypeID		int 
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @name VARCHAR(200)
	SELECT @name=MedicareName FROM dbo.MedicareLookup WHERE MedicareNumber=@MedicareNumber

	SELECT Top 1 MedicareReCalcLog_ID, SurveyType_ID AS SurveyTypeID, MedicareNumber, @name AS MedicareName, MedicarePropCalcType_ID, 
	MedicarePropDataType_ID, EstRespRate, EstAnnualVolume, SwitchToCalcDate, AnnualReturnTarget, ProportionCalcPct, SamplingLocked, 
	ProportionChangeThreshold, Member_ID, DateCalculated, HistoricRespRate, HistoricAnnualVolume, ForcedCalculation, PropSampleCalcDate, 
	SwitchFromRateOverrideDate, SamplingRateOverride
	FROM MedicareRecalcSurveyType_History 
	WHERE MedicareNumber = @MedicareNumber
		AND PropSampleCalcDate <= @SampleDate
		AND SurveyType_ID = @SurveyTypeID
	ORDER BY PropSampleCalcDate DESC, DateCalculated DESC

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF
END
GO

 PRINT 'Create stored procedure QCL_SelectAllMedicareRecalcSurveyType_Histories'
 GO
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectAllMedicareRecalcSurveyType_Histories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectAllMedicareRecalcSurveyType_Histories]
GO
 CREATE PROCEDURE [dbo].[QCL_SelectAllMedicareRecalcSurveyType_Histories]
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT History.MedicareReCalcLog_ID, History.SurveyType_ID AS SurveyTypeID, History.MedicareNumber, MedicareLookup.MedicareName, History.MedicarePropCalcType_ID, 
	History.MedicarePropDataType_ID, History.EstRespRate, History.EstAnnualVolume, History.SwitchToCalcDate, History.AnnualReturnTarget, History.ProportionCalcPct, History.SamplingLocked, 
	History.ProportionChangeThreshold, History.Member_ID, History.DateCalculated, History.HistoricRespRate, History.HistoricAnnualVolume, History.ForcedCalculation, History.PropSampleCalcDate, 
	History.SwitchFromRateOverrideDate, History.SamplingRateOverride
	FROM MedicareRecalcSurveyType_History AS History 
	INNER JOIN MedicareLookup ON History.MedicareNumber = MedicareLookup.MedicareNumber

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF
END 
GO

PRINT 'End stored procedure changes'
GO

