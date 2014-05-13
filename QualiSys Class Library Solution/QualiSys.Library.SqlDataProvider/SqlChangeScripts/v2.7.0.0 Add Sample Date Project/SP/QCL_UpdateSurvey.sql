IF (ObjectProperty(Object_Id('dbo.QCL_UpdateSurvey'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_UpdateSurvey
GO

/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It updates the   
contents of the survey_def table for the given survey_id  
  
Created:  02/27/2006 by Brian Dohmen  
Modified:    
03/27/2006 by DC - Added code to populate bitDynamic and householding type    
09/26/2006 by Brian Mao - Added code to populate SampleEncounterTable_ID and SampleEncounterField_ID
*/      
CREATE PROCEDURE [dbo].[QCL_UpdateSurvey]  
        @Survey_id INT,  
        @strSurvey_nm VARCHAR(10),  
        @strSurvey_dsc VARCHAR(40),  
        @intResponse_Recalc_Period INT,  
        @intResurvey_Period INT,  
        @ReSurveyMethod_id INT,  
        @datSurvey_Start_dt DATETIME,  
        @datSurvey_End_dt DATETIME,  
        @SamplingAlgorithm INT,  
        @bitEnforceSkip BIT,  
        @strCutoffResponse_cd CHAR(1),  
        @CutoffTable_id INT,  
        @CutoffField_id INT,
        @SampleEncounterTable_id INT,
        @SampleEncounterField_id INT,
        @strClientFacingName VARCHAR(42),  
        @SurveyType_id INT,  
        @SurveyTypeDef_id INT,
        @datHCAHPSReportable DATETIME,  
        @HouseHoldingType CHAR(1),
        @IsValidated BIT,
        @datValidated DATETIME,
        @IsFormGenReleased BIT 
AS  
  
UPDATE Survey_def  
   SET strSurvey_nm = @strSurvey_nm,
       strSurvey_dsc = @strSurvey_dsc,   
       intResponse_Recalc_Period = @intResponse_Recalc_Period,
       intResurvey_Period = @intResurvey_Period,   
       datSurvey_Start_dt = @datSurvey_Start_dt,
       datSurvey_End_dt = @datSurvey_End_dt,   
       SamplingAlgorithmID = @SamplingAlgorithm,
       bitEnforceSkip = @bitEnforceSkip,   
       strCutoffResponse_cd = @strCutoffResponse_cd,
       CutoffTable_id = @CutoffTable_id,   
       CutoffField_id = @CutoffField_id,
       SampleEncounterTable_id = @SampleEncounterTable_id,
       SampleEncounterField_id = @SampleEncounterField_id,
       strClientFacingName = @strClientFacingName,   
       SurveyType_id = @SurveyType_id,
       SurveyTypeDef_id = @SurveyTypeDef_id,  
       datHCAHPSReportable = @datHCAHPSReportable,
       ReSurveyMethod_id = @ReSurveyMethod_id,
       bitDynamic = case 
                      When @SamplingAlgorithm = 2 then 1 
		     		  else 0 
			          end,
       strHouseholdingType = @HouseHoldingType,
       bitValidated_flg = @IsValidated,
       datValidated = @datValidated,
       bitFormGenRelease = @IsFormGenReleased 
 WHERE Survey_id = @Survey_id  


GO
