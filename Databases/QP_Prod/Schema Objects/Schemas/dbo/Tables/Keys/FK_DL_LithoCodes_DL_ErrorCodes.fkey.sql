ALTER TABLE [dbo].[DL_LithoCodes]  WITH CHECK ADD  CONSTRAINT [FK_DL_LithoCodes_DL_ErrorCodes] FOREIGN KEY([DL_Error_ID])
REFERENCES [dbo].[DL_ErrorCodes] ([DL_Error_ID])


GO
ALTER TABLE [dbo].[DL_LithoCodes] CHECK CONSTRAINT [FK_DL_LithoCodes_DL_ErrorCodes]

