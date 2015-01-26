IF (ObjectProperty(Object_Id('dbo.QCL_SelectSurveysByStudyId'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_SelectSurveysByStudyId
GO

/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It returns a set of
records representing survey data for the ID specified

Created:  2/20/2006 by Dan Christensen

Modified:
03/27/2006 by DC - Added strHouseholdingType to survey selection
09/26/2006 by Brian Mao - Add SampleEncounterTable_ID and SampleEncounterField_ID to survey selection
*/
CREATE PROCEDURE dbo.QCL_SelectSurveysByStudyId
        @StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT sd.Survey_id,
       sd.strSurvey_nm,
       sd.strSurvey_dsc,
       sd.Study_id,
       sd.strCutoffResponse_cd,
       sd.CutoffTable_id,
       sd.CutoffField_id,
       sd.SampleEncounterTable_ID,
       sd.SampleEncounterField_ID,
       sd.bitValidated_flg,
       sd.datValidated,
       sd.bitFormGenRelease,
       sp.SamplePlan_id,
       sd.INTRESPONSE_RECALC_PERIOD,
       sd.intResurvey_Period,
       sd.datSurvey_Start_dt,
       sd.datSurvey_End_dt,
       sd.SamplingAlgorithmID,
       sd.bitEnforceSkip,
       sd.strClientFacingName,
       sd.SurveyType_id,
       sd.SurveyTypeDef_id,
       sd.datHCAHPSReportable,
       sd.ReSurveyMethod_id,
       sd.strHouseholdingType
  FROM Survey_Def sd,
       SamplePlan sp
 WHERE sd.Study_id=@StudyId
   AND sd.survey_id=sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
