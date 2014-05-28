ALTER TABLE [dbo].[ExtractTempTableCounts]  WITH NOCHECK ADD  CONSTRAINT [FK_ExtractTempTableCounts_ExtractFile] FOREIGN KEY([ExtractFileID])
REFERENCES [dbo].[ExtractFile] ([ExtractFileID])


GO
ALTER TABLE [dbo].[ExtractTempTableCounts] CHECK CONSTRAINT [FK_ExtractTempTableCounts_ExtractFile]

