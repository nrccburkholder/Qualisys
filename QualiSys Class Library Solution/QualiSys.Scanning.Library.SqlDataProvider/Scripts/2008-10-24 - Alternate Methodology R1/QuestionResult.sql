---------------------------------------------------------------------------------------
--QSL_SelectQuestionResult
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectQuestionResult]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectQuestionResult]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllQuestionResults
--Not used.  Drop if exists.
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllQuestionResults]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectAllQuestionResults]
GO
---------------------------------------------------------------------------------------
--QSL_SelectQuestionResultsByLithoCode_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectQuestionResultsByLithoCodeId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectQuestionResultsByLithoCodeId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectQuestionResultsByLithoCodeId]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_QuestionResult_ID, DL_LithoCode_ID, DL_Error_ID, QstnCore, ResponseVal, MultipleResponse, DateCreated
FROM DL_QuestionResults
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectQuestionResultsByError_ID
--Not used.  Drop if exists.
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectQuestionResultsByErrorId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectQuestionResultsByErrorId]
GO
---------------------------------------------------------------------------------------
--QSL_InsertQuestionResult
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertQuestionResult]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_InsertQuestionResult]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_UpdateQuestionResult
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateQuestionResult]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_UpdateQuestionResult]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_DeleteQuestionResult
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteQuestionResult]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_DeleteQuestionResult]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteQuestionResult]
@DL_QuestionResult_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_QuestionResults
WHERE DL_QuestionResult_ID = @DL_QuestionResult_ID

SET NOCOUNT OFF
GO

