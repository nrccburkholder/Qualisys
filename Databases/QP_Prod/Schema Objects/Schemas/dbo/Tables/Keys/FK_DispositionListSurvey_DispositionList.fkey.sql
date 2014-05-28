ALTER TABLE [dbo].[DispositionListSurvey]  WITH CHECK ADD  CONSTRAINT [FK_DispositionListSurvey_DispositionList] FOREIGN KEY([DispositionList_id])
REFERENCES [dbo].[DispositionList] ([DispositionList_id])


GO
ALTER TABLE [dbo].[DispositionListSurvey] CHECK CONSTRAINT [FK_DispositionListSurvey_DispositionList]

