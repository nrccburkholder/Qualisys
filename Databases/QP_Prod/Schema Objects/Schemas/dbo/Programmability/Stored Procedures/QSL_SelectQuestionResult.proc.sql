CREATE PROCEDURE [dbo].[QSL_SelectQuestionResult]
@DL_QuestionResult_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_QuestionResult_ID, DL_LithoCode_ID, DL_Error_ID, QstnCore, ResponseVal, MultipleResponse, DateCreated
FROM [dbo].DL_QuestionResults
WHERE DL_QuestionResult_ID = @DL_QuestionResult_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


