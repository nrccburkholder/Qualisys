ALTER TABLE [dbo].[CultureToLanguages]  WITH CHECK ADD  CONSTRAINT [FK_CultureToLanguages_Languages] FOREIGN KEY([LangID])
REFERENCES [dbo].[Languages] ([LangID])


GO
ALTER TABLE [dbo].[CultureToLanguages] CHECK CONSTRAINT [FK_CultureToLanguages_Languages]

