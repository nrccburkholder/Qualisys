ALTER TABLE [dbo].[ExtractHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractHistory_EntityType] FOREIGN KEY([EntityTypeID])
REFERENCES [dbo].[EntityType] ([EntityTypeID])


GO
ALTER TABLE [dbo].[ExtractHistory] CHECK CONSTRAINT [FK_ExtractHistory_EntityType]

