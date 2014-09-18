USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurvey]    Script Date: 8/18/2014 8:56:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_SelectSurvey]
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
	   Contract, Active, ContractedLanguages, UseUSPSAddrChangeService
FROM Survey_Def 
WHERE Survey_id = @SurveyId 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF

GO


