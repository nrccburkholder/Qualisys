/*
	RTP-4164 Add HH & OAS to Medicare Mgmt - Show HHCAHPS data - Rollback.sql
	Jing Fu, 8/10/2017
	Changes summary:
	Table:
		- Add new table MedicareLookupSurveyType
		- Move Move OAS CAHPS data from MedicareLookup to MedicareLookupSurveyType
		- Modify MedicareLookup table
		- Modify MedicareGlobalCalcDefaults table
		- Modify MedicareProCalcTypes table
		- Modify MedicarePropDataType table
		- Add new table MedicareRecalcSurveyType_History 
	SP:
		- Modify stored procedure QCL_SelectMedicareNumbers
		- Modify stored procedure QCL_SelectAllMedicareNumbers
		- Modify stored procedure QCL_InsertMedicareNumber
		- Modify stored procedure QCL_UpdateMedicareNumber
		- Create stored procedure QCL_InsertMedicareLookupSurveyType
		- Create stored procedure QCL_UpdateMedicareLookupSurveyType
		- Create stored procedure QCL_SelectMedicareLookupSurveyType
		- Create stored procedure QCL_DeleteMedicareLookupSurveyType
		- Modify stored procedure QCL_InsertSamplingUnlockedLog
		- Create stored procedure QCL_InsertMedicareRecalcSurveyType_History
		- Create stored procedure QCL_SelectMedicareRecalcSurveyType_History

*/

Use [QP_Prod]
GO

PRINT 'Begin rollback table changes'
GO

PRINT 'Rollback MedicareLookup table'
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicSwitchToCalcDate')
    ALTER TABLE [dbo].[MedicareLookup] ADD [SystematicSwitchToCalcDate] [datetime] NULL

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicAnnualReturnTarget')
    ALTER TABLE [dbo].[MedicareLookup] ADD [SystematicAnnualReturnTarget] [int] NULL

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicEstRespRate')
    ALTER TABLE [dbo].[MedicareLookup] ADD [SystematicEstRespRate] [decimal](8, 4) NULL
GO

PRINT 'Rollback MedicareLookupSurveyType table'
GO
IF (OBJECT_ID(N'[dbo].[MedicareLookupSurveyType]') IS NOT NULL)
BEGIN
	UPDATE MedicareLookup
	SET MedicareLookup.SystematicSwitchToCalcDate=MedicareLookupSurveyType.SwitchToCalcDate, 
		MedicareLookup.SystematicAnnualReturnTarget=MedicareLookupSurveyType.AnnualReturnTarget, 
		MedicareLookup.SystematicEstRespRate=MedicareLookupSurveyType.EstRespRate*100
	FROM MedicareLookup
	INNER JOIN MedicareLookupSurveyType ON MedicareLookup.medicareNumber=MedicareLookupSurveyType.medicareNumber
	WHERE MedicareLookupSurveyType.SurveyType_ID=16 AND 
		(MedicareLookupSurveyType.SwitchToCalcDate IS NOT NULL OR 
		MedicareLookupSurveyType.AnnualReturnTarget IS NOT NULL OR 
		MedicareLookupSurveyType.EstRespRate IS NOT NULL)

	DROP TABLE [dbo].[MedicareLookupSurveyType]
END
GO

PRINT 'Rollback MedicareGlobalCalcDefaults table'
GO
IF ((SELECT COUNT(*) FROM [dbo].[MedicareGlobalCalcDefaults])>1)
BEGIN
	DELETE  [dbo].[MedicareGlobalCalcDefaults] WHERE MedicareGlobalCalcDefault_id>1
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicareGlobalCalcDefault_id) FROM MedicareGlobalCalcDefaults
	DBCC CHECKIDENT ('dbo.MedicareGlobalCalcDefaults', RESEED, @maxSeed);  
END
GO

