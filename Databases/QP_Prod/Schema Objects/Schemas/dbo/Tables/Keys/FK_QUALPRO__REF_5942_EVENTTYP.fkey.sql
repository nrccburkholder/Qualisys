﻿ALTER TABLE [dbo].[QUALPRO_SYSLOGS]  WITH CHECK ADD  CONSTRAINT [FK_QUALPRO__REF_5942_EVENTTYP] FOREIGN KEY([EVENTTYPE_ID])
REFERENCES [dbo].[EVENTTYPE] ([EVENTTYPE_ID])


GO
ALTER TABLE [dbo].[QUALPRO_SYSLOGS] CHECK CONSTRAINT [FK_QUALPRO__REF_5942_EVENTTYP]
