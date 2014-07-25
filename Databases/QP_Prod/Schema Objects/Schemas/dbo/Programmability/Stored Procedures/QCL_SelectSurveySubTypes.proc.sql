
CREATE PROCEDURE [dbo].[QCL_SelectSurveySubTypes] 
@surveytypeid int 
AS
SELECT SurveySubType_id, SurveyType_ID, SubType_NM , QuestionnaireType_ID
FROM SurveySubTypes
WHERE SurveyType_ID = @surveytypeid



