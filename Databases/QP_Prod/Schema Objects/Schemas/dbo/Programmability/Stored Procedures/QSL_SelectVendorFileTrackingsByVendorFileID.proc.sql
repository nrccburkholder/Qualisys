﻿CREATE PROCEDURE [dbo].[QSL_SelectVendorFileTrackingsByVendorFileID]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileTracking_ID, Member_ID, ActionDesc, VendorFile_ID, ActionDate
FROM VendorFileTracking
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

