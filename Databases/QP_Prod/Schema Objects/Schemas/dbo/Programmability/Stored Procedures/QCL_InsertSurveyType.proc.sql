CREATE PROCEDURE [dbo].[QCL_InsertSurveyType]
    @SurveyType_dsc    VARCHAR(100),
    @CAHPSType_id     INT,
    @SeedMailings      BIT,
    @SeedSurveyPercent INT,
    @SeedUnitField     VARCHAR(42)
AS

SET NOCOUNT ON

INSERT INTO [dbo].SurveyType (SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField)
VALUES (@SurveyType_dsc, @CAHPSType_id, @SeedMailings, @SeedSurveyPercent, @SeedUnitField)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


