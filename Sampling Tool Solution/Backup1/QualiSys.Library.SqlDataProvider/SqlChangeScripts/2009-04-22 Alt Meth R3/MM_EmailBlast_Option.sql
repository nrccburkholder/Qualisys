---------------------------------------------------------------------------------------
--QCL_SelectMM_EmailBlast_Option
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectMM_EmailBlast_Option]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectMM_EmailBlast_Option]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMM_EmailBlast_Option]
@EmailBlast_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT EmailBlast_ID, Value
FROM [dbo].MM_EmailBlast_Options
WHERE EmailBlast_ID = @EmailBlast_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectAllMM_EmailBlast_Options
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectAllMM_EmailBlast_Options]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectAllMM_EmailBlast_Options]
GO
CREATE PROCEDURE [dbo].[QCL_SelectAllMM_EmailBlast_Options]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT EmailBlast_ID, Value
FROM [dbo].MM_EmailBlast_Options

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_InsertMM_EmailBlast_Option
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_InsertMM_EmailBlast_Option]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_InsertMM_EmailBlast_Option]
GO
CREATE PROCEDURE [dbo].[QCL_InsertMM_EmailBlast_Option]
@Value VARCHAR(42)
AS

SET NOCOUNT ON

INSERT INTO [dbo].MM_EmailBlast_Options (Value)
VALUES (@Value)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_UpdateMM_EmailBlast_Option
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_UpdateMM_EmailBlast_Option]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_UpdateMM_EmailBlast_Option]
GO
CREATE PROCEDURE [dbo].[QCL_UpdateMM_EmailBlast_Option]
@EmailBlast_ID INT,
@Value VARCHAR(42)
AS

SET NOCOUNT ON

UPDATE [dbo].MM_EmailBlast_Options SET
	Value = @Value
WHERE EmailBlast_ID = @EmailBlast_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_DeleteMM_EmailBlast_Option
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_DeleteMM_EmailBlast_Option]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_DeleteMM_EmailBlast_Option]
GO
CREATE PROCEDURE [dbo].[QCL_DeleteMM_EmailBlast_Option]
@EmailBlast_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].MM_EmailBlast_Options
WHERE EmailBlast_ID = @EmailBlast_ID

SET NOCOUNT OFF
GO

