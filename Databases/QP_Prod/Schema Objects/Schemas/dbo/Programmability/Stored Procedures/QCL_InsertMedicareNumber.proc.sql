CREATE PROCEDURE [dbo].[QCL_InsertMedicareNumber]  
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
    @Active bit 
AS  
  
IF EXISTS (SELECT * FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber)  
BEGIN  
    RAISERROR ('MedicareNumber already exists.',18,1)  
    RETURN  
END  
  
INSERT INTO MedicareLookup (MedicareNumber, MedicareName, MedicarePropCalcType_ID, 
                            EstAnnualVolume, EstRespRate, EstIneligibleRate, 
                            SwitchToCalcDate, AnnualReturnTarget, SamplingLocked,
                            ProportionChangeThreshold, CensusForced, PENumber, Active)  
SELECT @MedicareNumber, @MedicareName, @MedicarePropCalcType_ID, @EstAnnualVolume,
       @EstRespRate, @EstIneligibleRate, @SwitchToCalcDate, @AnnualReturnTarget, 
       @SamplingLocked, @ProportionChangeThreshold, @CensusForced, @PENumber, @Active

SELECT @MedicareNumber


