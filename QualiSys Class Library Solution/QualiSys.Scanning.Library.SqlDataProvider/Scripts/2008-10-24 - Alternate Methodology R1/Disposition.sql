---------------------------------------------------------------------------------------
--QSL_SelectDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectDisposition]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_SelectDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_SelectDisposition]
@DL_Disposition_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Disposition_ID, DL_LithoCode_ID, DL_Error_ID, DispositionDate, VendorDispositionCode, IsFinal
FROM [dbo].DL_Dispositions
WHERE DL_Disposition_ID = @DL_Disposition_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllDispositions
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllDispositions]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_SelectAllDispositions]
GO
---------------------------------------------------------------------------------------
--QSL_SelectDispositionsByLithoCode_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectDispositionsByLithoCodeId]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_SelectDispositionsByLithoCodeId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectDispositionsByLithoCodeId]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Disposition_ID, DL_LithoCode_ID, DL_Error_ID, DispositionDate, VendorDispositionCode, IsFinal
FROM DL_Dispositions
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectDispositionsByError_ID
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectDispositionsByErrorId]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_SelectDispositionsByErrorId]
GO
---------------------------------------------------------------------------------------
--QSL_InsertDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertDisposition]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_InsertDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_InsertDisposition]
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@DispositionDate DATETIME,
@VendorDispositionCode VARCHAR(5),
@IsFinal BIT
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_Dispositions (DL_LithoCode_ID, DL_Error_ID, DispositionDate, VendorDispositionCode, IsFinal)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @DispositionDate, @VendorDispositionCode, @IsFinal)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateDisposition]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_UpdateDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateDisposition]
@DL_Disposition_ID INT,
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@DispositionDate DATETIME,
@VendorDispositionCode VARCHAR(5),
@IsFinal BIT
AS

SET NOCOUNT ON

UPDATE [dbo].DL_Dispositions SET
        DL_LithoCode_ID = @DL_LithoCode_ID,
        DL_Error_ID = @DL_Error_ID,
        DispositionDate = @DispositionDate,
        VendorDispositionCode = @VendorDispositionCode,
        IsFinal = @IsFinal
WHERE DL_Disposition_ID = @DL_Disposition_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteDisposition]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_DeleteDisposition]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteDisposition]
@DL_Disposition_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_Dispositions
WHERE DL_Disposition_ID = @DL_Disposition_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_SelectDisposition
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectDisposition]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectDisposition]
GO
CREATE PROCEDURE [dbo].[QCL_SelectDisposition]
@Disposition_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Disposition_id, strDispositionLabel, Action_id
FROM [dbo].Disposition
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

