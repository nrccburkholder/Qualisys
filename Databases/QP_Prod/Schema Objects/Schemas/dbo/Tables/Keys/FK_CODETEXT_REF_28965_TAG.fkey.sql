﻿ALTER TABLE [dbo].[CODETEXTTAG]  WITH CHECK ADD  CONSTRAINT [FK_CODETEXT_REF_28965_TAG] FOREIGN KEY([TAG_ID])
REFERENCES [dbo].[TAG] ([TAG_ID])


GO
ALTER TABLE [dbo].[CODETEXTTAG] CHECK CONSTRAINT [FK_CODETEXT_REF_28965_TAG]

