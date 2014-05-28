ALTER TABLE [dbo].[Disposition]  WITH NOCHECK ADD  CONSTRAINT [FK_Disposition_DispositionActions] FOREIGN KEY([Action_id])
REFERENCES [dbo].[DispositionActions] ([ActionID])


GO
ALTER TABLE [dbo].[Disposition] CHECK CONSTRAINT [FK_Disposition_DispositionActions]

