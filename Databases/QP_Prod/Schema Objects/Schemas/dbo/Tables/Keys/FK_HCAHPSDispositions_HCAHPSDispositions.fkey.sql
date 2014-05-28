ALTER TABLE [dbo].[HCAHPSDispositions]  WITH CHECK ADD  CONSTRAINT [FK_HCAHPSDispositions_HCAHPSDispositions] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])


GO
ALTER TABLE [dbo].[HCAHPSDispositions] CHECK CONSTRAINT [FK_HCAHPSDispositions_HCAHPSDispositions]

