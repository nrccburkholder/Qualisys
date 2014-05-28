ALTER TABLE [dbo].[Survey_SurveyTypeDef]  WITH CHECK ADD  CONSTRAINT [FK_Survey_SurveyTypeDef_SurveyTypeDef] FOREIGN KEY([SurveyTypeDef_id])
REFERENCES [dbo].[SurveyTypeDef] ([SurveyTypeDef_id])


GO
ALTER TABLE [dbo].[Survey_SurveyTypeDef] CHECK CONSTRAINT [FK_Survey_SurveyTypeDef_SurveyTypeDef]

