ALTER TABLE [dbo].[QDECommentSelCodes]  WITH CHECK ADD  CONSTRAINT [FK_QDECommentSelCodes_QDEComments] FOREIGN KEY([Cmnt_id])
REFERENCES [dbo].[QDEComments] ([Cmnt_id])


GO
ALTER TABLE [dbo].[QDECommentSelCodes] CHECK CONSTRAINT [FK_QDECommentSelCodes_QDEComments]

