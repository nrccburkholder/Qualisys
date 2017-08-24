/*
	RTP-4167 Add HH & OAS to Medicare Mgmt - Hookup HHCAHPS three Buttons - Rollback.sql
	Jing Fu, 8/23/2017

	Table:
		- Modify table SamplingUnlocked_Log

	SP:
		- Modify stored procedure QCL_InsertSamplingUnlockedLog
		- Modify stored procedure QCL_SelectAllMedicareGlobalReCalcDates
*/

Use [QP_Prod]
GO
PRINT 'Start rollback table changes'
GO

PRINT 'Rollback SamplingUnlocked_Log table changes'
GO
IF  EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SamplingUnlocked_Log' AND COLUMN_NAME = 'SurveyType_ID')
BEGIN
	ALTER TABLE [dbo].[SamplingUnlocked_Log] DROP CONSTRAINT [DF_SamplingUnlocked_Log_SurveyTypeID]
	ALTER TABLE [dbo].[SamplingUnlocked_Log]  DROP COLUMN [SurveyType_ID]
END
GO

PRINT 'End rollback table changes'
GO

PRINT 'Start rollback stored procedure changes'
GO


PRINT 'Rollback stored procedure QCL_InsertSamplingUnlockedLog'
GO
ALTER PROCEDURE [dbo].[QCL_InsertSamplingUnlockedLog]
@MedicareNumber Varchar(20),
@MemberID INT,
@DateUnlocked DATETIME
AS

SET NOCOUNT ON

INSERT INTO dbo.SamplingUnlocked_log (MedicareNumber, MemberID, DateUnlocked)
VALUES (@MedicareNumber, @MemberID, @DateUnlocked)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO

PRINT 'Rollback stored procedure QCL_SelectAllMedicareGlobalReCalcDates'
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareGlobalReCalcDates]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MedicareGlobalReCalcDate_id, MedicareGlobalRecalcDefault_id, ReCalcMonth
FROM [dbo].MedicareGlobalReCalcDates

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

PRINT 'End rollback stored procedure changes'
GO
