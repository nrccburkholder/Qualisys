---------------------------------------------------------------------------------------
--LD_SelectUploadState
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadState]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadState]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadState]
@UploadState_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadState_id, UploadState_Nm
FROM [dbo].UploadStates
WHERE UploadState_id = @UploadState_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_SelectAllUploadStates
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectAllUploadStates]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectAllUploadStates]
GO
CREATE PROCEDURE [dbo].[LD_SelectAllUploadStates]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadState_id, UploadState_Nm
FROM [dbo].UploadStates

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--LD_SelectUploadStateByName
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LD_SelectUploadStateByName]') IS NOT NULL 
	DROP PROCEDURE [dbo].[LD_SelectUploadStateByName]
GO
CREATE PROCEDURE [dbo].[LD_SelectUploadStateByName]
@UploadStateName varchar(50)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UploadState_id, UploadState_Nm
FROM [dbo].UploadStates
WHERE UploadState_Nm = @UploadStateName

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO