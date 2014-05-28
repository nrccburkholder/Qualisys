CREATE PROCEDURE [dbo].[QSL_InsertLithoCode]
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

INSERT INTO [dbo].DL_LithoCodes (SurveyDataLoad_ID, DL_Error_ID, TranslationCode, strLithoCode, bitIgnore, bitSubmitted, bitExtracted, bitSkipDuplicate, bitDispositionUpdate, DateCreated)
VALUES (@SurveyDataLoad_ID, @DL_Error_ID, @TranslationCode, @strLithoCode, @bitIgnore, @bitSubmitted, @bitExtracted, @bitSkipDuplicate, @bitDispositionUpdate, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


