ALTER TABLE [dbo].[CultureToLanguages]  WITH CHECK ADD  CONSTRAINT [FK_CultureToLanguages_Cultures] FOREIGN KEY([CultureID])
REFERENCES [dbo].[Cultures] ([CultureID])


GO
ALTER TABLE [dbo].[CultureToLanguages] CHECK CONSTRAINT [FK_CultureToLanguages_Cultures]

