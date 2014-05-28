ALTER TABLE [dbo].[ExtractHistoryError]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractHistoryError_EntityType] FOREIGN KEY([EntityTypeID])
REFERENCES [dbo].[EntityType] ([EntityTypeID])


GO
ALTER TABLE [dbo].[ExtractHistoryError] CHECK CONSTRAINT [FK_ExtractHistoryError_EntityType]

