﻿ALTER TABLE [dbo].[STUDYCOMPARISON]  WITH CHECK ADD  CONSTRAINT [FK_STUDYCOM_REF_2937_STATE] FOREIGN KEY([STATE_ID])
REFERENCES [dbo].[STATE] ([STATE_ID])


GO
ALTER TABLE [dbo].[STUDYCOMPARISON] CHECK CONSTRAINT [FK_STUDYCOM_REF_2937_STATE]

