ALTER TABLE [dbo].[DL_Dispositions]  WITH CHECK ADD  CONSTRAINT [FK_DL_Dispositions_DL_LithoCodes] FOREIGN KEY([DL_LithoCode_ID])
REFERENCES [dbo].[DL_LithoCodes] ([DL_LithoCode_ID])


GO
ALTER TABLE [dbo].[DL_Dispositions] CHECK CONSTRAINT [FK_DL_Dispositions_DL_LithoCodes]

