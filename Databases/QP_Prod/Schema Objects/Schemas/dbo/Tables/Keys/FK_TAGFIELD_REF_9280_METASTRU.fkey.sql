﻿ALTER TABLE [dbo].[TAGFIELD]  WITH CHECK ADD  CONSTRAINT [FK_TAGFIELD_REF_9280_METASTRU] FOREIGN KEY([TABLE_ID], [FIELD_ID])
REFERENCES [dbo].[METASTRUCTURE] ([TABLE_ID], [FIELD_ID])


GO
ALTER TABLE [dbo].[TAGFIELD] CHECK CONSTRAINT [FK_TAGFIELD_REF_9280_METASTRU]

