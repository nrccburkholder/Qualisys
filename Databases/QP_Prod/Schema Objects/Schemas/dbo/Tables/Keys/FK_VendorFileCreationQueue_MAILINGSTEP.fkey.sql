ALTER TABLE [dbo].[VendorFileCreationQueue]  WITH CHECK ADD  CONSTRAINT [FK_VendorFileCreationQueue_MAILINGSTEP] FOREIGN KEY([MailingStep_ID])
REFERENCES [dbo].[MAILINGSTEP] ([MAILINGSTEP_ID])


GO
ALTER TABLE [dbo].[VendorFileCreationQueue] CHECK CONSTRAINT [FK_VendorFileCreationQueue_MAILINGSTEP]

