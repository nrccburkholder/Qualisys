﻿ALTER TABLE [dbo].[METASTRUCTURE]  WITH CHECK ADD  CONSTRAINT [FK_METASTRU_REF_178_METATABL] FOREIGN KEY([TABLE_ID])
REFERENCES [dbo].[METATABLE] ([TABLE_ID])


GO
ALTER TABLE [dbo].[METASTRUCTURE] CHECK CONSTRAINT [FK_METASTRU_REF_178_METATABL]
