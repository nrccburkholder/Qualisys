﻿CREATE PROCEDURE [dbo].[QSL_SelectBadLithosByDataLoadId]
@DataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT BadLitho_ID, DataLoad_ID, BadstrLithoCode, DateCreated
FROM DL_BadLithos
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


