﻿ALTER TABLE [dbo].[STUDYCOMPARISON]  WITH CHECK ADD  CONSTRAINT [FK_STUDYCOM_REF_1410_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [dbo].[STUDY] ([STUDY_ID])


GO
ALTER TABLE [dbo].[STUDYCOMPARISON] CHECK CONSTRAINT [FK_STUDYCOM_REF_1410_STUDY]

