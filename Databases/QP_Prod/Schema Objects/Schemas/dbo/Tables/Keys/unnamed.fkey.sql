ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD FOREIGN KEY([auditcategory_id])
REFERENCES [dbo].[AuditCategories] ([auditcategory_id])
GO
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD FOREIGN KEY([audittype_id])
REFERENCES [dbo].[AuditTypes] ([audittype_id])
GO
ALTER TABLE [dbo].[DL_TranslationModuleMapping]  WITH CHECK ADD FOREIGN KEY([TranslationModule_ID])
REFERENCES [dbo].[DL_TranslationModules] ([TranslationModule_ID])
GO
ALTER TABLE [dbo].[DL_TranslationModuleMappingRecode]  WITH CHECK ADD FOREIGN KEY([TranslationModuleMapping_ID])
REFERENCES [dbo].[DL_TranslationModuleMapping] ([TranslationModuleMapping_ID])
GO
ALTER TABLE [dbo].[DL_TranslationModules]  WITH CHECK ADD FOREIGN KEY([LithoLookupType_id])
REFERENCES [dbo].[DL_TranslationModuleLithoLookupTypes] ([LithoLookupType_id])
GO
ALTER TABLE [dbo].[QSIDataForm]  WITH CHECK ADD FOREIGN KEY([Batch_ID])
REFERENCES [dbo].[QSIDataBatch] ([Batch_ID])
GO
ALTER TABLE [dbo].[QSIDataForm]  WITH CHECK ADD FOREIGN KEY([QuestionForm_ID])
REFERENCES [dbo].[QUESTIONFORM] ([QUESTIONFORM_ID])
GO
ALTER TABLE [dbo].[QSIDataForm]  WITH CHECK ADD FOREIGN KEY([SentMail_ID])
REFERENCES [dbo].[SENTMAILING] ([SENTMAIL_ID])
GO
ALTER TABLE [dbo].[QSIDataForm]  WITH CHECK ADD FOREIGN KEY([Survey_ID])
REFERENCES [dbo].[SURVEY_DEF] ([SURVEY_ID])
GO
ALTER TABLE [dbo].[QSIDataResults]  WITH CHECK ADD FOREIGN KEY([Form_ID])
REFERENCES [dbo].[QSIDataForm] ([Form_ID])
GO
ALTER TABLE [dbo].[VendorDisp_11042009150321000]  WITH CHECK ADD FOREIGN KEY([VendorDisposition_ID])
REFERENCES [dbo].[VendorDispositions] ([VendorDisposition_ID])
GO
ALTER TABLE [dbo].[VendorDisp_11042009150321000]  WITH CHECK ADD FOREIGN KEY([DL_LithoCode_ID])
REFERENCES [dbo].[DL_LithoCodes] ([DL_LithoCode_ID])


