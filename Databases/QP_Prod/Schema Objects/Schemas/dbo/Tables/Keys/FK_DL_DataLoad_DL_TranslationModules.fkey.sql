ALTER TABLE [dbo].[DL_DataLoad]  WITH CHECK ADD  CONSTRAINT [FK_DL_DataLoad_DL_TranslationModules] FOREIGN KEY([TranslationModule_ID])
REFERENCES [dbo].[DL_TranslationModules] ([TranslationModule_ID])


GO
ALTER TABLE [dbo].[DL_DataLoad] CHECK CONSTRAINT [FK_DL_DataLoad_DL_TranslationModules]

