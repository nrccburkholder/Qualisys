ALTER TABLE [dbo].[VendorFile_TelematchLog]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_TelematchLog_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorFile_TelematchLog] CHECK CONSTRAINT [FK_VendorFile_TelematchLog_VendorFileCreationQueue]

