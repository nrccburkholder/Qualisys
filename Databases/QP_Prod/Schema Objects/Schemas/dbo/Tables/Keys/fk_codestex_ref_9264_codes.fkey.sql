ALTER TABLE [dbo].[CODESTEXT]  WITH NOCHECK ADD  CONSTRAINT [fk_codestex_ref_9264_codes] FOREIGN KEY([Code])
REFERENCES [dbo].[Codes] ([Code])


GO
ALTER TABLE [dbo].[CODESTEXT] CHECK CONSTRAINT [fk_codestex_ref_9264_codes]

