CREATE PROCEDURE [dbo].[QCL_InsertVendorFile_VoviciDetail]
@Survey_ID INT,
@MailingStep_ID INT,
@VoviciSurvey_ID INT,
@VoviciSurvey_nm VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFile_VoviciDetails (Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm)
VALUES (@Survey_ID, @MailingStep_ID, @VoviciSurvey_ID, @VoviciSurvey_nm)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


