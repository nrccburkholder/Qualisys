CREATE PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetail]
@VendorFile_VoviciDetail_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_VoviciDetail_ID, Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm
FROM [dbo].VendorFile_VoviciDetails
WHERE VendorFile_VoviciDetail_ID = @VendorFile_VoviciDetail_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


