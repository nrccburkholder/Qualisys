﻿ALTER TABLE [dbo].[SCHEDULEDMAILING]  WITH CHECK ADD  CONSTRAINT [FK_SCHEDULE_REF_28163_MAILINGM] FOREIGN KEY([METHODOLOGY_ID])
REFERENCES [dbo].[MAILINGMETHODOLOGY] ([METHODOLOGY_ID])


GO
ALTER TABLE [dbo].[SCHEDULEDMAILING] CHECK CONSTRAINT [FK_SCHEDULE_REF_28163_MAILINGM]
