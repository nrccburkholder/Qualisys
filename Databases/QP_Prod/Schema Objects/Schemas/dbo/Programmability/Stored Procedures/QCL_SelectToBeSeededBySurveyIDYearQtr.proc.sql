CREATE PROCEDURE [dbo].[QCL_SelectToBeSeededBySurveyIDYearQtr]
    @Survey_id INT, 
    @YearQtr   VARCHAR(6)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Seed_id, Survey_id, IsSeeded, datSeeded, SurveyType_id, YearQtr
FROM [dbo].ToBeSeeded
WHERE Survey_id = @Survey_id
  AND YearQtr = @YearQtr

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


