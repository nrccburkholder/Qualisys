ALTER TABLE [dbo].[QDECommentSelCodes]  WITH CHECK ADD  CONSTRAINT [FK_QDECommentSelCodes_CommentCodes] FOREIGN KEY([CmntCode_id])
REFERENCES [dbo].[CommentCodes] ([CmntCode_id])


GO
ALTER TABLE [dbo].[QDECommentSelCodes] CHECK CONSTRAINT [FK_QDECommentSelCodes_CommentCodes]

