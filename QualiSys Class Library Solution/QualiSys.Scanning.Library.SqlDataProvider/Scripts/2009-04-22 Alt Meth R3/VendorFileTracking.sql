---------------------------------------------------------------------------------------
--QSL_SelectVendorFileTracking
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileTracking]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileTracking]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTracking]
@VendorFileTracking_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileTracking_ID, Member_ID, ActionDesc, VendorFile_ID, ActionDate
FROM [dbo].VendorFileTracking
WHERE VendorFileTracking_ID = @VendorFileTracking_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorFileTrackings
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorFileTrackings]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorFileTrackings]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileTrackings]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileTracking_ID, Member_ID, ActionDesc, VendorFile_ID, ActionDate
FROM [dbo].VendorFileTracking

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileTrackingsByVendorFileID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileTrackingsByVendorFileID]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileTrackingsByVendorFileID]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTrackingsByVendorFileID]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileTracking_ID, Member_ID, ActionDesc, VendorFile_ID, ActionDate
FROM VendorFileTracking
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorFileTracking
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorFileTracking]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorFileTracking]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorFileTracking]
@Member_ID INT,
@ActionDesc VARCHAR(100),
@VendorFile_ID INT,
@ActionDate DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileTracking (Member_ID, ActionDesc, VendorFile_ID, ActionDate)
VALUES (@Member_ID, @ActionDesc, @VendorFile_ID, @ActionDate)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorFileTracking
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorFileTracking]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorFileTracking]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileTracking]
@VendorFileTracking_ID INT,
@Member_ID INT,
@ActionDesc VARCHAR(100),
@VendorFile_ID INT,
@ActionDate DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileTracking SET
	Member_ID = @Member_ID,
	ActionDesc = @ActionDesc,
	VendorFile_ID = @VendorFile_ID,
	ActionDate = @ActionDate
WHERE VendorFileTracking_ID = @VendorFileTracking_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorFileTracking
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorFileTracking]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorFileTracking]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileTracking]
@VendorFileTracking_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileTracking
WHERE VendorFileTracking_ID = @VendorFileTracking_ID

SET NOCOUNT OFF
GO

