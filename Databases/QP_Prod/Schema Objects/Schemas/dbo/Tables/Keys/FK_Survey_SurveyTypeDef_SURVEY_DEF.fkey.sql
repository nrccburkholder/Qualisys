ALTER TABLE [dbo].[Survey_SurveyTypeDef]  WITH CHECK ADD  CONSTRAINT [FK_Survey_SurveyTypeDef_SURVEY_DEF] FOREIGN KEY([Survey_id])
REFERENCES [dbo].[SURVEY_DEF] ([SURVEY_ID])


GO
ALTER TABLE [dbo].[Survey_SurveyTypeDef] CHECK CONSTRAINT [FK_Survey_SurveyTypeDef_SURVEY_DEF]

