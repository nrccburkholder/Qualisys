﻿ALTER TABLE [dbo].[STUDY]  WITH NOCHECK ADD  CONSTRAINT [FK_STUDY_REF_16407_EMPLOYEE] FOREIGN KEY([ADEMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])


GO
ALTER TABLE [dbo].[STUDY] CHECK CONSTRAINT [FK_STUDY_REF_16407_EMPLOYEE]

