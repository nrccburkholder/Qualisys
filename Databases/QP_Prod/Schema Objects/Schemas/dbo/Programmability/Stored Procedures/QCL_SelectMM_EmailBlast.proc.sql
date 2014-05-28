﻿CREATE PROCEDURE [dbo].[QCL_SelectMM_EmailBlast]
@MM_EmailBlast_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MM_EmailBlast_ID, MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent
FROM [dbo].MM_EmailBlast
WHERE MM_EmailBlast_ID = @MM_EmailBlast_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


