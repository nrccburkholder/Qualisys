---------------------------------------------------------------------------------------
--LD_SelectUploadAction
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadAction]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadAction]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadAction]
@UploadAction_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadAction_id, UploadAction_Nm
FROM [dbo].UploadActions
WHERE UploadAction_id = @UploadAction_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_SelectAllUploadActions
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectAllUploadActions]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectAllUploadActions]
GO
CREATE PROCEDURE [dbo].[LD_SelectAllUploadActions]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadAction_id, UploadAction_Nm
FROM [dbo].UploadActions

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
