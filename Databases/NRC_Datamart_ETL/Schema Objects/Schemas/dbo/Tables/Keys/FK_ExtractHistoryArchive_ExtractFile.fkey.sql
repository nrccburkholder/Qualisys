ALTER TABLE [dbo].[ExtractHistoryArchive]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractHistoryArchive_ExtractFile] FOREIGN KEY([ExtractFileID])
REFERENCES [dbo].[ExtractFile] ([ExtractFileID])


GO
ALTER TABLE [dbo].[ExtractHistoryArchive] CHECK CONSTRAINT [FK_ExtractHistoryArchive_ExtractFile]

