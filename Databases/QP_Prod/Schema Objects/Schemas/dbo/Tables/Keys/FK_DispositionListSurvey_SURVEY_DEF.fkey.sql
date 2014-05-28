ALTER TABLE [dbo].[DispositionListSurvey]  WITH CHECK ADD  CONSTRAINT [FK_DispositionListSurvey_SURVEY_DEF] FOREIGN KEY([Survey_id])
REFERENCES [dbo].[SURVEY_DEF] ([SURVEY_ID])


GO
ALTER TABLE [dbo].[DispositionListSurvey] CHECK CONSTRAINT [FK_DispositionListSurvey_SURVEY_DEF]

