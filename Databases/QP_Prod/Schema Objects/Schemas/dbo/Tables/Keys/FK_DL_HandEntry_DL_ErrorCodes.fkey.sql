ALTER TABLE [dbo].[DL_HandEntry]  WITH CHECK ADD  CONSTRAINT [FK_DL_HandEntry_DL_ErrorCodes] FOREIGN KEY([DL_Error_ID])
REFERENCES [dbo].[DL_ErrorCodes] ([DL_Error_ID])


GO
ALTER TABLE [dbo].[DL_HandEntry] CHECK CONSTRAINT [FK_DL_HandEntry_DL_ErrorCodes]

