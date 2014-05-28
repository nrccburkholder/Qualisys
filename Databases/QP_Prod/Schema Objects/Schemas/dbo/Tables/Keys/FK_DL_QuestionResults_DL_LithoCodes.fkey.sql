ALTER TABLE [dbo].[DL_QuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_DL_QuestionResults_DL_LithoCodes] FOREIGN KEY([DL_LithoCode_ID])
REFERENCES [dbo].[DL_LithoCodes] ([DL_LithoCode_ID])


GO
ALTER TABLE [dbo].[DL_QuestionResults] CHECK CONSTRAINT [FK_DL_QuestionResults_DL_LithoCodes]

