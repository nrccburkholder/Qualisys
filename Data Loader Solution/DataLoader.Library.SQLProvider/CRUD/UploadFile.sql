---------------------------------------------------------------------------------------
--LD_SelectUploadFile
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadFile]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadFile]
@UploadFile_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadFile_id, OrigFile_Nm, File_Nm, FileSize, UploadAction_id, UserNotes, Member_id, Group_id
FROM [dbo].UploadFile
WHERE UploadFile_id = @UploadFile_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_SelectAllUploadFiles
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectAllUploadFiles]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectAllUploadFiles]
GO
CREATE PROCEDURE [dbo].[LD_SelectAllUploadFiles]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadFile_id, OrigFile_Nm, File_Nm, FileSize, UploadAction_id, UserNotes, Member_id, Group_id
FROM [dbo].UploadFile

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_InsertUploadFile
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_InsertUploadFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_InsertUploadFile]
GO
CREATE PROCEDURE [dbo].[LD_InsertUploadFile]
@OrigFile_Nm VARCHAR(255),
@File_Nm VARCHAR(255),
@FileSize INT,
@UploadAction_id INT,
@UserNotes VARCHAR(1000),
@Member_id INT,
@Group_id INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].UploadFile (OrigFile_Nm, File_Nm, FileSize, UploadAction_id, UserNotes, Member_id, Group_id)
VALUES (@OrigFile_Nm, @File_Nm, @FileSize, @UploadAction_id, @UserNotes, @Member_id, @Group_id)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--LD_UpdateUploadFile
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_UpdateUploadFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_UpdateUploadFile]
GO
CREATE PROCEDURE [dbo].[LD_UpdateUploadFile]
@UploadFile_id INT,
@OrigFile_Nm VARCHAR(255),
@File_Nm VARCHAR(255),
@FileSize INT,
@UploadAction_id INT,
@UserNotes VARCHAR(1000),
@Member_id INT,
@Group_id INT
AS

SET NOCOUNT ON

UPDATE [dbo].UploadFile SET
	OrigFile_Nm = @OrigFile_Nm,
	File_Nm = @File_Nm,
	FileSize = @FileSize,
	UploadAction_id = @UploadAction_id,
	UserNotes = @UserNotes,
	Member_id = @Member_id,
	Group_id = @Group_id
WHERE UploadFile_id = @UploadFile_id

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--LD_DeleteUploadFile
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_DeleteUploadFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_DeleteUploadFile]
GO
CREATE PROCEDURE [dbo].[LD_DeleteUploadFile]
@UploadFile_id INT
AS

SET NOCOUNT ON

DELETE [dbo].UploadFile
WHERE UploadFile_id = @UploadFile_id

SET NOCOUNT OFF
GO
