ALTER TABLE [dbo].[DL_HandEntry]  WITH CHECK ADD  CONSTRAINT [FK_DL_HandEntry_DL_LithoCodes] FOREIGN KEY([DL_LithoCode_ID])
REFERENCES [dbo].[DL_LithoCodes] ([DL_LithoCode_ID])


GO
ALTER TABLE [dbo].[DL_HandEntry] CHECK CONSTRAINT [FK_DL_HandEntry_DL_LithoCodes]

