CREATE PROCEDURE [dbo].[QCL_InsertSurvey]        
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
	@SurveySubType_ID		   INT = NULL,
	@QuestionnaireType_ID	   INT = NULL
AS

INSERT INTO Survey_Def (Study_id, strSurvey_Nm, strSurvey_Dsc, intResponse_Recalc_Period,         
                        intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, 
                        bitEnforceSkip, strCutoffResponse_Cd, CutoffTable_id, CutoffField_id, 
                        SampleEncounterTable_id, SampleEncounterField_id, strClientFacingName, 
                        SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, bitDynamic, 
                        strHouseholdingType, Contract, Active, ContractedLanguages, SurveySubType_ID, QuestionnaireType_ID) 
VALUES (@Study_id, @strSurvey_Nm, @strSurvey_Dsc, @intResponse_Recalc_Period, @intResurvey_Period,  
        @datSurvey_Start_Dt, @datSurvey_End_Dt, @SamplingAlgorithm, @bitEnforceSkip, @strCutoffResponse_Cd, 
        @CutoffTable_id, @CutoffField_id, @SampleEncounterTable_id, @SampleEncounterField_id, 
        @strClientFacingName, @SurveyType_id, @SurveyTypeDef_id, @ReSurveyMethod_id, 
        CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END, @HouseHoldingType, @Contract, @Active, 
        @ContractedLanguages, @SurveySubType_ID, @QuestionnaireType_ID)

SELECT SCOPE_IDENTITY()




