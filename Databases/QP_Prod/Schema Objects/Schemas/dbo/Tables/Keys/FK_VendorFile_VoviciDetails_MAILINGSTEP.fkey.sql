ALTER TABLE [dbo].[VendorFile_VoviciDetails]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_VoviciDetails_MAILINGSTEP] FOREIGN KEY([MailingStep_ID])
REFERENCES [dbo].[MAILINGSTEP] ([MAILINGSTEP_ID])


GO
ALTER TABLE [dbo].[VendorFile_VoviciDetails] CHECK CONSTRAINT [FK_VendorFile_VoviciDetails_MAILINGSTEP]

