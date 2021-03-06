USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_UpdateSurvey]    Script Date: 9/17/2014 4:25:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	@SurveySubType_id		   INT = NULL,
	@QuestionnaireType_ID	   INT = NULL
AS
BEGIN    
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
	SurveySubType_ID = @SurveySubType_id,
	QuestionnaireType_ID = @QuestionnaireType_ID
WHERE Survey_id = @Survey_id
END
