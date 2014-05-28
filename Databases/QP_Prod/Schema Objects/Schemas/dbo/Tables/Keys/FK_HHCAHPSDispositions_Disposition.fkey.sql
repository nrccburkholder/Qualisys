ALTER TABLE [dbo].[HHCAHPSDispositions]  WITH CHECK ADD  CONSTRAINT [FK_HHCAHPSDispositions_Disposition] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])


GO
ALTER TABLE [dbo].[HHCAHPSDispositions] CHECK CONSTRAINT [FK_HHCAHPSDispositions_Disposition]

