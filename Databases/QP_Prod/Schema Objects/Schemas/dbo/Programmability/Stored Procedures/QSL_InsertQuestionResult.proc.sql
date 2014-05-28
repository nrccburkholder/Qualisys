CREATE PROCEDURE [dbo].[QSL_InsertQuestionResult]
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@QstnCore INT,
@ResponseVal CHAR(5),
@MultipleResponse BIT,
@DateCreated DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_QuestionResults (DL_LithoCode_ID, DL_Error_ID, QstnCore, ResponseVal, MultipleResponse, DateCreated)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @QstnCore, @ResponseVal, @MultipleResponse, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


