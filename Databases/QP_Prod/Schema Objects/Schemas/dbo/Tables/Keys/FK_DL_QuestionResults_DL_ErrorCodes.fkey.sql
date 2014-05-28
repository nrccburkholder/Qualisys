ALTER TABLE [dbo].[DL_QuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_DL_QuestionResults_DL_ErrorCodes] FOREIGN KEY([DL_Error_ID])
REFERENCES [dbo].[DL_ErrorCodes] ([DL_Error_ID])


GO
ALTER TABLE [dbo].[DL_QuestionResults] CHECK CONSTRAINT [FK_DL_QuestionResults_DL_ErrorCodes]

