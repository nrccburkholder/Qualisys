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


