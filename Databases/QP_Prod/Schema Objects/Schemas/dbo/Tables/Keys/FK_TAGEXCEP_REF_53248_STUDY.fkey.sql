﻿ALTER TABLE [dbo].[TAGEXCEPTION]  WITH CHECK ADD  CONSTRAINT [FK_TAGEXCEP_REF_53248_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [dbo].[STUDY] ([STUDY_ID])


GO
ALTER TABLE [dbo].[TAGEXCEPTION] CHECK CONSTRAINT [FK_TAGEXCEP_REF_53248_STUDY]

