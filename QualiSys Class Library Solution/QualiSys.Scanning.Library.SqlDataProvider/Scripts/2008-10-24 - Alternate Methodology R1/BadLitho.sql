---------------------------------------------------------------------------------------
--QSL_SelectBadLitho
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectBadLitho]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectBadLitho]
GO
CREATE PROCEDURE [dbo].[QSL_SelectBadLitho]
@BadLitho_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT BadLitho_ID, DataLoad_ID, BadstrLithoCode, DateCreated
FROM [dbo].DL_BadLithos
WHERE BadLitho_ID = @BadLitho_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllBadLithos
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllBadLithos]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllBadLithos]
GO
---------------------------------------------------------------------------------------
--QSL_SelectBadLithosByDataLoad_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectBadLithosByDataLoadId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectBadLithosByDataLoadId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectBadLithosByDataLoadId]
@DataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT BadLitho_ID, DataLoad_ID, BadstrLithoCode, DateCreated
FROM DL_BadLithos
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertBadLitho
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertBadLitho]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertBadLitho]
GO
CREATE PROCEDURE [dbo].[QSL_InsertBadLitho]
@DataLoad_ID INT,
@BadstrLithoCode VARCHAR(50),
@DateCreated DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_BadLithos (DataLoad_ID, BadstrLithoCode, DateCreated)
VALUES (@DataLoad_ID, @BadstrLithoCode, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateBadLitho
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateBadLitho]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateBadLitho]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateBadLitho]
@BadLitho_ID INT,
@DataLoad_ID INT,
@BadstrLithoCode VARCHAR(50),
@DateCreated DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].DL_BadLithos SET
	DataLoad_ID = @DataLoad_ID,
	BadstrLithoCode = @BadstrLithoCode,
	DateCreated = @DateCreated
WHERE BadLitho_ID = @BadLitho_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteBadLitho
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteBadLitho]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteBadLitho]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteBadLitho]
@BadLitho_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_BadLithos
WHERE BadLitho_ID = @BadLitho_ID

SET NOCOUNT OFF
GO

