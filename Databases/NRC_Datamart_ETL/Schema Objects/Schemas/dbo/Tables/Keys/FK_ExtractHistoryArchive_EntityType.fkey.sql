ALTER TABLE [dbo].[ExtractHistoryArchive]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractHistoryArchive_EntityType] FOREIGN KEY([EntityTypeID])
REFERENCES [dbo].[EntityType] ([EntityTypeID])


GO
ALTER TABLE [dbo].[ExtractHistoryArchive] CHECK CONSTRAINT [FK_ExtractHistoryArchive_EntityType]

