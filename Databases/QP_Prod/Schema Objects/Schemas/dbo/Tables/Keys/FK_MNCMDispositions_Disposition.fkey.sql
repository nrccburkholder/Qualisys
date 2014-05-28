ALTER TABLE [dbo].[MNCMDispositions]  WITH CHECK ADD  CONSTRAINT [FK_MNCMDispositions_Disposition] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])


GO
ALTER TABLE [dbo].[MNCMDispositions] CHECK CONSTRAINT [FK_MNCMDispositions_Disposition]

