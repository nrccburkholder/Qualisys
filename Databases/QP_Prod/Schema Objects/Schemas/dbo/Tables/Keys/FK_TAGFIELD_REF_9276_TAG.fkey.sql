﻿ALTER TABLE [dbo].[TAGFIELD]  WITH CHECK ADD  CONSTRAINT [FK_TAGFIELD_REF_9276_TAG] FOREIGN KEY([TAG_ID])
REFERENCES [dbo].[TAG] ([TAG_ID])


GO
ALTER TABLE [dbo].[TAGFIELD] CHECK CONSTRAINT [FK_TAGFIELD_REF_9276_TAG]

