CREATE PROCEDURE [dbo].[QCL_SelectQuestionnaireTypes] 
@surveytypeid int,
@questionnairetypeid int 
AS

IF @questionnairetypeid = 0 
BEGIN
	SELECT SurveyType_ID, QuestionnaireType_id , [Description]
	FROM QuestionnaireTypes
	WHERE SurveyType_ID = @surveytypeid
END
ELSE
BEGIN

	SELECT SurveyType_ID, QuestionnaireType_id , [Description]
	FROM QuestionnaireTypes
	WHERE QuestionnaireType_ID = @questionnairetypeid
END



