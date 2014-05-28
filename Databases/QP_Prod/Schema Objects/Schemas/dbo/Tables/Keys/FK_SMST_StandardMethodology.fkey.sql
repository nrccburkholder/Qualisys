ALTER TABLE [dbo].[StandardMethodologyBySurveyType]  WITH CHECK ADD  CONSTRAINT [FK_SMST_StandardMethodology] FOREIGN KEY([StandardMethodologyID])
REFERENCES [dbo].[StandardMethodology] ([StandardMethodologyID])


GO
ALTER TABLE [dbo].[StandardMethodologyBySurveyType] CHECK CONSTRAINT [FK_SMST_StandardMethodology]

