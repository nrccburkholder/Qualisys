ALTER TABLE [dbo].[DL_DataLoad]  WITH CHECK ADD  CONSTRAINT [FK_DL_DataLoad_Vendors] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])


GO
ALTER TABLE [dbo].[DL_DataLoad] CHECK CONSTRAINT [FK_DL_DataLoad_Vendors]

