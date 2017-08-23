/*
	RTP-4164 Add HH & OAS to Medicare Mgmt - Show HHCAHPS data.sql
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
	- Create new stored procedure QCL_InsertMedicareLookupSurveyType
	- Create new stored procedure QCL_UpdateMedicareLookupSurveyType
	- Create new stored procedure QCL_SelectMedicareLookupSurveyType
	- Create new stored procedure QCL_DeleteMedicareLookupSurveyType
	- Modify stored procedure QCL_InsertSamplingUnlockedLog
	- Create new stored procedure QCL_InsertMedicareRecalcSurveyType_History
	- Create new stored procedure QCL_SelectMedicareRecalcSurveyType_History

*/

Use [QP_Prod]
GO

PRINT 'Start table changes'
GO

PRINT 'Add MedicareLookupSurveyType table'
GO
IF (OBJECT_ID(N'[dbo].[MedicareLookupSurveyType]') IS NULL)
BEGIN
	CREATE TABLE [dbo].[MedicareLookupSurveyType](
		[SurveyType_ID]				[int]					NOT NULL,
		[MedicareNumber]			[varchar](20) NOT NULL,
		[Active]								[bit]					NULL,
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
	CONSTRAINT FK_MedicareLookupSurveyType_SurveyType_ID FOREIGN KEY (SurveyType_ID) REFERENCES SurveyType(SurveyType_ID)
	) ON [PRIMARY]
		
	ALTER TABLE [dbo].[MedicareLookupSurveyType] ADD  CONSTRAINT [DF_MedicareLookupSurveyType_Active]  DEFAULT ((1)) FOR [Active]
	ALTER TABLE [dbo].[MedicareLookupSurveyType] ADD  CONSTRAINT [DF_MedicareLookupSurveyType_SamplingLocked]  DEFAULT ((0)) FOR [SamplingLocked]
	
END
GO

