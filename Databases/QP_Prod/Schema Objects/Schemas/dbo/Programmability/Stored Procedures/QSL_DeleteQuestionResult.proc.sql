CREATE PROCEDURE [dbo].[QSL_DeleteQuestionResult]
@DL_QuestionResult_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_QuestionResults
WHERE DL_QuestionResult_ID = @DL_QuestionResult_ID

SET NOCOUNT OFF


