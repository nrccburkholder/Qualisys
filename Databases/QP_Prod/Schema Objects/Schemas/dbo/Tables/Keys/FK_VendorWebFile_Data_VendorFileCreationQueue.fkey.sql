ALTER TABLE [dbo].[VendorWebFile_Data]  WITH CHECK ADD  CONSTRAINT [FK_VendorWebFile_Data_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorWebFile_Data] CHECK CONSTRAINT [FK_VendorWebFile_Data_VendorFileCreationQueue]

