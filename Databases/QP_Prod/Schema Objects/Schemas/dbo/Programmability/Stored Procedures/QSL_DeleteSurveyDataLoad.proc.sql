CREATE PROCEDURE [dbo].[QSL_DeleteSurveyDataLoad]
@SurveyDataLoad_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_SurveyDataLoad
WHERE SurveyDataLoad_ID = @SurveyDataLoad_ID

SET NOCOUNT OFF