PRINT 'Rollback MedicareProCalcTypes table'
GO
IF EXISTS(SELECT * FROM MedicarePropCalcTypes WHERE MedicarePropCalcTypeName = 'Rate Override')
BEGIN
	DELETE MedicarePropCalcTypes WHERE MedicarePropCalcTypeName = 'Rate Override'
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicarePropCalcType_ID) FROM MedicarePropCalcTypes
	DBCC CHECKIDENT ('dbo.MedicarePropCalcTypes', RESEED, @maxSeed);  
	UPDATE MedicarePropCalcTypes SET MedicarePropCalcTypeName='HCAHPS Proportional Calculation' WHERE MedicarePropCalcTypeName LIKE '%Historic%'
END
GO

PRINT 'Rollback MedicarePropDataType table'
GO
IF  EXISTS(SELECT * FROM MedicarePropDataType WHERE MedicarePropDataType_nm = 'Rate Override')
BEGIN
	DELETE MedicarePropDataType WHERE MedicarePropDataType_nm = 'Rate Override'
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicarePropDataType_ID) FROM MedicarePropDataType
	DBCC CHECKIDENT ('dbo.MedicarePropDataType', RESEED, @maxSeed);  
END
GO

PRINT 'Rollback MedicareRecalcSurveyType_History table'
GO
IF (OBJECT_ID(N'[dbo].[MedicareRecalcSurveyType_History]') IS NOT NULL)
	DROP TABLE [dbo].[MedicareRecalcSurveyType_History]
GO


PRINT 'End rollback table changes'
GO


PRINT 'Start rollback stored procedure changes'
GO

PRINT 'Rollback stored procedure QCL_SelectMedicareNumbers'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectMedicareNumbers] (@MedicareNumber varchar(20))
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,
       EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,
       SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active,
	   SystematicAnnualReturnTarget, SystematicEstRespRate, SystematicSwitchToCalcDate, NonSubmitting
FROM MedicareLookup  
WHERE MedicareNumber = @MedicareNumber
GO

PRINT 'Rollback stored procedure QCL_SelectAllMedicareNumbers'
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareNumbers]    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,  
       EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,  
       SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active,
	   SystematicAnnualReturnTarget, SystematicEstRespRate, SystematicSwitchToCalcDate, NonSubmitting
FROM MedicareLookup

SET NOCOUNT OFF    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

PRINT 'Rollback stored procedure QCL_SelectMedicareNumbersBySurveyID'
GO
ALTER PROCEDURE [dbo].[QCL_SelectMedicareNumbersBySurveyID]  
    @SurveyID int  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
SELECT DISTINCT ml.MedicareNumber, ml.MedicareName, ml.MedicarePropCalcType_ID, ml.EstAnnualVolume,  
       ml.EstRespRate, ml.EstIneligibleRate, ml.SwitchToCalcDate, ml.AnnualReturnTarget,  
       ml.SamplingLocked, ml.ProportionChangeThreshold, ml.CensusForced, ml.PENumber, ml.Active,
	   ml.SystematicAnnualReturnTarget, ml.SystematicEstRespRate, ml.SystematicSwitchToCalcDate, ml.NonSubmitting
FROM MedicareLookup ml, SUFacility sf, SampleUnit su, SamplePlan sp, Survey_Def sd   
WHERE ml.MedicareNumber = sf.MedicareNumber  
  AND sf.SUFacility_id = su.SUFacility_id  
  AND su.SamplePlan_id = sp.SamplePlan_id  
  AND sp.Survey_id = sd.Survey_id  
  AND sd.Survey_id = @SurveyID  
  GO

  PRINT 'Rollback stored procedure QCL_InsertMedicareNumber'
GO
ALTER PROCEDURE [dbo].[QCL_InsertMedicareNumber]  
    @MedicareNumber VARCHAR(20),  
    @MedicareName varchar(45),
    @MedicarePropCalcType_ID int,
    @EstAnnualVolume int,
    @EstRespRate decimal(8,4),
    @EstIneligibleRate decimal(8,4),
    @SwitchToCalcDate datetime,
    @AnnualReturnTarget int,
    @SamplingLocked tinyint,
    @ProportionChangeThreshold decimal(8,4),
    @CensusForced tinyint,
    @PENumber VARCHAR(50), 
    @Active bit,
	@SystematicAnnualReturnTarget int,
	@SystematicEstRespRate decimal(8,4),
	@SystematicSwitchToCalcDate datetime,
	@NonSubmitting bit
