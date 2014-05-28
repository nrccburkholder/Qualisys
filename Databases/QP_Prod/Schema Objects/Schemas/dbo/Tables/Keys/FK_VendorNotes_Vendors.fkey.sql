ALTER TABLE [dbo].[VendorNotes]  WITH CHECK ADD  CONSTRAINT [FK_VendorNotes_Vendors] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])


GO
ALTER TABLE [dbo].[VendorNotes] CHECK CONSTRAINT [FK_VendorNotes_Vendors]

