﻿ALTER TABLE [dbo].[METALOOKUP]  WITH CHECK ADD  CONSTRAINT [FK_METALOOK_REF_184_METASTRU] FOREIGN KEY([NUMMASTERTABLE_ID], [NUMMASTERFIELD_ID])
REFERENCES [dbo].[METASTRUCTURE] ([TABLE_ID], [FIELD_ID])


GO
ALTER TABLE [dbo].[METALOOKUP] CHECK CONSTRAINT [FK_METALOOK_REF_184_METASTRU]

