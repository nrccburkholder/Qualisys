ALTER TABLE [dbo].[VendorFile_Messages]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_Messages_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorFile_Messages] CHECK CONSTRAINT [FK_VendorFile_Messages_VendorFileCreationQueue]

