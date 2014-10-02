CREATE PROCEDURE [dbo].[QCL_UpdateSurveyType]
    @SurveyType_ID     INT,
    @SurveyType_dsc    VARCHAR(100),
    @CAHPSType_id      INT,
    @SeedMailings      BIT,
    @SeedSurveyPercent INT,
    @SeedUnitField     VARCHAR(42)
AS

SET NOCOUNT ON

UPDATE [dbo].SurveyType 
SET SurveyType_dsc = @SurveyType_dsc,
    CAHPSType_id = @CAHPSType_id,
    SeedMailings = @SeedMailings,
    SeedSurveyPercent = @SeedSurveyPercent,
    SeedUnitField = @SeedUnitField
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF
