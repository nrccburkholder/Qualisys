﻿ALTER TABLE [dbo].[PCLResults]  WITH CHECK ADD  CONSTRAINT [FK_PCLResults_SampleUnit_id] FOREIGN KEY([SampleUnit_id])
REFERENCES [dbo].[SAMPLEUNIT] ([SAMPLEUNIT_ID])


GO
ALTER TABLE [dbo].[PCLResults] CHECK CONSTRAINT [FK_PCLResults_SampleUnit_id]

