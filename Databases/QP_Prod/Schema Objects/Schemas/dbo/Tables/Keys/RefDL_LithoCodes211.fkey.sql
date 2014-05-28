ALTER TABLE [dbo].[DL_Comments]  WITH CHECK ADD  CONSTRAINT [RefDL_LithoCodes211] FOREIGN KEY([DL_LithoCode_ID])
REFERENCES [dbo].[DL_LithoCodes] ([DL_LithoCode_ID])


GO
ALTER TABLE [dbo].[DL_Comments] CHECK CONSTRAINT [RefDL_LithoCodes211]