PRINT 'Move OAS CAHPS data from MedicareLookup to MedicareLookupSurveyType'
GO
IF (EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicSwitchToCalcDate')) AND
	(EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicAnnualReturnTarget')) AND
	(EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MedicareLookup' AND COLUMN_NAME = 'SystematicEstRespRate'))
BEGIN
	DECLARE @surveyType_ID INT
	SELECT @surveyType_ID=16
	
	INSERT INTO MedicareLookupSurveyType (surveyType_ID,  MedicareNumber, SwitchToCalcDate, AnnualReturnTarget, EstRespRate)
	SELECT @surveyType_ID, MedicareNumber, SystematicSwitchToCalcDate, SystematicAnnualReturnTarget, SystematicEstRespRate 
	FROM MedicareLookup 
	WHERE SystematicSwitchToCalcDate IS NOT NULL OR SystematicAnnualReturnTarget IS NOT NULL OR SystematicEstRespRate IS NOT NULL

END
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

PRINT 'Add MedicareRecalcSurveyType_History table'
GO
IF (OBJECT_ID(N'[dbo].[MedicareRecalcSurveyType_History]') IS NULL)
	CREATE TABLE [dbo].[MedicareRecalcSurveyType_History](
		[MedicareReCalcLog_ID]	[int] IDENTITY(1,1)	NOT NULL,
		[SurveyType_ID]						[INT]						NOT NULL,
		[MedicareNumber]					[VARCHAR](20)		NULL,
		[MedicarePropCalcType_ID]	[INT]						NULL,
		[MedicarePropDataType_ID] [INT]						NULL,
		[EstRespRate]							[DECIMAL](8, 4)	NULL,
		[EstAnnualVolume]					[INT]						NULL,
		[SwitchToCalcDate]					[DATETIME]			NULL,
		[AnnualReturnTarget]				[INT]						NULL,
		[ProportionCalcPct]					[DECIMAL](8, 4)	NULL,
		[SamplingLocked]						[TINYINT]				NULL,
		[ProportionChangeThreshold] [DECIMAL](8, 4)	NULL,
		[Member_ID]							[INT]						NULL,
		[DateCalculated]						[DATETIME]			NULL,
		[HistoricRespRate]					[DECIMAL](8, 4)	NULL,
		[HistoricAnnualVolume]			[INT]						NULL,
		[ForcedCalculation]					[TINYINT]				NULL,
		[PropSampleCalcDate]			[DATETIME]			NULL,
		[SwitchFromRateOverrideDate] [DATETIME]		NULL,
		[SamplingRateOverride]			[DECIMAL](8, 4)	NULL,
	CONSTRAINT [PK_MedicareRecalcSurveyType_History_History] PRIMARY KEY CLUSTERED 	(MedicareReCalcLog_ID ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT FK_MedicareRecalcSurveyType_History_History_SurveyType_ID FOREIGN KEY (SurveyType_ID) REFERENCES SurveyType(SurveyType_ID),
	CONSTRAINT FK_MedicareRecalcSurveyType_History_History_MedicarePropCalcType_ID FOREIGN KEY (MedicarePropCalcType_ID) REFERENCES MedicarePropCalcTypes(MedicarePropCalcType_ID),
	CONSTRAINT FK_MedicareRecalcSurveyType_History_History_MedicarePropDataType_ID FOREIGN KEY (MedicarePropDataType_ID) REFERENCES MedicarePropDataType(MedicarePropDataType_ID)
	) ON [PRIMARY]
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
  
	 SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,
		   EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,
		   SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active,
		   NULL AS SystematicAnnualReturnTarget, NULL AS SystematicEstRespRate, NULL AS SystematicSwitchToCalcDate, NonSubmitting
	FROM MedicareLookup  
	WHERE MedicareNumber = @MedicareNumber
	
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

	SELECT MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume,  
		   EstRespRate, EstIneligibleRate, SwitchToCalcDate, AnnualReturnTarget,  
		   SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active,
		   NULL AS SystematicAnnualReturnTarget, NULL AS SystematicEstRespRate, NULL AS SystematicSwitchToCalcDate, NonSubmitting
	FROM MedicareLookup
	
	SET NOCOUNT OFF    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

PRINT 'Modify stored procedure QCL_InsertMedicareNumber'
GO
ALTER PROCEDURE [dbo].[QCL_InsertMedicareNumber]  
    @MedicareNumber					VARCHAR(20),  
    @MedicareName						VARCHAR(45),
    @MedicarePropCalcType_ID INT,
    @EstAnnualVolume					INT,
    @EstRespRate							DECIMAL(8,4),
    @EstIneligibleRate					DECIMAL(8,4),
    @SwitchToCalcDate					DATETIME,
    @AnnualReturnTarget				INT,
    @SamplingLocked					TINYINT,
    @ProportionChangeThreshold DECIMAL(8,4),
    @CensusForced						TINYINT,
    @PENumber								VARCHAR(50), 
    @Active										BIT,
	@SystematicAnnualReturnTarget INT = NULL,
	@SystematicEstRespRate		DECIMAL(8,4) = NULL,
	@SystematicSwitchToCalcDate DATETIME = NULL,
	@NonSubmitting						BIT
AS  
BEGIN 
	IF EXISTS (SELECT * FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber)  
	BEGIN  
		RAISERROR ('MedicareNumber already exists.',18,1)  
		RETURN  
	END  
  
	INSERT INTO MedicareLookup (MedicareNumber, MedicareName, MedicarePropCalcType_ID, EstAnnualVolume, EstRespRate, EstIneligibleRate, 
							SwitchToCalcDate, AnnualReturnTarget, SamplingLocked, ProportionChangeThreshold, CensusForced, PENumber, Active, NonSubmitting)
	VALUES (@MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstAnnualVolume, @EstRespRate, @EstIneligibleRate, 
				@SwitchToCalcDate, @AnnualReturnTarget, @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @PENumber, @Active, @NonSubmitting)

	SELECT @MedicareNumber
END
GO


PRINT 'Modify stored procedure QCL_UpdateMedicareNumber'
GO
ALTER PROCEDURE [dbo].[QCL_UpdateMedicareNumber]  
    @MedicareNumber					VARCHAR(20),  
    @MedicareName						VARCHAR(45),
    @MedicarePropCalcType_ID INT,
    @EstAnnualVolume					INT,
    @EstRespRate							DECIMAL(8,4),
    @EstIneligibleRate					DECIMAL(8,4),
    @SwitchToCalcDate					DATETIME,
    @AnnualReturnTarget				INT,
    @SamplingLocked					TINYINT,
    @ProportionChangeThreshold DECIMAL(8,4),
    @CensusForced						TINYINT,
    @PENumber								VARCHAR(50), 
    @Active										BIT,
	@SystematicAnnualReturnTarget INT = NULL,
	@SystematicEspRespRate		DECIMAL(8,4) = NULL,
	@SystematicSwitchToCalcDate DATETIME = NULL,
	@NonSubmitting						BIT
AS  
BEGIN
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
		NonSubmitting = @NonSubmitting
	WHERE MedicareNumber = @MedicareNumber
END
GO


PRINT 'Create stored procedure QCL_InsertMedicareLookupSurveyType'
GO

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_InsertMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_InsertMedicareLookupSurveyType]
GO

CREATE PROCEDURE [dbo].[QCL_InsertMedicareLookupSurveyType]  
    @MedicareNumber			VARCHAR(20),  
	@surveyType_ID				INT,
	@EstAnnualVolume			INT,
    @EstRespRate					DECIMAL(8,4),
    @SwitchToCalcDate			DATETIME,
    @AnnualReturnTarget		INT,
    @SamplingLocked			TINYINT,
    @ProportionChangeThreshold DECIMAL(8,4),
    @Active								BIT,
	@NonSubmitting				BIT,
	@SwitchFromRateOverrideDate DATETIME,
	@SamplingRateOverride		DECIMAL(8, 4)
AS  
BEGIN
	IF EXISTS (SELECT * FROM MedicareLookupSurveyType WHERE MedicareNumber=@MedicareNumber AND surveyType_ID=@surveyType_ID)  
	BEGIN  
		RAISERROR ('MedicareNumber for the survey type already exists.',18,1)  
		RETURN  
	END  
  
	INSERT INTO MedicareLookupSurveyType (	
		SurveyType_ID, MedicareNumber, Active, SwitchToCalcDate,	EstAnnualVolume, EstRespRate, 
		AnnualReturnTarget, SamplingLocked, ProportionChangeThreshold, SwitchFromRateOverrideDate, SamplingRateOverride,	NonSubmitting)
	VALUES (@surveyType_ID, @MedicareNumber, @Active, @SwitchToCalcDate, @EstAnnualVolume, @EstRespRate, 
		@AnnualReturnTarget, @SamplingLocked, @ProportionChangeThreshold, @SwitchFromRateOverrideDate, @SamplingRateOverride, @NonSubmitting)

	SELECT @MedicareNumber

END
GO

PRINT 'Create stored procedure QCL_UpdateMedicareLookupSurveyType'
GO

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_UpdateMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_UpdateMedicareLookupSurveyType]
GO
CREATE PROCEDURE [dbo].[QCL_UpdateMedicareLookupSurveyType]  
    @MedicareNumber		VARCHAR(20),  
	@surveyType_ID			INT, 
    @EstAnnualVolume			INT,
    @EstRespRate					DECIMAL(8,4),
    @SwitchToCalcDate			DATETIME,
    @AnnualReturnTarget		INT,
    @SamplingLocked			TINYINT,
    @ProportionChangeThreshold DECIMAL(8,4),
    @Active								BIT,
	@NonSubmitting				BIT,
	@SwitchFromRateOverrideDate DATETIME,
	@SamplingRateOverride		DECIMAL(8, 4)
AS  
BEGIN
	UPDATE MedicareLookupSurveyType  
	SET
		EstAnnualVolume = @EstAnnualVolume ,
		EstRespRate = @EstRespRate ,
		SwitchToCalcDate = @SwitchToCalcDate ,
		AnnualReturnTarget = @AnnualReturnTarget,
		SamplingLocked = @SamplingLocked ,
		ProportionChangeThreshold = @ProportionChangeThreshold ,
		Active = @Active,
		NonSubmitting = @NonSubmitting,
		SwitchFromRateOverrideDate = @SwitchFromRateOverrideDate, 
		SamplingRateOverride = @SamplingRateOverride
	WHERE MedicareNumber = @MedicareNumber AND SurveyType_ID=@surveyType_ID
		
END
GO

PRINT 'Create stored procedure QCL_SelectMedicareLookupSurveyType'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectMedicareLookupSurveyType]
GO
CREATE  PROCEDURE [dbo].[QCL_SelectMedicareLookupSurveyType] 
@MedicareNumber	VARCHAR(20),
@surveyType_ID		INT
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON  
	SELECT 
		MedicareLookupSurveyType.MedicareNumber, 
		MedicareLookup.MedicareName, 
		MedicareLookupSurveyType.SurveyType_ID as SurveyTypeID, 
		MedicareLookupSurveyType.Active, 
		MedicareLookupSurveyType.SwitchToCalcDate, 
		MedicareLookupSurveyType.EstAnnualVolume, 
		MedicareLookupSurveyType.EstRespRate, 
		MedicareLookupSurveyType.AnnualReturnTarget, 
		MedicareLookupSurveyType.SamplingLocked, 
		MedicareLookupSurveyType.ProportionChangeThreshold, 
		MedicareLookupSurveyType.SwitchFromRateOverrideDate, 
		MedicareLookupSurveyType.SamplingRateOverride, 
		MedicareLookupSurveyType.NonSubmitting
	FROM MedicareLookupSurveyType 
	INNER JOIN MedicareLookup 
	ON MedicareLookupSurveyType.MedicareNumber = MedicareLookup.MedicareNumber
	WHERE MedicareLookupSurveyType.MedicareNumber=@MedicareNumber
	AND MedicareLookupSurveyType.SurveyType_ID=@surveyType_ID
	
	SET NOCOUNT OFF      
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END
GO

PRINT 'Create stored procedure QCL_DeleteMedicareLookupSurveyType'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_DeleteMedicareLookupSurveyType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_DeleteMedicareLookupSurveyType]
GO
CREATE PROCEDURE [dbo].[QCL_DeleteMedicareLookupSurveyType]
 @MedicareNumber	VARCHAR(20), 
 @surveyType_ID			INT
