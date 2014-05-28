ALTER TABLE [dbo].[ExtractHistoryError]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractHistoryError_ExtractFile] FOREIGN KEY([ExtractFileID])
REFERENCES [dbo].[ExtractFile] ([ExtractFileID])


GO
ALTER TABLE [dbo].[ExtractHistoryError] CHECK CONSTRAINT [FK_ExtractHistoryError_ExtractFile]

