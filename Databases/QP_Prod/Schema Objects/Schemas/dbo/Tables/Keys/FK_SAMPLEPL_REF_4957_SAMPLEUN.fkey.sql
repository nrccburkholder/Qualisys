﻿ALTER TABLE [dbo].[SAMPLEPLAN]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEPL_REF_4957_SAMPLEUN] FOREIGN KEY([ROOTSAMPLEUNIT_ID])
REFERENCES [dbo].[SAMPLEUNIT] ([SAMPLEUNIT_ID])


GO
ALTER TABLE [dbo].[SAMPLEPLAN] CHECK CONSTRAINT [FK_SAMPLEPL_REF_4957_SAMPLEUN]

