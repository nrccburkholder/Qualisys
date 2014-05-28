ALTER TABLE [dbo].[VendorDispositions]  WITH CHECK ADD  CONSTRAINT [FK_VendorDispositions_Disposition] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])


GO
ALTER TABLE [dbo].[VendorDispositions] CHECK CONSTRAINT [FK_VendorDispositions_Disposition]

