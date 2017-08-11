/*
	RTP-4164 Add HH & OAS to Medicare Mgmt - Show HHCAHPS data.sql
	Jing Fu, 8/10/2017
*/

Use [QP_Prod]
GO

PRINT 'Start table changes'
GO

PRINT 'Modify MedicareLookup table'
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicSwitchToCalcDate')
    ALTER TABLE [dbo].[MedicareLookup] DROP COLUMN [SystematicSwitchToCalcDate]

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicAnnualReturnTarget')
    ALTER TABLE [dbo].[MedicareLookup]  DROP COLUMN [SystematicAnnualReturnTarget]

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicEstRespRate')
    ALTER TABLE [dbo].[MedicareLookup]  DROP COLUMN [SystematicEstRespRate]
GO

PRINT 'Add MedicareLookupSurveyType table'
GO
IF (OBJECT_ID(N'[dbo].[MedicareLookupSurveyType]') IS NULL)
BEGIN
	CREATE TABLE [dbo].[MedicareLookupSurveyType](
		[SurveyType_ID]				[int]					NOT NULL,
		[MedicareNumber]			[varchar](20) NOT NULL,
		[MedicareName]				[varchar](200) NOT NULL,
		[Active]								[bit]					NULL,
		[MedicarePropCalcType_ID] [int]			NOT NULL,
		[SwitchToCalcDate]			[datetime]		NULL,
		[EstAnnualVolume]			[int]					NULL,
		[EstRespRate]					[decimal](8, 4) NULL,
		[AnnualReturnTarget]		[int]					NULL,
		[SamplingLocked]				[tinyint]			NULL,
		[ProportionChangeThreshold]		[decimal](8, 4)	NULL,
		[SwitchFromRateOverrideDate]	[datetime]			NULL,
		[SamplingRateOverride] [decimal](8, 4) NULL,
		[NonSubmitting]				[bit]					NULL,
	 CONSTRAINT [PK_MedicareLookupSurveyType_SurveyTypeMedicareNumber] PRIMARY KEY CLUSTERED 
	(
		[SurveyType_ID] ASC,
		[MedicareNumber] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT FK_MedicareLookupSurveyType_SurveyType_ID FOREIGN KEY (SurveyType_ID) REFERENCES SurveyType(SurveyType_ID),
	CONSTRAINT FK_MedicareLookupSurveyType_MedicarePropCalcType_ID FOREIGN KEY (MedicarePropCalcType_ID) REFERENCES MedicarePropCalcTypes(MedicarePropCalcType_ID),
	) ON [PRIMARY]
		
	ALTER TABLE [dbo].[MedicareLookupSurveyType] ADD  CONSTRAINT [DF_MedicareLookupSurveyType_Active]  DEFAULT ((1)) FOR [Active]
	
	ALTER TABLE [dbo].[MedicareLookupSurveyType] ADD  CONSTRAINT [DF_MedicareLookupSurveyType_MedicarePropCalcType_ID]  DEFAULT ((2)) FOR [MedicarePropCalcType_ID]
	
	ALTER TABLE [dbo].[MedicareLookupSurveyType] ADD  CONSTRAINT [DF_MedicareLookupSurveyType_SamplingLocked]  DEFAULT ((0)) FOR [SamplingLocked]
	
END
GO

PRINT 'Modify MedicareGlobalCalcDefaults table'
GO
IF ((SELECT COUNT(*) FROM [dbo].[MedicareGlobalCalcDefaults])=1)
BEGIN
	DECLARE 
		@RespRate DECIMAL(8, 4),
		@IneligibleRate DECIMAL(8, 4),
		@ProportionChangeThreshold DECIMAL(8, 4),
		@AnnualReturnTarget	 INT,
		@ForceCensusSamplePercentage DECIMAL(8, 4)

	SELECT TOP 1 
		  @RespRate = RespRate
		  ,@IneligibleRate = IneligibleRate
		  ,@ProportionChangeThreshold = ProportionChangeThreshold
		  ,@AnnualReturnTarget = AnnualReturnTarget
		  ,@ForceCensusSamplePercentage = ForceCensusSamplePercentage
	 FROM [dbo].[MedicareGlobalCalcDefaults]
	 	 
	DELETE [dbo].[MedicareGlobalCalcDefaults]
	DBCC CHECKIDENT ('dbo.MedicareGlobalCalcDefaults', RESEED, 0);  

	INSERT INTO [dbo].[MedicareGlobalCalcDefaults]
           ([RespRate]
           ,[IneligibleRate]
           ,[ProportionChangeThreshold]
           ,[AnnualReturnTarget]
           ,[ForceCensusSamplePercentage])
     VALUES (
           @RespRate,
           @IneligibleRate,
           @ProportionChangeThreshold,
           @AnnualReturnTarget,
           @ForceCensusSamplePercentage)

	/*
	MedicareGlobalCalcDefault_id:
	1 = HCAHPS
	2 = HH CAHPS
	3 = OAS CAHPS
	*/

	INSERT INTO [dbo].[MedicareGlobalCalcDefaults]
			   ([RespRate], [IneligibleRate], [ProportionChangeThreshold], [AnnualReturnTarget], [ForceCensusSamplePercentage])
	VALUES (0.2800, 0, 0.0500, 384, 0)

	INSERT INTO [dbo].[MedicareGlobalCalcDefaults]
			   ([RespRate], [IneligibleRate], [ProportionChangeThreshold], [AnnualReturnTarget], [ForceCensusSamplePercentage])
	VALUES (0.2800, 0, 0.0500, 384, 0)
END
GO

PRINT 'Modify MedicareProCalcTypes table'
GO
UPDATE MedicarePropCalcTypes SET MedicarePropCalcTypeName='Historic' WHERE MedicarePropCalcTypeName LIKE '%HCAHPS Proportional Calculation%'
IF NOT EXISTS(SELECT * FROM MedicarePropCalcTypes WHERE MedicarePropCalcTypeName = 'Rate Override')
BEGIN
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicarePropCalcType_ID) FROM MedicarePropCalcTypes
	DBCC CHECKIDENT ('dbo.MedicarePropCalcTypes', RESEED, @maxSeed);  
	INSERT INTO MedicarePropCalcTypes (MedicarePropCalcTypeName) VALUES ('Rate Override')
