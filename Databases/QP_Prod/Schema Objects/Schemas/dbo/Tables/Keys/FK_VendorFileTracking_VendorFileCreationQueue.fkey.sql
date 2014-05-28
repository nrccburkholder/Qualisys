ALTER TABLE [dbo].[VendorFileTracking]  WITH CHECK ADD  CONSTRAINT [FK_VendorFileTracking_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorFileTracking] CHECK CONSTRAINT [FK_VendorFileTracking_VendorFileCreationQueue]

