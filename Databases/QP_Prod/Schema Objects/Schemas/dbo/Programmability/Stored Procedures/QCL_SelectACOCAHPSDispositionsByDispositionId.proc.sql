﻿CREATE PROCEDURE [dbo].[QCL_SelectACOCAHPSDispositionsByDispositionId]
@Disposition_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT ACOCAHPSDispositionID, Disposition_ID, ACOCAHPSValue, ACOCAHPSHierarchy, ACOCAHPSDesc
FROM ACOCAHPSDispositions
WHERE Disposition_ID = @Disposition_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


