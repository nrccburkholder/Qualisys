CREATE PROCEDURE [dbo].[QCL_UpdateMedicareNumber]  
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
    @Active bit
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
    Active = @Active
WHERE MedicareNumber = @MedicareNumber


