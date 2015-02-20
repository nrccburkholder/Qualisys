---------------------------------------------------------------------------------------
--sp_SelectDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_SelectDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_SelectDisposition]
GO
CREATE PROCEDURE [dbo].[sp_SelectDisposition]
@Disposition_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Disposition_id, strDispositionLabel, Action_id, HCAHPSValue, strReportLabel, HCAHPSHierarchy
FROM [dbo].Disposition
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--sp_SelectAllDispositions
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_SelectAllDispositions]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_SelectAllDispositions]
GO
CREATE PROCEDURE [dbo].[sp_SelectAllDispositions]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Disposition_id, strDispositionLabel, Action_id, HCAHPSValue, strReportLabel, HCAHPSHierarchy
FROM [dbo].Disposition

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--sp_InsertDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_InsertDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_InsertDisposition]
GO
CREATE PROCEDURE [dbo].[sp_InsertDisposition]
@strDispositionLabel VARCHAR(100),
@Action_id INT,
@HCAHPSValue VARCHAR(20),
@strReportLabel VARCHAR(100),
@HCAHPSHierarchy INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].Disposition (strDispositionLabel, Action_id, HCAHPSValue, strReportLabel, HCAHPSHierarchy)
VALUES (@strDispositionLabel, @Action_id, @HCAHPSValue, @strReportLabel, @HCAHPSHierarchy)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--sp_UpdateDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_UpdateDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_UpdateDisposition]
GO
CREATE PROCEDURE [dbo].[sp_UpdateDisposition]
@Disposition_id INT,
@strDispositionLabel VARCHAR(100),
@Action_id INT,
@HCAHPSValue VARCHAR(20),
@strReportLabel VARCHAR(100),
@HCAHPSHierarchy INT
AS

SET NOCOUNT ON

UPDATE [dbo].Disposition SET
	strDispositionLabel = @strDispositionLabel,
	Action_id = @Action_id,
	HCAHPSValue = @HCAHPSValue,
	strReportLabel = @strReportLabel,
	HCAHPSHierarchy = @HCAHPSHierarchy
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--sp_DeleteDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_DeleteDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_DeleteDisposition]
GO
CREATE PROCEDURE [dbo].[sp_DeleteDisposition]
@Disposition_id INT
AS

SET NOCOUNT ON

DELETE [dbo].Disposition
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF
GO

