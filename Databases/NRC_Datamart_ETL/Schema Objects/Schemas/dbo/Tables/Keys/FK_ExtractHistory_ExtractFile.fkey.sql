ALTER TABLE [dbo].[ExtractHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractHistory_ExtractFile] FOREIGN KEY([ExtractFileID])
REFERENCES [dbo].[ExtractFile] ([ExtractFileID])


GO
ALTER TABLE [dbo].[ExtractHistory] CHECK CONSTRAINT [FK_ExtractHistory_ExtractFile]

