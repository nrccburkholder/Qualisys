/*
	RTP-4164 Add HH & OAS to Medicare Mgmt - Show HHCAHPS data - Rollback.sql
	Jing Fu, 8/10/2017
*/

Use [QP_Prod]
GO

PRINT 'Start table changes'
GO

PRINT 'Modify MedicareLookup table table'
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

PRINT 'Drop MedicareLookupSurveyType table'
GO
IF (OBJECT_ID(N'[dbo].[MedicareLookupSurveyType]') IS NOT NULL)
	DROP TABLE [dbo].[MedicareLookupSurveyType]

GO

PRINT 'Modify MedicareGlobalCalcDefaults table'
GO
IF ((SELECT COUNT(*) FROM [dbo].[MedicareGlobalCalcDefaults])>1)
BEGIN
	DELETE  [dbo].[MedicareGlobalCalcDefaults] WHERE MedicareGlobalCalcDefault_id>1
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicareGlobalCalcDefault_id) FROM MedicareGlobalCalcDefaults
	DBCC CHECKIDENT ('dbo.MedicareGlobalCalcDefaults', RESEED, @maxSeed);  
END
GO

PRINT 'Modify MedicareProCalcTypes table'
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

PRINT 'Modify MedicarePropDataType table'
GO
IF  EXISTS(SELECT * FROM MedicarePropDataType WHERE MedicarePropDataType_nm = 'Rate Override')
BEGIN
	DELETE MedicarePropDataType WHERE MedicarePropDataType_nm = 'Rate Override'
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicarePropDataType_ID) FROM MedicarePropDataType
	DBCC CHECKIDENT ('dbo.MedicarePropDataType', RESEED, @maxSeed);  
END
GO

PRINT 'End table changes'
GO


PRINT 'Start stored procedure changes'
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

 PRINT 'End stored procedure changes'
GO

GO