END
GO

PRINT 'Modify MedicarePropDataType table'
GO
IF NOT EXISTS(SELECT * FROM MedicarePropDataType WHERE MedicarePropDataType_nm = 'Rate Override')
BEGIN
	DECLARE @maxSeed INT
	SELECT @maxSeed=MAX(MedicarePropDataType_ID) FROM MedicarePropDataType
	DBCC CHECKIDENT ('dbo.MedicarePropDataType', RESEED, @maxSeed);  
	INSERT INTO MedicarePropDataType (MedicarePropDataType_nm) VALUES ('Rate Override')
END
GO

PRINT 'End table changes'
GO


PRINT 'Start stored procedure changes'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
PRINT 'Modify stored procedure QCL_SelectMedicareNumbers'
GO
ALTER PROCEDURE [dbo].[QCL_SelectMedicareNumbers] (@MedicareNumber varchar(20))
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON  
  
	SELECT HCAHPS.MedicareNumber, HCAHPS.MedicareName, HCAHPS.MedicarePropCalcType_ID, HCAHPS.EstAnnualVolume, HCAHPS.EstRespRate, 
			HCAHPS.EstIneligibleRate, HCAHPS.SwitchToCalcDate, HCAHPS.AnnualReturnTarget, HCAHPS.SamplingLocked, HCAHPS.ProportionChangeThreshold, 
			HCAHPS.CensusForced, HCAHPS.PENumber, HCAHPS.Active, HCAHPS.NonSubmitting,

		HHCAHPS.Active AS HHCAHPS_Active,
		COALESCE(	HHCAHPS.MedicarePropCalcType_ID,0) AS HHCAHPS_MedicarePropCalcType_ID,
		HHCAHPS.SwitchToCalcDate AS HHCAHPS_SwitchToCalcDate,
		HHCAHPS.EstAnnualVolume AS HHCAHPS_EstAnnualVolume,
		HHCAHPS.EstRespRate AS HHCAHPS_EstRespRate,
		HHCAHPS.AnnualReturnTarget AS HHCAHPS_AnnualReturnTarget,
		HHCAHPS.SamplingLocked AS HHCAHPS_SamplingLocked,
		HHCAHPS.ProportionChangeThreshold AS HHCAHPS_ProportionChangeThreshold,
		HHCAHPS.SwitchFromRateOverrideDate AS HHCAHPS_SwitchFromRateOverrideDate,
		HHCAHPS.SamplingRateOverride AS HHCAHPS_SamplingRateOverride,
		HHCAHPS.NonSubmitting AS HHCAHPS_NonSubmitting,

		OASCAHPS.Active AS OASCAHPS_Active,
		COALESCE(	OASCAHPS.MedicarePropCalcType_ID,0) AS OASCAHPS_MedicarePropCalcType_ID,
		OASCAHPS.SwitchToCalcDate AS OASCAHPS_SwitchToCalcDate,
		OASCAHPS.EstAnnualVolume AS OASCAHPS_EstAnnualVolume,
		OASCAHPS.EstRespRate AS OASCAHPS_EstRespRate,
		OASCAHPS.AnnualReturnTarget AS OASCAHPS_AnnualReturnTarget,
		OASCAHPS.SamplingLocked AS OASCAHPS_SamplingLocked,
		OASCAHPS.ProportionChangeThreshold AS OASCAHPS_ProportionChangeThreshold,
		OASCAHPS.SwitchFromRateOverrideDate AS OASCAHPS_SwitchFromRateOverrideDate,
		OASCAHPS.SamplingRateOverride AS OASCAHPS_SamplingRateOverride,
		OASCAHPS.NonSubmitting AS OASCAHPS_NonSubmitting

	FROM MedicareLookup  AS HCAHPS
	LEFT OUTER JOIN MedicareLookupSurveyType AS HHCAHPS ON HCAHPS.MedicareNumber=HHCAHPS.MedicareNumber AND HHCAHPS.surveyType_ID=3
	LEFT OUTER JOIN MedicareLookupSurveyType AS OASCAHPS ON HCAHPS.MedicareNumber=OASCAHPS.MedicareNumber AND OASCAHPS.surveyType_ID=16
	WHERE HCAHPS.MedicareNumber = @MedicareNumber

	SET NOCOUNT OFF      
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END
GO

