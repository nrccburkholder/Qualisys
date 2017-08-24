/*
	RTP-4167 Add HH & OAS to Medicare Mgmt - Hookup HHCAHPS three Buttons.sql
	Jing Fu, 8/23/2017
	Table:
		- Modify table SamplingUnlocked_Log

	SP:
		- Modify stored procedure QCL_InsertSamplingUnlockedLog
		- Modify stored procedure QCL_SelectAllMedicareGlobalReCalcDates
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

PRINT 'Modify stored procedure QCL_SelectAllMedicareGlobalReCalcDates'
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareGlobalReCalcDates]
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT MedicareGlobalReCalcDate_id, MedicareGlobalRecalcDefault_id, ReCalcMonth
	FROM [dbo].MedicareGlobalReCalcDates
	WHERE MedicareGlobalRecalcDefault_id = 
		(SELECT MIN(MedicareGlobalRecalcDefault_ID) FROM [dbo].MedicareGlobalReCalcDates)

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF
END
GO

PRINT 'End stored procedure changes'
GO
