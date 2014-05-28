CREATE PROCEDURE [dbo].[QCL_DeleteSurveyType]
    @SurveyType_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].SurveyType
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF


