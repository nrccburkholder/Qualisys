CREATE PROCEDURE [dbo].[QSL_DeleteVoviciDownloadLog]
@VoviciDownload_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VoviciDownloadLog
WHERE VoviciDownload_ID = @VoviciDownload_ID

SET NOCOUNT OFF


