﻿CREATE PROCEDURE [dbo].[QCL_SelectSurveyType]
    @SurveyType_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, OptionType_id, SeedMailings, SeedSurveyPercent, SeedUnitField
FROM [dbo].SurveyType
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


