/*
	    RTP-2395 Sampling - re-survey exclusion rule.sql

		Chris Burkholder

		5/30/2017

		ADD COLUMN to SURVEY_DEF, Survey_DefTemplate
		ALTER QCL_SelectSurvey
		ALTER QCL_SelectSurveysByStudyId
		ALTER QCL_SelectSurveysBySurveyTypeMailOnly
		ALTER QCL_UpdateSurvey
		ALTER QCL_InsertSurvey

		select t.name,c.name,* from sys.columns c inner join sys.tables t on c.object_id = t.object_id where c.name like '%resurvey%'
*/

use qp_prod
go

if not exists(select * from sys.columns where name = 'LocationProviderResurveyDays'
			and object_id = object_id('dbo.survey_def'))
	alter table dbo.survey_def add LocationProviderResurveyDays int

if not exists(select * from sys.columns where name = 'LocationProviderResurveyDays'
			and object_id = object_id('rtphoenix.survey_defTemplate'))
	alter table rtphoenix.survey_defTemplate add LocationProviderResurveyDays int

GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[QCL_SelectSurvey]
    @SurveyId INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      
DECLARE @intSamplePlan_id int

SELECT @intSamplePlan_id = SamplePlan_id     
FROM dbo.SamplePlan    
WHERE Survey_id = @Surveyid 
    
SELECT Survey_id, strSurvey_Nm, strSurvey_Dsc, Study_id, strCutoffResponse_Cd, CutoffTable_id, 
       CutoffField_id, SampleEncounterTable_id, SampleEncounterField_id, bitValidated_Flg,
       datValidated, bitFormGenRelease, @intSamplePlan_id as SamplePlan_id, intResponse_Recalc_Period,  
       intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, bitEnforceSkip,
       strClientFacingName, SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, strHouseholdingType,  
	   Contract, Active, ContractedLanguages, UseUSPSAddrChangeService, IsHandout, IsPointInTime,
	   LocationProviderResurveyDays
FROM Survey_Def 
WHERE Survey_id = @SurveyId 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF


GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[QCL_SelectSurveysByStudyId]
    @StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT sd.Survey_id, sd.strSurvey_Nm, sd.strSurvey_Dsc, sd.Study_id, sd.strCutoffResponse_Cd, 
       sd.CutoffTable_id, sd.CutoffField_id, sd.SampleEncounterTable_id, sd.SampleEncounterField_id, 
       sd.bitValidated_Flg, sd.datValidated, sd.bitFormGenRelease, sp.SamplePlan_id, 
       sd.intResponse_Recalc_Period, sd.intResurvey_Period, sd.datSurvey_Start_Dt, sd.datSurvey_End_Dt,
       sd.SamplingAlgorithmID, sd.bitEnforceSkip, sd.strClientFacingName, sd.SurveyType_id,
       sd.SurveyTypeDef_id, sd.ReSurveyMethod_id, sd.strHouseholdingType, sd.Contract, sd.Active, 
       sd.ContractedLanguages, sd.UseUSPSAddrChangeService, sd.IsHandout, sd.IsPointInTime,
	   sd.LocationProviderResurveyDays
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id = @StudyId
  AND sd.survey_id = sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[QCL_SelectSurveysBySurveyTypeMailOnly]
    @SurveyType_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT distinct sd.Survey_id, sd.strSurvey_Nm, sd.strSurvey_Dsc, sd.Study_id, sd.strCutoffResponse_Cd, 
       sd.CutoffTable_id, sd.CutoffField_id, sd.SampleEncounterTable_id, sd.SampleEncounterField_id, 
       sd.bitValidated_Flg, sd.datValidated, sd.bitFormGenRelease, sp.SamplePlan_id, 
       sd.intResponse_Recalc_Period, sd.intResurvey_Period, sd.datSurvey_Start_Dt, sd.datSurvey_End_Dt,
       sd.SamplingAlgorithmID, sd.bitEnforceSkip, sd.strClientFacingName, sd.SurveyType_id,
       sd.SurveyTypeDef_id, sd.ReSurveyMethod_id, sd.strHouseholdingType, sd.Contract, sd.Active, 
       sd.ContractedLanguages, sd.UseUSPSAddrChangeService, sd.IsHandout, IsPointInTime,
	   sd.LocationProviderResurveyDays
FROM Client cl, Study st, Survey_Def sd, SamplePlan sp, MailingMethodology ma, MailingStep ms, MailingStepMethod mm
WHERE cl.Client_id = st.Client_id
  AND st.Study_id = sd.Study_id
  AND sd.survey_id = sp.survey_id
  AND sd.Survey_id = ma.Survey_id
  AND ma.bitActiveMethodology = 1
  AND ma.Survey_id = ms.Survey_id
  AND ma.Methodology_id = ms.Methodology_id
  AND ms.MailingStepMethod_id = mm.MailingStepMethod_id
  and ms.bitSendSurvey = 1
  AND mm.IsNonMailGeneration = 0
  AND sd.SurveyType_id = @SurveyType_id
  AND cl.Active = 1
  AND st.Active = 1
  AND sd.Active = 1

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[QCL_UpdateSurvey]    
    @Survey_id                 INT,    
    @strSurvey_Nm              VARCHAR(10),    
    @strSurvey_Dsc             VARCHAR(40),    
    @intResponse_Recalc_Period INT,    
    @intResurvey_Period        INT,    
    @ReSurveyMethod_id         INT,    
    @datSurvey_Start_Dt        DATETIME,    
    @datSurvey_End_Dt          DATETIME,    
    @SamplingAlgorithm         INT,    
    @bitEnforceSkip            BIT,    
    @strCutoffResponse_Cd      CHAR(1),    
    @CutoffTable_id            INT,    
    @CutoffField_id            INT,  
    @SampleEncounterTable_id   INT,  
    @SampleEncounterField_id   INT,  
    @strClientFacingName       VARCHAR(42),    
    @SurveyType_id             INT,    
    @SurveyTypeDef_id          INT,  
    @HouseHoldingType          CHAR(1),  
    @IsValidated               BIT,  
    @datValidated              DATETIME,  
    @IsFormGenReleased         BIT,
    @Contract                  VARCHAR(9) = NULL,
    @Active                    BIT, 
    @ContractedLanguages       VARCHAR(50),
    @UseUSPSAddrChangeService   BIT,
	@IsHandout                  BIT,
	@IsPointInTime              BIT,
	@LocationProviderResurveyDays INT
