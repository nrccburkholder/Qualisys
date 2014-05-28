ALTER TABLE [dbo].[DL_Dispositions]  WITH CHECK ADD  CONSTRAINT [FK_DL_Dispositions_DL_ErrorCodes] FOREIGN KEY([DL_Error_ID])
REFERENCES [dbo].[DL_ErrorCodes] ([DL_Error_ID])


GO
ALTER TABLE [dbo].[DL_Dispositions] CHECK CONSTRAINT [FK_DL_Dispositions_DL_ErrorCodes]

