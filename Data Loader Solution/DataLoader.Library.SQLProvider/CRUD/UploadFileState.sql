---------------------------------------------------------------------------------------
--LD_SelectUploadFileStateByUploadFileID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadFileStateByUploadFileID]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadFileStateByUploadFileID]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadFileStateByUploadFileID]
@UploadFile_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadFileState_id, UploadFile_id, UploadState_id, datOccurred, StateParameter
FROM [dbo].UploadFileState
WHERE UploadFile_id = @UploadFile_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_SelectUploadFileState
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadFileState]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadFileState]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadFileState]
@UploadFileState_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadFileState_id, UploadFile_id, UploadState_id, datOccurred, StateParameter
FROM [dbo].UploadFileState
WHERE UploadFileState_id = @UploadFileState_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_InsertUploadFileState
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_InsertUploadFileState]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_InsertUploadFileState]
GO
CREATE PROCEDURE [dbo].[LD_InsertUploadFileState]
@UploadFile_id INT,
@UploadState_id INT,
@datOccurred DATETIME,
@StateParameter VARCHAR(2000)
AS

SET NOCOUNT ON

INSERT INTO [dbo].UploadFileState (UploadFile_id, UploadState_id, datOccurred, StateParameter)
VALUES (@UploadFile_id, @UploadState_id, @datOccurred, @StateParameter)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--LD_UpdateUploadFileState
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_UpdateUploadFileState]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_UpdateUploadFileState]
GO
CREATE PROCEDURE [dbo].[LD_UpdateUploadFileState]
@UploadFileState_id INT,
@UploadFile_id INT,
@UploadState_id INT,
@datOccurred DATETIME,
@StateParameter VARCHAR(2000)
AS

SET NOCOUNT ON

UPDATE [dbo].UploadFileState SET
	UploadFile_id = @UploadFile_id,
	UploadState_id = @UploadState_id,
	datOccurred = @datOccurred,
	StateParameter = @StateParameter
WHERE UploadFileState_id = @UploadFileState_id

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--LD_DeleteUploadFileState
---------------------------------------------------------------------------------------
/*
IF OBJECT_ID(N'[dbo].[LD_DeleteUploadFileState]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_DeleteUploadFileState]
GO
CREATE PROCEDURE [dbo].[LD_DeleteUploadFileState]
@UploadFileState_id INT
AS

SET NOCOUNT ON

DELETE [dbo].UploadFileState
WHERE UploadFileState_id = @UploadFileState_id

SET NOCOUNT OFF
GO
*/
---------------------------------------------------------------------------------------
--UpdateUploadFileState Update Trigger
---------------------------------------------------------------------------------------
CREATE TRIGGER [dbo].[UpdateUploadFileState] ON [dbo].[UploadFileState] 
FOR UPDATE
AS
INSERT INTO UploadFileState_History (UploadFileState_id, UploadFile_id,
		UploadState_id, datOccurred, StateParameter)
SELECT UploadFileState_id, UploadFile_id,
		UploadState_id, datOccurred, StateParameter
FROM Deleted