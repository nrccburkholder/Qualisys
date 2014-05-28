ALTER TABLE [dbo].[VendorPhoneFile_Data]  WITH NOCHECK ADD  CONSTRAINT [FK_VendorFile_Data_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorPhoneFile_Data] CHECK CONSTRAINT [FK_VendorFile_Data_VendorFileCreationQueue]

