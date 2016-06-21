ALTER PROCEDURE [dbo].[QCL_SelectAllSurveyTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField--, CAHPSType_id as OptionType_id -- <--added to repair Seeded Mailing Service (to be removed) CJB 7/25/2014 OptionType_id was removed 8/21/2014
FROM [dbo].SurveyType

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED