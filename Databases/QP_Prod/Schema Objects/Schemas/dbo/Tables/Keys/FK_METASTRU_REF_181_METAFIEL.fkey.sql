﻿ALTER TABLE [dbo].[METASTRUCTURE]  WITH NOCHECK ADD  CONSTRAINT [FK_METASTRU_REF_181_METAFIEL] FOREIGN KEY([FIELD_ID])
REFERENCES [dbo].[METAFIELD] ([FIELD_ID])


GO
ALTER TABLE [dbo].[METASTRUCTURE] CHECK CONSTRAINT [FK_METASTRU_REF_181_METAFIEL]

