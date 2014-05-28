ALTER TABLE [dbo].[VendorDisp_11042009150321000]  WITH CHECK ADD  CONSTRAINT [FK_VendorDispositionLog_Vendors] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])


GO
ALTER TABLE [dbo].[VendorDisp_11042009150321000] CHECK CONSTRAINT [FK_VendorDispositionLog_Vendors]

