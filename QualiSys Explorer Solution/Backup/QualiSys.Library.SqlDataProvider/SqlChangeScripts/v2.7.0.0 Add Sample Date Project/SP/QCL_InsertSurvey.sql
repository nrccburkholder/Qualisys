IF (ObjectProperty(Object_Id('dbo.QCL_InsertSurvey'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_InsertSurvey
GO

/*      
Business Purpose:       
      
This procedure is used to support the Qualisys Class Library.  It adds a new survey      
to the survey_def table.  It returns the Survey_id back to the app.      
      
Created:  02/27/2006 by Brian Dohmen      
      
Modified:    
03/27/2006 by DC - Added code to populate bitDynamic and householding type
09/26/2006 by Brian Mao - Added code to populate SampleEncounterTable_ID and SampleEncounterField_ID
*/          
CREATE PROCEDURE [dbo].[QCL_InsertSurvey]      
        @Study_id INT,      
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
        @HouseHoldingType char(1)        
AS      
      
INSERT INTO Survey_def (
        Study_id,
        strSurvey_nm,
        strSurvey_dsc,
        intResponse_Recalc_Period,       
        intResurvey_Period,
        datSurvey_Start_dt,
        datSurvey_End_dt,
        SamplingAlgorithmID,
        bitEnforceSkip,       
        strCutoffResponse_cd,
        CutoffTable_id,
        CutoffField_id,
        SampleEncounterTable_ID,
        SampleEncounterField_ID,
        strClientFacingName,       
        SurveyType_id,
        SurveyTypeDef_id,
        datHCAHPSReportable,
        ReSurveyMethod_id,
        bitDynamic,
        strHouseholdingType
       )
VALUES (
        @Study_id,
        @strSurvey_nm,
        @strSurvey_dsc,
        @intResponse_Recalc_Period,       
        @intResurvey_Period,
        @datSurvey_Start_dt,
        @datSurvey_End_dt,
        @SamplingAlgorithm,       
        @bitEnforceSkip,
        @strCutoffResponse_cd,
        @CutoffTable_id,
        @CutoffField_id,
        @SampleEncounterTable_ID,
        @SampleEncounterField_ID,
        @strClientFacingName,       
        @SurveyType_id,
        @SurveyTypeDef_id,
        @datHCAHPSReportable,
        @ReSurveyMethod_id,
        case 
	      When @SamplingAlgorithm=2 then 1 
	      else 0 
          end,
        @HouseHoldingType
       )

SELECT SCOPE_IDENTITY()      

GO
