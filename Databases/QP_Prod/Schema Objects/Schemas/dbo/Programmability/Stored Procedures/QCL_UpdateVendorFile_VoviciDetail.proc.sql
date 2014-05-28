CREATE PROCEDURE [dbo].[QCL_UpdateVendorFile_VoviciDetail]
@VendorFile_VoviciDetail_ID INT,
@Survey_ID INT,
@MailingStep_ID INT,
@VoviciSurvey_ID INT,
@VoviciSurvey_nm VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFile_VoviciDetails SET
	Survey_ID = @Survey_ID,
	MailingStep_ID = @MailingStep_ID,
	VoviciSurvey_ID = @VoviciSurvey_ID,
	VoviciSurvey_nm = @VoviciSurvey_nm
WHERE VendorFile_VoviciDetail_ID = @VendorFile_VoviciDetail_ID

SET NOCOUNT OFF


