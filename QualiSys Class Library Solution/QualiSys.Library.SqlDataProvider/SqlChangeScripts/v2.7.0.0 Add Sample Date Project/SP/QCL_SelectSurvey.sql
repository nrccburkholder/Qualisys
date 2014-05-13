IF (ObjectProperty(Object_Id('dbo.QCL_SelectSurvey'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_SelectSurvey
GO

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It returns a single    
record representing survey data for the ID specified    
    
Created:  10/17/2005 by Joe Camp    
    
Modified:    
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection    
02/16/2006 by DC - Added bitValidated_flg to survey selection    
02/23/2006 by DC - Added samplePlanId to survey selection    
02/24/2006 by DC - Added INTRESPONSE_RECALC_PERIOD to survey selection    
02/27/2006 by Brian Dohmen - Added additional columns to survey selection    
03/27/2006 by DC - Added strHouseholdingType to survey selection
09/26/2006 by Brian Mao - Add SampleEncounterTable_ID and SampleEncounterField_ID to survey selection
*/        
CREATE PROCEDURE [dbo].[QCL_SelectSurvey]      
        @SurveyId INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      
DECLARE @intSamplePlan_id int    
 SELECT @intSamplePlan_id = SamplePlan_id     
   FROM dbo.SamplePlan    
  WHERE Survey_id = @Surveyid    
    
SELECT Survey_id,
       strSurvey_nm,
       strSurvey_dsc,
       Study_id, 
       strCutoffResponse_cd,
       CutoffTable_id,
       CutoffField_id,
       SampleEncounterTable_ID,
       SampleEncounterField_ID,
       bitValidated_flg,
       datValidated,
       bitFormGenRelease, 
       @intSamplePlan_id as SamplePlan_id,
       INTRESPONSE_RECALC_PERIOD,  
       intResurvey_Period,
       datSurvey_Start_dt,
       datSurvey_End_dt,
       SamplingAlgorithmID,   
       bitEnforceSkip,
       strClientFacingName,
       SurveyType_id,
       SurveyTypeDef_id,
       datHCAHPSReportable,
       ReSurveyMethod_id,
       strHouseholdingType  
  FROM Survey_Def       
 WHERE Survey_id = @SurveyId      
          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF     

GO
