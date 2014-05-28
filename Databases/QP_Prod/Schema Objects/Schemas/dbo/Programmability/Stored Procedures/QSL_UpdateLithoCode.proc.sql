CREATE PROCEDURE [dbo].[QSL_UpdateLithoCode]
@DL_LithoCode_ID INT,
@SurveyDataLoad_ID INT,
@DL_Error_ID INT,
@TranslationCode VARCHAR(10), 
@strLithoCode VARCHAR(50),
@bitIgnore BIT,
@bitSubmitted BIT,
@bitExtracted BIT,
@bitSkipDuplicate BIT,
@bitDispositionUpdate BIT,
@DateCreated DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].DL_LithoCodes SET
    SurveyDataLoad_ID = @SurveyDataLoad_ID,
    DL_Error_ID = @DL_Error_ID,
    TranslationCode = @TranslationCode, 
    strLithoCode = @strLithoCode,
    bitIgnore = @bitIgnore,
    bitSubmitted = @bitSubmitted,
    bitExtracted = @bitExtracted,
    bitSkipDuplicate = @bitSkipDuplicate,
    bitDispositionUpdate = @bitDispositionUpdate,
    DateCreated = @DateCreated
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF


