ALTER TABLE [dbo].[StandardMethodologyBySurveyType]  WITH CHECK ADD  CONSTRAINT [FK_SMST_SurveyType] FOREIGN KEY([SurveyType_id])
REFERENCES [dbo].[SurveyType] ([SurveyType_ID])


GO
ALTER TABLE [dbo].[StandardMethodologyBySurveyType] CHECK CONSTRAINT [FK_SMST_SurveyType]

