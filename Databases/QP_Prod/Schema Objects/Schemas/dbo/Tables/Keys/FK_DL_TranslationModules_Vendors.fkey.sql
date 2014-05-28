ALTER TABLE [dbo].[DL_TranslationModules]  WITH CHECK ADD  CONSTRAINT [FK_DL_TranslationModules_Vendors] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])


GO
ALTER TABLE [dbo].[DL_TranslationModules] CHECK CONSTRAINT [FK_DL_TranslationModules_Vendors]

