﻿CREATE PROCEDURE [dbo].[QCL_SelectToBeSeeded]
    @Seed_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Seed_id, Survey_id, IsSeeded, datSeeded, SurveyType_id, YearQtr
FROM [dbo].ToBeSeeded
WHERE Seed_id = @Seed_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


