﻿ALTER TABLE [dbo].[QUALPRO_SYSLOGS]  WITH NOCHECK ADD  CONSTRAINT [FK_QUALPRO__REF_2460_EMPLOYEE] FOREIGN KEY([EMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])


GO
ALTER TABLE [dbo].[QUALPRO_SYSLOGS] CHECK CONSTRAINT [FK_QUALPRO__REF_2460_EMPLOYEE]

