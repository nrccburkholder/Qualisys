ALTER TABLE [dbo].[Vendors]  WITH CHECK ADD  CONSTRAINT [FK_Vendors_VendorFileOutgoTypes] FOREIGN KEY([VendorFileOutgoType_ID])
REFERENCES [dbo].[VendorFileOutgoTypes] ([VendorFileOutgoType_ID])


GO
ALTER TABLE [dbo].[Vendors] CHECK CONSTRAINT [FK_Vendors_VendorFileOutgoTypes]