PRINT 'Modify stored procedure QCL_SelectAllMedicareNumbers'
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllMedicareNumbers]    
AS    
BEGIN    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
	SET NOCOUNT ON    
    
	SELECT HCAHPS.MedicareNumber, HCAHPS.MedicareName, HCAHPS.MedicarePropCalcType_ID, HCAHPS.EstAnnualVolume, HCAHPS.EstRespRate, 
		HCAHPS.EstIneligibleRate, HCAHPS.SwitchToCalcDate, HCAHPS.AnnualReturnTarget, HCAHPS.SamplingLocked, HCAHPS.ProportionChangeThreshold, 
		HCAHPS.CensusForced, HCAHPS.PENumber, HCAHPS.Active, HCAHPS.NonSubmitting,

		HHCAHPS.Active AS HHCAHPS_Active,
		COALESCE(	HHCAHPS.MedicarePropCalcType_ID,0) AS HHCAHPS_MedicarePropCalcType_ID,
		HHCAHPS.SwitchToCalcDate AS HHCAHPS_SwitchToCalcDate,
		HHCAHPS.EstAnnualVolume AS HHCAHPS_EstAnnualVolume,
		HHCAHPS.EstRespRate AS HHCAHPS_EstRespRate,
		HHCAHPS.AnnualReturnTarget AS HHCAHPS_AnnualReturnTarget,
		HHCAHPS.SamplingLocked AS HHCAHPS_SamplingLocked,
		HHCAHPS.ProportionChangeThreshold AS HHCAHPS_ProportionChangeThreshold,
		HHCAHPS.SwitchFromRateOverrideDate AS HHCAHPS_SwitchFromRateOverrideDate,
		HHCAHPS.SamplingRateOverride AS HHCAHPS_SamplingRateOverride,
		HHCAHPS.NonSubmitting AS HHCAHPS_NonSubmitting,

		OASCAHPS.Active AS OASCAHPS_Active,
		COALESCE(	OASCAHPS.MedicarePropCalcType_ID,0) AS OASCAHPS_MedicarePropCalcType_ID,
		OASCAHPS.SwitchToCalcDate AS OASCAHPS_SwitchToCalcDate,
		OASCAHPS.EstAnnualVolume AS OASCAHPS_EstAnnualVolume,
		OASCAHPS.EstRespRate AS OASCAHPS_EstRespRate,
		OASCAHPS.AnnualReturnTarget AS OASCAHPS_AnnualReturnTarget,
		OASCAHPS.SamplingLocked AS OASCAHPS_SamplingLocked,
		OASCAHPS.ProportionChangeThreshold AS OASCAHPS_ProportionChangeThreshold,
		OASCAHPS.SwitchFromRateOverrideDate AS OASCAHPS_SwitchFromRateOverrideDate,
		OASCAHPS.SamplingRateOverride AS OASCAHPS_SamplingRateOverride,
		OASCAHPS.NonSubmitting AS OASCAHPS_NonSubmitting

	FROM MedicareLookup  AS HCAHPS
	LEFT OUTER JOIN MedicareLookupSurveyType AS HHCAHPS ON HCAHPS.MedicareNumber=HHCAHPS.MedicareNumber AND HHCAHPS.surveyType_ID=3
	LEFT OUTER JOIN MedicareLookupSurveyType AS OASCAHPS ON HCAHPS.MedicareNumber=OASCAHPS.MedicareNumber AND OASCAHPS.surveyType_ID=16

	SET NOCOUNT OFF    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

