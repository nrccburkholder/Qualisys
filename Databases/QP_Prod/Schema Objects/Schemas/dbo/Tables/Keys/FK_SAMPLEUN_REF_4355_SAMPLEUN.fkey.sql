﻿ALTER TABLE [dbo].[SAMPLEUNITSECTION]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEUN_REF_4355_SAMPLEUN] FOREIGN KEY([SAMPLEUNIT_ID])
REFERENCES [dbo].[SAMPLEUNIT] ([SAMPLEUNIT_ID])


GO
ALTER TABLE [dbo].[SAMPLEUNITSECTION] CHECK CONSTRAINT [FK_SAMPLEUN_REF_4355_SAMPLEUN]
