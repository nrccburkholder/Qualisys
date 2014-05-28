ALTER TABLE [dbo].[VendorDispositions]  WITH CHECK ADD  CONSTRAINT [FK_VendorDispositions_Vendors] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])


GO
ALTER TABLE [dbo].[VendorDispositions] CHECK CONSTRAINT [FK_VendorDispositions_Vendors]

