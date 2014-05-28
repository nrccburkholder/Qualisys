CREATE PROCEDURE [dbo].[QSL_InsertSurveyDataLoad]
@DataLoad_ID INT,
@Survey_ID INT,
@DateCreated DATETIME,
@Notes VARCHAR(8000),
@bitHasErrors BIT
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_SurveyDataLoad (DataLoad_ID, Survey_ID, DateCreated, Notes, bitHasErrors)
VALUES (@DataLoad_ID, @Survey_ID, @DateCreated, @Notes, @bitHasErrors)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