PRINT 'Modify stored procedure QCL_SelectMedicareNumbersBySurveyID'
GO
ALTER PROCEDURE [dbo].[QCL_SelectMedicareNumbersBySurveyID]  
    @SurveyID int  
AS  
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON  
  
  	SELECT HCAHPS.MedicareNumber, HCAHPS.MedicareName, HCAHPS.MedicarePropCalcType_ID, HCAHPS.EstAnnualVolume, HCAHPS.EstRespRate, 
		HCAHPS.EstIneligibleRate, HCAHPS.SwitchToCalcDate, HCAHPS.AnnualReturnTarget, HCAHPS.SamplingLocked, HCAHPS.ProportionChangeThreshold, 
		HCAHPS.CensusForced, HCAHPS.PENumber, HCAHPS.Active, HCAHPS.NonSubmitting,

		HHCAHPS.Active AS HHCAHPS_Active,
		COALESCE(	HHCAHPS.MedicarePropCalcType_ID,0) AS HHCAHPS_MedicarePropCalcType_ID,
		HHCAHPS.SwitchToCalcDate AS HHCAHPS_SwitchToCalcDate,
		HHCAHPS.EstAnnualVolume AS HHCAHPS_EstAnnualVolume,
		HHCAHPS.EstRespRate AS HHCAHPS_EstRespRate,
		HHCAHPS.AnnualReturnTarget AS HHCAHPS_AnnualReturnTarget,
		HHCAHPS.SamplingLocked AS HHCAHPS_SamplingLocked,
		HHCAHPS.ProportionChangeThreshold AS HHCAHPS_ProportionChangeThreshold,
		HHCAHPS.SwitchFromRateOverrideDate AS HHCAHPS_SwitchFromRateOverrideDate,
		HHCAHPS.SamplingRateOverride AS HHCAHPS_SamplingRateOverride,
		HHCAHPS.NonSubmitting AS HHCAHPS_NonSubmitting,

		OASCAHPS.Active AS OASCAHPS_Active,
		COALESCE(	OASCAHPS.MedicarePropCalcType_ID,0) AS OASCAHPS_MedicarePropCalcType_ID,
		OASCAHPS.SwitchToCalcDate AS OASCAHPS_SwitchToCalcDate,
		OASCAHPS.EstAnnualVolume AS OASCAHPS_EstAnnualVolume,
		OASCAHPS.EstRespRate AS OASCAHPS_EstRespRate,
		OASCAHPS.AnnualReturnTarget AS OASCAHPS_AnnualReturnTarget,
		OASCAHPS.SamplingLocked AS OASCAHPS_SamplingLocked,
		OASCAHPS.ProportionChangeThreshold AS OASCAHPS_ProportionChangeThreshold,
		OASCAHPS.SwitchFromRateOverrideDate AS OASCAHPS_SwitchFromRateOverrideDate,
		OASCAHPS.SamplingRateOverride AS OASCAHPS_SamplingRateOverride,
		OASCAHPS.NonSubmitting AS OASCAHPS_NonSubmitting

	FROM 
	(SELECT DISTINCT ml.MedicareNumber, ml.MedicareName, ml.MedicarePropCalcType_ID, ml.EstAnnualVolume,  
		   ml.EstRespRate, ml.EstIneligibleRate, ml.SwitchToCalcDate, ml.AnnualReturnTarget,  ml.SamplingLocked, 
		   ml.ProportionChangeThreshold, ml.CensusForced, ml.PENumber, ml.Active, ml.NonSubmitting
	FROM MedicareLookup ml, SUFacility sf, SampleUnit su, SamplePlan sp, Survey_Def sd   
	WHERE ml.MedicareNumber = sf.MedicareNumber  
	  AND sf.SUFacility_id = su.SUFacility_id  
	  AND su.SamplePlan_id = sp.SamplePlan_id  
	  AND sp.Survey_id = sd.Survey_id  
	  AND sd.Survey_id = @SurveyID) AS HCAHPS
	LEFT OUTER JOIN MedicareLookupSurveyType AS HHCAHPS ON HCAHPS.MedicareNumber=HHCAHPS.MedicareNumber AND HHCAHPS.surveyType_ID=3
	LEFT OUTER JOIN MedicareLookupSurveyType AS OASCAHPS ON HCAHPS.MedicareNumber=OASCAHPS.MedicareNumber AND OASCAHPS.surveyType_ID=16

	SET NOCOUNT OFF    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO


PRINT 'End stored procedure changes'
GO



