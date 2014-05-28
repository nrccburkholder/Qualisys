ALTER TABLE [dbo].[StandardMailingStep]  WITH CHECK ADD  CONSTRAINT [FK_StandardMAILINGS_REF_6482_MAILING] FOREIGN KEY([StandardMethodologyID])
REFERENCES [dbo].[StandardMethodology] ([StandardMethodologyID])


GO
ALTER TABLE [dbo].[StandardMailingStep] CHECK CONSTRAINT [FK_StandardMAILINGS_REF_6482_MAILING]

