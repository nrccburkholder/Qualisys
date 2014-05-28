ALTER TABLE [dbo].[VendorFile_NULLCounts]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_NULLCounts_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorFile_NULLCounts] CHECK CONSTRAINT [FK_VendorFile_NULLCounts_VendorFileCreationQueue]

