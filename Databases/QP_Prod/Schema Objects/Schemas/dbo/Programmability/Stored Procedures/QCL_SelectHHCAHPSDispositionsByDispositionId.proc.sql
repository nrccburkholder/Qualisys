﻿CREATE PROCEDURE [dbo].[QCL_SelectHHCAHPSDispositionsByDispositionId]
@Disposition_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT HHCAHPSDispositionID, Disposition_ID, HHCAHPSValue, HHCAHPSHierarchy, HHCAHPSDesc
FROM HHCAHPSDispositions
WHERE Disposition_ID = @Disposition_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


