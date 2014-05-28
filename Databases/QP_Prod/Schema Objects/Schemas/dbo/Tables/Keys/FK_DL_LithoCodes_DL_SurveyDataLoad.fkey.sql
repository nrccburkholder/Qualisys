ALTER TABLE [dbo].[DL_LithoCodes]  WITH CHECK ADD  CONSTRAINT [FK_DL_LithoCodes_DL_SurveyDataLoad] FOREIGN KEY([SurveyDataLoad_ID])
REFERENCES [dbo].[DL_SurveyDataLoad] ([SurveyDataLoad_ID])


GO
ALTER TABLE [dbo].[DL_LithoCodes] CHECK CONSTRAINT [FK_DL_LithoCodes_DL_SurveyDataLoad]

