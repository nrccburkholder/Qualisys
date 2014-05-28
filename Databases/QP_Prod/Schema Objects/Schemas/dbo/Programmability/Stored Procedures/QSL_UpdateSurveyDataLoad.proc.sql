CREATE PROCEDURE [dbo].[QSL_UpdateSurveyDataLoad]
@SurveyDataLoad_ID INT,
@DataLoad_ID INT,
@Survey_ID INT,
@DateCreated DATETIME,
@Notes VARCHAR(8000),
@bitHasErrors BIT
AS

SET NOCOUNT ON

UPDATE [dbo].DL_SurveyDataLoad SET
	DataLoad_ID = @DataLoad_ID,
	Survey_ID = @Survey_ID,
	DateCreated = @DateCreated,
	Notes = @Notes,
	bitHasErrors = @bitHasErrors
WHERE SurveyDataLoad_ID = @SurveyDataLoad_ID

SET NOCOUNT OFF


