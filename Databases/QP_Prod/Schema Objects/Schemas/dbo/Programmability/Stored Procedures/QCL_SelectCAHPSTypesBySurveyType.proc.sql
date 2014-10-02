CREATE PROCEDURE QCL_SelectSurveyTypes 
AS
SELECT SurveyType_id, SurveyType_dsc
FROM SurveyType (NOLOCK)


