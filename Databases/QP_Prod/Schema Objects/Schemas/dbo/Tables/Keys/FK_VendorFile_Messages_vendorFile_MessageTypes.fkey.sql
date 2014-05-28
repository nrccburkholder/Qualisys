ALTER TABLE [dbo].[VendorFile_Messages]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_Messages_vendorFile_MessageTypes] FOREIGN KEY([VendorFile_MessageType_ID])
REFERENCES [dbo].[vendorFile_MessageTypes] ([VendorFile_MessageType_Id])


GO
ALTER TABLE [dbo].[VendorFile_Messages] CHECK CONSTRAINT [FK_VendorFile_Messages_vendorFile_MessageTypes]

