CREATE PROCEDURE [dbo].[QSL_InsertVoviciDownloadLog]
@VoviciSurvey_ID VARCHAR(100),
@datLastDownload DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VoviciDownloadLog (VoviciSurvey_ID, datLastDownload)
VALUES (@VoviciSurvey_ID, @datLastDownload)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


