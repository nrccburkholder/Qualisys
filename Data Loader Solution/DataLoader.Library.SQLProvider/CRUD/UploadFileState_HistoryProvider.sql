---------------------------------------------------------------------------------------
--LD_LogUploadFileHistory
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_LogUploadFileHistory]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_LogUploadFileHistory]
GO
CREATE PROCEDURE [dbo].[LD_LogUploadFileHistory]
@UploadFile_id INT,
@UploadState_id INT,
@StateParameter VARCHAR(2000)
AS

SET NOCOUNT ON

INSERT INTO [dbo].UploadFileState_History (UploadFile_id, UploadState_id, datOccurred, StateParameter)
VALUES (@UploadFile_id, @UploadState_id, GetDate(), @StateParameter)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO