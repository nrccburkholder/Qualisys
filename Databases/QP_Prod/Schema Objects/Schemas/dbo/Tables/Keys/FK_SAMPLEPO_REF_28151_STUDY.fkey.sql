﻿ALTER TABLE [dbo].[SAMPLEPOP]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEPO_REF_28151_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [dbo].[STUDY] ([STUDY_ID])


GO
ALTER TABLE [dbo].[SAMPLEPOP] CHECK CONSTRAINT [FK_SAMPLEPO_REF_28151_STUDY]
