﻿ALTER TABLE [dbo].[PCLOUTPUT2]  WITH CHECK ADD  CONSTRAINT [FK_PCLOUTPU_REF_31743_PAPERSI2] FOREIGN KEY([PAPERSIZE_ID])
REFERENCES [dbo].[PAPERSIZE] ([PAPERSIZE_ID])


GO
ALTER TABLE [dbo].[PCLOUTPUT2] CHECK CONSTRAINT [FK_PCLOUTPU_REF_31743_PAPERSI2]

