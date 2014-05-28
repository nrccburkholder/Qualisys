CREATE PROCEDURE [dbo].[QCL_UpdateMethodologyStepVendor]
@MailingStepID INT,
@VendorID INT
AS

UPDATE MailingStep
SET Vendor_ID = @VendorID
WHERE MailingStep_ID = @MailingStepID


