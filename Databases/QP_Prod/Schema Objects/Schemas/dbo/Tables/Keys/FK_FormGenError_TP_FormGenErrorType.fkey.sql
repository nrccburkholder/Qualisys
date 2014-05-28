ALTER TABLE [dbo].[FormGenError_TP]  WITH CHECK ADD  CONSTRAINT [FK_FormGenError_TP_FormGenErrorType] FOREIGN KEY([FGErrorType_id])
REFERENCES [dbo].[FormGenErrorType] ([FGErrorType_id])


GO
ALTER TABLE [dbo].[FormGenError_TP] CHECK CONSTRAINT [FK_FormGenError_TP_FormGenErrorType]

