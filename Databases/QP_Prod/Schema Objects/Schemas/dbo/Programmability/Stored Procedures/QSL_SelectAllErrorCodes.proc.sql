﻿CREATE PROCEDURE [dbo].[QSL_SelectAllErrorCodes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Error_ID, ErrorDesc, DateCreated
FROM [dbo].DL_ErrorCodes

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

