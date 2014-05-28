ALTER TABLE [dbo].[VendorFile_Freqs]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_Freqs_VendorFileCreationQueue] FOREIGN KEY([VendorFile_ID])
REFERENCES [dbo].[VendorFileCreationQueue] ([VendorFile_ID])


GO
ALTER TABLE [dbo].[VendorFile_Freqs] CHECK CONSTRAINT [FK_VendorFile_Freqs_VendorFileCreationQueue]

