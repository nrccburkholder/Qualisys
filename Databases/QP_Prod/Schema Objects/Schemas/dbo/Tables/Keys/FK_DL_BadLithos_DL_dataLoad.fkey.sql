ALTER TABLE [dbo].[DL_BadLithos]  WITH CHECK ADD  CONSTRAINT [FK_DL_BadLithos_DL_dataLoad] FOREIGN KEY([DataLoad_ID])
REFERENCES [dbo].[DL_DataLoad] ([DataLoad_ID])


GO
ALTER TABLE [dbo].[DL_BadLithos] CHECK CONSTRAINT [FK_DL_BadLithos_DL_dataLoad]

