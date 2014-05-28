﻿CREATE PROCEDURE [dbo].[QSL_SelectAllVoviciDownloadLogs]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VoviciDownload_ID, VoviciSurvey_ID, datLastDownload
FROM [dbo].VoviciDownloadLog

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


