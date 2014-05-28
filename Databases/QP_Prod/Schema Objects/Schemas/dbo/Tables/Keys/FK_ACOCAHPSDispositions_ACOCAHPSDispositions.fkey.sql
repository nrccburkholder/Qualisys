ALTER TABLE [dbo].[ACOCAHPSDispositions]  WITH CHECK ADD  CONSTRAINT [FK_ACOCAHPSDispositions_ACOCAHPSDispositions] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])


GO
ALTER TABLE [dbo].[ACOCAHPSDispositions] CHECK CONSTRAINT [FK_ACOCAHPSDispositions_ACOCAHPSDispositions]

