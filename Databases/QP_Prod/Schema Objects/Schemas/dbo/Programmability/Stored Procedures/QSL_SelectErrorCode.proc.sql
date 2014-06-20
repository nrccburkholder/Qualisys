﻿CREATE PROCEDURE [dbo].[QSL_SelectErrorCode]
@DL_Error_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Error_ID, ErrorDesc, DateCreated
FROM [dbo].DL_ErrorCodes
WHERE DL_Error_ID = @DL_Error_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

