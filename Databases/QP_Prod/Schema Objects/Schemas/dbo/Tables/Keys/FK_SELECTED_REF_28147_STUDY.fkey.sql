﻿ALTER TABLE [dbo].[SELECTEDSAMPLE]  WITH CHECK ADD  CONSTRAINT [FK_SELECTED_REF_28147_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [dbo].[STUDY] ([STUDY_ID])


GO
ALTER TABLE [dbo].[SELECTEDSAMPLE] CHECK CONSTRAINT [FK_SELECTED_REF_28147_STUDY]

