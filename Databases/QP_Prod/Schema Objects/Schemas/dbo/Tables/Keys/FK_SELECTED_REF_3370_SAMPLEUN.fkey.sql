﻿ALTER TABLE [dbo].[SELECTEDSAMPLE]  WITH CHECK ADD  CONSTRAINT [FK_SELECTED_REF_3370_SAMPLEUN] FOREIGN KEY([SAMPLEUNIT_ID])
REFERENCES [dbo].[SAMPLEUNIT] ([SAMPLEUNIT_ID])


GO
ALTER TABLE [dbo].[SELECTEDSAMPLE] CHECK CONSTRAINT [FK_SELECTED_REF_3370_SAMPLEUN]