AS  
  
IF EXISTS (SELECT * FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber)  
BEGIN  
    RAISERROR ('MedicareNumber already exists.',18,1)  
    RETURN  
END  
  
INSERT INTO MedicareLookup (MedicareNumber, MedicareName, MedicarePropCalcType_ID, 
                            EstAnnualVolume, EstRespRate, EstIneligibleRate, 
                            SwitchToCalcDate, AnnualReturnTarget, SamplingLocked,
                            ProportionChangeThreshold, CensusForced, PENumber, Active,
							SystematicAnnualReturnTarget, SystematicEstRespRate, SystematicSwitchToCalcDate, NonSubmitting)
SELECT @MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstAnnualVolume,
       @EstRespRate, @EstIneligibleRate, @SwitchToCalcDate, @AnnualReturnTarget, 
       @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @PENumber, @Active,
	   @SystematicAnnualReturnTarget, @SystematicEstRespRate, @SystematicSwitchToCalcDate, @NonSubmitting

SELECT @MedicareNumber
GO


PRINT 'Rollback stored procedure QCL_UpdateMedicareNumber'
GO
ALTER PROCEDURE [dbo].[QCL_UpdateMedicareNumber]  
    @MedicareNumber VARCHAR(20),  
    @MedicareName VARCHAR(45),
    @MedicarePropCalcType_ID int,
    @EstAnnualVolume int,
    @EstRespRate decimal(8,4),
    @EstIneligibleRate decimal(8,4),
    @SwitchToCalcDate datetime,
    @AnnualReturnTarget int,
    @SamplingLocked tinyint,
    @ProportionChangeThreshold decimal(8,4),
    @CensusForced tinyint,
    @PENumber VARCHAR(50), 
    @Active bit,
	@SystematicAnnualReturnTarget int,
	@SystematicEspRespRate decimal(8,4),
	@SystematicSwitchToCalcDate datetime,
	@NonSubmitting bit
AS  

UPDATE MedicareLookup  
SET MedicareName = @MedicareName,  
    MedicarePropCalcType_ID = @MedicarePropCalcType_ID,
    EstAnnualVolume = @EstAnnualVolume ,
    EstRespRate = @EstRespRate ,
    EstIneligibleRate = @EstIneligibleRate,
    SwitchToCalcDate = @SwitchToCalcDate ,
    AnnualReturnTarget = @AnnualReturnTarget,
    SamplingLocked = @SamplingLocked ,
    ProportionChangeThreshold = @ProportionChangeThreshold ,
    CensusForced = @CensusForced,
    PENumber = @PENumber, 
    Active = @Active,
	SystematicAnnualReturnTarget = @SystematicAnnualReturnTarget,
	SystematicEstRespRate = @SystematicEspRespRate,
	SystematicSwitchToCalcDate = @SystematicSwitchToCalcDate,
	NonSubmitting = @NonSubmitting
WHERE MedicareNumber = @MedicareNumber
GO


PRINT 'Rollback stored procedure QCL_InsertMedicareLookupSurveyType'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_InsertMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_InsertMedicareLookupSurveyType]
GO

PRINT 'Rollback stored procedure QCL_UpdateMedicareLookupSurveyType'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_UpdateMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_UpdateMedicareLookupSurveyType]
GO

PRINT 'Rollback stored procedure QCL_SelectMedicareLookupSurveyType'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectMedicareLookupSurveyType]
GO

PRINT 'Rollback stored procedure QCL_DeleteMedicareLookupSurveyType'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_DeleteMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_DeleteMedicareLookupSurveyType]
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

PRINT 'Rollback stored procedure QCL_InsertMedicareRecalcSurveyType_History'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_InsertMedicareRecalcSurveyType_History]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_InsertMedicareRecalcSurveyType_History]
GO

PRINT 'Rollback stored procedure QCL_SelectMedicareRecalcSurveyType_History'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectMedicareRecalcSurveyType_History]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectMedicareRecalcSurveyType_History]
GO


 PRINT 'End rollback stored procedure changes'
GO
