ALTER TABLE [dbo].[DL_Comments]  WITH CHECK ADD  CONSTRAINT [FK_DL_Comments_DL_ErrorCodes] FOREIGN KEY([DL_Error_ID])
REFERENCES [dbo].[DL_ErrorCodes] ([DL_Error_ID])


GO
ALTER TABLE [dbo].[DL_Comments] CHECK CONSTRAINT [FK_DL_Comments_DL_ErrorCodes]

