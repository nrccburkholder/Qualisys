﻿ALTER TABLE [dbo].[MAILINGMETHODOLOGY]  WITH CHECK ADD  CONSTRAINT [FK_MAILINGM_REF_6478_SURVEY_D] FOREIGN KEY([SURVEY_ID])
REFERENCES [dbo].[SURVEY_DEF] ([SURVEY_ID])


GO
ALTER TABLE [dbo].[MAILINGMETHODOLOGY] CHECK CONSTRAINT [FK_MAILINGM_REF_6478_SURVEY_D]

