ALTER TABLE [dbo].[CommentLoc]  WITH CHECK ADD  CONSTRAINT [FK_CommentLoc_SampleUnit_id] FOREIGN KEY([SampleUnit_id])
REFERENCES [dbo].[SAMPLEUNIT] ([SAMPLEUNIT_ID])


GO
ALTER TABLE [dbo].[CommentLoc] CHECK CONSTRAINT [FK_CommentLoc_SampleUnit_id]

