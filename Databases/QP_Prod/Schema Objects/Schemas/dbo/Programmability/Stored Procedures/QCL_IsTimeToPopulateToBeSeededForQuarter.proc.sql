﻿CREATE PROCEDURE [dbo].[QCL_IsTimeToPopulateToBeSeededForQuarter]
    @YearQtr VARCHAR(6)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Count(*) 
FROM [dbo].ToBeSeeded
WHERE YearQtr = @YearQtr

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


