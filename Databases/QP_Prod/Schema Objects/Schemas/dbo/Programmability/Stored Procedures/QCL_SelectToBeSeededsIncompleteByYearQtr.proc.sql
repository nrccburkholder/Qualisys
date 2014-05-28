CREATE PROCEDURE [dbo].[QCL_SelectToBeSeededsIncompleteByYearQtr]
    @YearQtr VARCHAR(6)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Seed_id, Survey_id, IsSeeded, datSeeded, SurveyType_id, YearQtr
FROM [dbo].ToBeSeeded
WHERE YearQtr = @YearQtr
  AND IsSeeded = 0
ORDER BY SurveyType_id, Survey_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


