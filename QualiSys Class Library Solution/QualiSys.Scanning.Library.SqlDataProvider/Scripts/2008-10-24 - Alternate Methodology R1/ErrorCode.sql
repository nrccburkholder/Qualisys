---------------------------------------------------------------------------------------
--QSL_SelectErrorCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectErrorCode]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_SelectErrorCode]
GO
CREATE PROCEDURE [dbo].[QSL_SelectErrorCode]
@DL_Error_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Error_ID, ErrorDesc, DateCreated
FROM [dbo].DL_ErrorCodes
WHERE DL_Error_ID = @DL_Error_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllErrorCodes
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllErrorCodes]') IS NOT NULL 
        DROP PROCEDURE [dbo].[QSL_SelectAllErrorCodes]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllErrorCodes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_Error_ID, ErrorDesc, DateCreated
FROM [dbo].DL_ErrorCodes

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
