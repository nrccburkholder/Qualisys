---------------------------------------------------------------------------------------
--QSL_SelectVoviciDownloadLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVoviciDownloadLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVoviciDownloadLog]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVoviciDownloadLog]
@VoviciDownload_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VoviciDownload_ID, VoviciSurvey_ID, datLastDownload
FROM [dbo].VoviciDownloadLog
WHERE VoviciDownload_ID = @VoviciDownload_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVoviciDownloadLogBySurveyID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVoviciDownloadLogBySurveyID]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVoviciDownloadLogBySurveyID]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVoviciDownloadLogBySurveyID]
@VoviciSurvey_ID VARCHAR(100)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VoviciDownload_ID, VoviciSurvey_ID, datLastDownload
FROM [dbo].VoviciDownloadLog
WHERE VoviciSurvey_ID = @VoviciSurvey_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVoviciDownloadLogs
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVoviciDownloadLogs]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVoviciDownloadLogs]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVoviciDownloadLogs]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VoviciDownload_ID, VoviciSurvey_ID, datLastDownload
FROM [dbo].VoviciDownloadLog

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVoviciDownloadLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVoviciDownloadLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVoviciDownloadLog]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVoviciDownloadLog]
@VoviciSurvey_ID VARCHAR(100),
@datLastDownload DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VoviciDownloadLog (VoviciSurvey_ID, datLastDownload)
VALUES (@VoviciSurvey_ID, @datLastDownload)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVoviciDownloadLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVoviciDownloadLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVoviciDownloadLog]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVoviciDownloadLog]
@VoviciDownload_ID INT,
@VoviciSurvey_ID VARCHAR(100),
@datLastDownload DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].VoviciDownloadLog SET
	VoviciSurvey_ID = @VoviciSurvey_ID,
	datLastDownload = @datLastDownload
WHERE VoviciDownload_ID = @VoviciDownload_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVoviciDownloadLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVoviciDownloadLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVoviciDownloadLog]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVoviciDownloadLog]
@VoviciDownload_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VoviciDownloadLog
WHERE VoviciDownload_ID = @VoviciDownload_ID

SET NOCOUNT OFF
GO

