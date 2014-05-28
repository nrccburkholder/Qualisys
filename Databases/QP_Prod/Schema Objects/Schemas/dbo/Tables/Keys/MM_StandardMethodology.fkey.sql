ALTER TABLE [dbo].[MAILINGMETHODOLOGY]  WITH CHECK ADD  CONSTRAINT [MM_StandardMethodology] FOREIGN KEY([StandardMethodologyID])
REFERENCES [dbo].[StandardMethodology] ([StandardMethodologyID])


GO
ALTER TABLE [dbo].[MAILINGMETHODOLOGY] CHECK CONSTRAINT [MM_StandardMethodology]

