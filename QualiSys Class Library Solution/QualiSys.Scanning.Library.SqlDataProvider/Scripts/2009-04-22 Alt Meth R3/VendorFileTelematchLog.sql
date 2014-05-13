---------------------------------------------------------------------------------------
--QSL_SelectVendorFileTelematchLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileTelematchLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLog]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLog]
@VendorFile_TelematchLog_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM [dbo].VendorFile_TelematchLog
WHERE VendorFile_TelematchLog_ID = @VendorFile_TelematchLog_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorFileTelematchLogs
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorFileTelematchLogs]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorFileTelematchLogs]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileTelematchLogs]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM [dbo].VendorFile_TelematchLog

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileTelematchLogsByVendorFileID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileTelematchLogsByVendorFileId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLogsByVendorFileId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLogsByVendorFileId]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM VendorFile_TelematchLog
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileTelematchLogsByNotReturned
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileTelematchLogsByNotReturned]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLogsByNotReturned]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTelematchLogsByNotReturned]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_TelematchLog_ID, VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent
FROM [dbo].VendorFile_TelematchLog
WHERE datSent IS NOT NULL
  AND datReturned IS NULL

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorFileTelematchLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorFileTelematchLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorFileTelematchLog]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorFileTelematchLog]
@VendorFile_ID INT,
@datSent DATETIME,
@datReturned DATETIME,
@intRecordsReturned INT,
@datOverdueNoticeSent DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFile_TelematchLog (VendorFile_ID, datSent, datReturned, intRecordsReturned, datOverdueNoticeSent)
VALUES (@VendorFile_ID, @datSent, @datReturned, @intRecordsReturned, @datOverdueNoticeSent)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorFileTelematchLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorFileTelematchLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorFileTelematchLog]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileTelematchLog]
@VendorFile_TelematchLog_ID INT,
@VendorFile_ID INT,
@datSent DATETIME,
@datReturned DATETIME,
@intRecordsReturned INT,
@datOverdueNoticeSent DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFile_TelematchLog SET
	VendorFile_ID = @VendorFile_ID,
	datSent = @datSent,
	datReturned = @datReturned,
	intRecordsReturned = @intRecordsReturned,
	datOverdueNoticeSent = @datOverdueNoticeSent
WHERE VendorFile_TelematchLog_ID = @VendorFile_TelematchLog_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorFileTelematchLog
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorFileTelematchLog]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorFileTelematchLog]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileTelematchLog]
@VendorFile_TelematchLog_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFile_TelematchLog
WHERE VendorFile_TelematchLog_ID = @VendorFile_TelematchLog_ID

SET NOCOUNT OFF
GO

