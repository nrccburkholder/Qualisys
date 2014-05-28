ALTER TABLE [dbo].[DL_SurveyDataLoad]  WITH CHECK ADD  CONSTRAINT [FK_DL_SurveyDataLoad_DL_dataLoad] FOREIGN KEY([DataLoad_ID])
REFERENCES [dbo].[DL_DataLoad] ([DataLoad_ID])


GO
ALTER TABLE [dbo].[DL_SurveyDataLoad] CHECK CONSTRAINT [FK_DL_SurveyDataLoad_DL_dataLoad]

