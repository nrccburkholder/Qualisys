---------------------------------------------------------------------------------------
--QCL_SelectMM_EmailBlast
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectMM_EmailBlast]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectMM_EmailBlast]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMM_EmailBlast]
@MM_EmailBlast_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MM_EmailBlast_ID, MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent
FROM [dbo].MM_EmailBlast
WHERE MM_EmailBlast_ID = @MM_EmailBlast_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectAllMM_EmailBlasts
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectAllMM_EmailBlasts]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectAllMM_EmailBlasts]
GO
CREATE PROCEDURE [dbo].[QCL_SelectAllMM_EmailBlasts]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MM_EmailBlast_ID, MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent
FROM [dbo].MM_EmailBlast

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectMM_EmailBlastsByMAILINGSTEP_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectMM_EmailBlastsByMAILINGSTEPId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectMM_EmailBlastsByMAILINGSTEPId]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMM_EmailBlastsByMAILINGSTEPId]
@MAILINGSTEP_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MM_EmailBlast_ID, MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent
FROM MM_EmailBlast
WHERE MAILINGSTEP_ID = @MAILINGSTEP_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectMM_EmailBlastsByEmailBlast_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectMM_EmailBlastsByEmailBlastId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectMM_EmailBlastsByEmailBlastId]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMM_EmailBlastsByEmailBlastId]
@EmailBlast_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MM_EmailBlast_ID, MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent
FROM MM_EmailBlast
WHERE EmailBlast_ID = @EmailBlast_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_InsertMM_EmailBlast
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_InsertMM_EmailBlast]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_InsertMM_EmailBlast]
GO
CREATE PROCEDURE [dbo].[QCL_InsertMM_EmailBlast]
@MAILINGSTEP_ID INT,
@EmailBlast_ID INT,
@DaysFromStepGen INT,
@DateSent DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].MM_EmailBlast (MAILINGSTEP_ID, EmailBlast_ID, DaysFromStepGen, DateSent)
VALUES (@MAILINGSTEP_ID, @EmailBlast_ID, @DaysFromStepGen, @DateSent)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_UpdateMM_EmailBlast
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_UpdateMM_EmailBlast]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_UpdateMM_EmailBlast]
GO
CREATE PROCEDURE [dbo].[QCL_UpdateMM_EmailBlast]
@MM_EmailBlast_ID INT,
@MAILINGSTEP_ID INT,
@EmailBlast_ID INT,
@DaysFromStepGen INT,
@DateSent DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].MM_EmailBlast SET
	MAILINGSTEP_ID = @MAILINGSTEP_ID,
	EmailBlast_ID = @EmailBlast_ID,
	DaysFromStepGen = @DaysFromStepGen,
	DateSent = @DateSent
WHERE MM_EmailBlast_ID = @MM_EmailBlast_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_DeleteMM_EmailBlast
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_DeleteMM_EmailBlast]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_DeleteMM_EmailBlast]
GO
CREATE PROCEDURE [dbo].[QCL_DeleteMM_EmailBlast]
@MM_EmailBlast_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].MM_EmailBlast
WHERE MM_EmailBlast_ID = @MM_EmailBlast_ID

SET NOCOUNT OFF
GO