AS
BEGIN
	IF EXISTS (SELECT * FROM SUFacility WHERE MedicareNumber=@MedicareNumber)
	BEGIN
	 RAISERROR ('MedicareNumber is associated with a facility.',18,1)
	 RETURN
	END

	DELETE MedicareLookupSurveyType WHERE MedicareNumber=@MedicareNumber AND SurveyType_ID=@surveyType_ID

END
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

PRINT 'Create stored procedure QCL_InsertMedicareRecalcSurveyType_History'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_InsertMedicareRecalcSurveyType_History]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_InsertMedicareRecalcSurveyType_History]
GO
CREATE PROCEDURE [dbo].[QCL_InsertMedicareRecalcSurveyType_History]
@SurveyType_ID						INT,
@MedicareNumber					VARCHAR(20),
@MedicarePropCalcType_ID INT,
@MedicarePropDataType_ID INT,
@EstRespRate							DECIMAL(8,4),
@EstAnnualVolume					INT,
@SwitchToCalcDate					DATETIME,
@AnnualReturnTarget				INT,
@ProportionCalcPct				DECIMAL(8,4),
@SamplingLocked					TINYINT,
@ProportionChangeThreshold DECIMAL(8,4),
@Member_ID							INT,
@DateCalculated						DATETIME,
@HistoricRespRate					DECIMAL(8,4),
@HistoricAnnualVolume			INT, 
@ForcedCalculation				TINYINT,
@PropSampleCalcDate			DATETIME,
@SwitchFromRateOverrideDate	DATETIME,
@SamplingRateOverride		DECIMAL(8,4)
AS
BEGIN
	SET NOCOUNT ON
	
	INSERT INTO [dbo].[MedicareRecalcSurveyType_History]
			   (SurveyType_ID, MedicareNumber, MedicarePropCalcType_ID, MedicarePropDataType_ID, EstRespRate, EstAnnualVolume, SwitchToCalcDate
			   , AnnualReturnTarget, ProportionCalcPct, SamplingLocked, ProportionChangeThreshold, Member_ID, DateCalculated, HistoricRespRate, HistoricAnnualVolume
			   , ForcedCalculation, PropSampleCalcDate, SwitchFromRateOverrideDate, SamplingRateOverride)
		 VALUES
			   (@SurveyType_ID, @MedicareNumber, @MedicarePropCalcType_ID, @MedicarePropDataType_ID, @EstRespRate, @EstAnnualVolume, @SwitchToCalcDate
			   , @AnnualReturnTarget, @ProportionCalcPct, @SamplingLocked, @ProportionChangeThreshold, @Member_ID, @DateCalculated, @HistoricRespRate, @HistoricAnnualVolume
			   , @ForcedCalculation, @PropSampleCalcDate, @SwitchFromRateOverrideDate, @SamplingRateOverride)

	SELECT SCOPE_IDENTITY()

	SET NOCOUNT OFF
END
GO

PRINT 'Create stored procedure QCL_SelectMedicareRecalcSurveyType_History'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectMedicareRecalcSurveyType_History]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectMedicareRecalcSurveyType_History]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMedicareRecalcSurveyType_History]
@MedicareReCalcLog_ID INT
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT history.SurveyType_ID, history.MedicareNumber, history.MedicarePropCalcType_ID, history.MedicarePropDataType_ID, history.EstRespRate, 
			history.EstAnnualVolume, history.SwitchToCalcDate, history.AnnualReturnTarget, history.ProportionCalcPct, history.SamplingLocked, 
			history.ProportionChangeThreshold, history.Member_ID, history.DateCalculated, history.HistoricRespRate, history.HistoricAnnualVolume, 
			history.ForcedCalculation, history.PropSampleCalcDate, history.SwitchFromRateOverrideDate, history.SamplingRateOverride
	FROM MedicareRecalcSurveyType_History AS history
	INNER JOIN MedicareLookup AS ML ON history.MedicareNumber = ML.MedicareNumber
	WHERE history.MedicareReCalcLog_ID = @MedicareReCalcLog_ID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF
END
GO


PRINT 'End stored procedure changes'
GO

