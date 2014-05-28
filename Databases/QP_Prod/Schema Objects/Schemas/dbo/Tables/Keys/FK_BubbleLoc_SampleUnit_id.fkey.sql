ALTER TABLE [dbo].[BubbleLoc]  WITH CHECK ADD  CONSTRAINT [FK_BubbleLoc_SampleUnit_id] FOREIGN KEY([SampleUnit_id])
REFERENCES [dbo].[SAMPLEUNIT] ([SAMPLEUNIT_ID])


GO
ALTER TABLE [dbo].[BubbleLoc] CHECK CONSTRAINT [FK_BubbleLoc_SampleUnit_id]