AS
    
UPDATE Survey_Def    
SET strSurvey_Nm = @strSurvey_Nm,  
    strSurvey_Dsc = @strSurvey_Dsc,     
    intResponse_Recalc_Period = @intResponse_Recalc_Period,  
    intResurvey_Period = @intResurvey_Period,     
    datSurvey_Start_Dt = @datSurvey_Start_Dt,  
    datSurvey_End_Dt = @datSurvey_End_Dt,     
    SamplingAlgorithmID = @SamplingAlgorithm,  
    bitEnforceSkip = @bitEnforceSkip,     
    strCutoffResponse_Cd = @strCutoffResponse_Cd,  
    CutoffTable_id = @CutoffTable_id,     
    CutoffField_id = @CutoffField_id,  
    SampleEncounterTable_id = @SampleEncounterTable_id,  
    SampleEncounterField_id = @SampleEncounterField_id,  
    strClientFacingName = @strClientFacingName,     
    SurveyType_id = @SurveyType_id,  
    SurveyTypeDef_id = @SurveyTypeDef_id,    
    ReSurveyMethod_id = @ReSurveyMethod_id,  
    bitDynamic = CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END,  
    strHouseholdingType = @HouseHoldingType,  
    bitValidated_Flg = @IsValidated,  
    datValidated = @datValidated,  
    bitFormGenRelease = @IsFormGenReleased,
    Contract = @Contract,
    Active = @Active, 
    ContractedLanguages = @ContractedLanguages,
    UseUSPSAddrChangeService = @UseUSPSAddrChangeService,
	IsHandout = @IsHandout,
	IsPointInTime = @IsPointInTime,
	LocationProviderResurveyDays = @LocationProviderResurveyDays
WHERE Survey_id = @Survey_id



GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[QCL_InsertSurvey]
    @Study_id                  INT,        
    @strSurvey_nm              VARCHAR(10),        
    @strSurvey_dsc             VARCHAR(40),        
    @intResponse_Recalc_Period INT,        
    @intResurvey_Period        INT,        
    @ReSurveyMethod_id         INT,  
    @datSurvey_Start_dt        DATETIME,        
    @datSurvey_End_dt          DATETIME,        
    @SamplingAlgorithm         INT,        
    @bitEnforceSkip            BIT,        
    @strCutoffResponse_cd      CHAR(1),        
    @CutoffTable_id            INT,        
    @CutoffField_id            INT,        
    @SampleEncounterTable_id   INT,  
    @SampleEncounterField_id   INT,  
    @strClientFacingName       VARCHAR(42),        
    @SurveyType_id             INT,        
    @SurveyTypeDef_id          INT,        
    @HouseHoldingType          CHAR(1),
    @Contract                  VARCHAR(9) = NULL,
    @Active                    BIT, 
    @ContractedLanguages       VARCHAR(50),
    @UseUSPSAddrChangeService  BIT,
	@IsHandout                 BIT,
	@IsPointInTime             BIT,
	@LocationProviderResurveyDays INT
AS

INSERT INTO Survey_Def (Study_id, strSurvey_Nm, strSurvey_Dsc, intResponse_Recalc_Period,         
                        intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, 
                        bitEnforceSkip, strCutoffResponse_Cd, CutoffTable_id, CutoffField_id, 
                        SampleEncounterTable_id, SampleEncounterField_id, strClientFacingName, 
                        SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, bitDynamic, 
                        strHouseholdingType, Contract, Active, ContractedLanguages, UseUSPSAddrChangeService,
						IsHandout, IsPointInTime, LocationProviderResurveyDays) 
VALUES (@Study_id, @strSurvey_Nm, @strSurvey_Dsc, @intResponse_Recalc_Period, @intResurvey_Period,  
        @datSurvey_Start_Dt, @datSurvey_End_Dt, @SamplingAlgorithm, @bitEnforceSkip, @strCutoffResponse_Cd, 
        @CutoffTable_id, @CutoffField_id, @SampleEncounterTable_id, @SampleEncounterField_id, 
        @strClientFacingName, @SurveyType_id, @SurveyTypeDef_id, @ReSurveyMethod_id, 
        CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END, @HouseHoldingType, @Contract, @Active, 
        @ContractedLanguages, @UseUSPSAddrChangeService, @IsHandout, @IsPointInTime,
		@LocationProviderResurveyDays)

SELECT SCOPE_IDENTITY()

go