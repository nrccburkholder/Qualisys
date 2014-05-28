CREATE PROCEDURE [dbo].[QSL_UpdateQuestionResult]
@DL_QuestionResult_ID INT,
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@QstnCore INT,
@ResponseVal CHAR(5),
@MultipleResponse BIT,
@DateCreated DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].DL_QuestionResults SET
    DL_LithoCode_ID = @DL_LithoCode_ID,
    DL_Error_ID = @DL_Error_ID,
    QstnCore = @QstnCore,
    ResponseVal = @ResponseVal,
    MultipleResponse = @MultipleResponse,
    DateCreated = @DateCreated
WHERE DL_QuestionResult_ID = @DL_QuestionResult_ID

SET NOCOUNT OFF


