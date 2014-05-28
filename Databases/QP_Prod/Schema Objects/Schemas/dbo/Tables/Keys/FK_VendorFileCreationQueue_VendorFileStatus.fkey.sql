ALTER TABLE [dbo].[VendorFileCreationQueue]  WITH CHECK ADD  CONSTRAINT [FK_VendorFileCreationQueue_VendorFileStatus] FOREIGN KEY([VendorFileStatus_ID])
REFERENCES [dbo].[VendorFileStatus] ([VendorFileStatus_ID])


GO
ALTER TABLE [dbo].[VendorFileCreationQueue] CHECK CONSTRAINT [FK_VendorFileCreationQueue_VendorFileStatus]

