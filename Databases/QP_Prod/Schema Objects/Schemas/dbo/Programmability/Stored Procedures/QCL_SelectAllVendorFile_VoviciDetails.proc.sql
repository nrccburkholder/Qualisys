﻿CREATE PROCEDURE [dbo].[QCL_SelectAllVendorFile_VoviciDetails]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_VoviciDetail_ID, Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm
FROM [dbo].VendorFile_VoviciDetails

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


