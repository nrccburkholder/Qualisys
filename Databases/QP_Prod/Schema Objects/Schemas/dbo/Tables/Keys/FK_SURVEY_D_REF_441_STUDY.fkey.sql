﻿ALTER TABLE [dbo].[SURVEY_DEF]  WITH CHECK ADD  CONSTRAINT [FK_SURVEY_D_REF_441_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [dbo].[STUDY] ([STUDY_ID])


GO
ALTER TABLE [dbo].[SURVEY_DEF] CHECK CONSTRAINT [FK_SURVEY_D_REF_441_STUDY]

