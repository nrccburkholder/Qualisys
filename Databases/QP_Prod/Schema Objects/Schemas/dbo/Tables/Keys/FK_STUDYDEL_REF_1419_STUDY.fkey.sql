﻿ALTER TABLE [dbo].[STUDYDELIVERYDATE]  WITH CHECK ADD  CONSTRAINT [FK_STUDYDEL_REF_1419_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [dbo].[STUDY] ([STUDY_ID])


GO
ALTER TABLE [dbo].[STUDYDELIVERYDATE] CHECK CONSTRAINT [FK_STUDYDEL_REF_1419_STUDY]

