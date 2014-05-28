ALTER TABLE [dbo].[STUDYCOMPARISON]  WITH CHECK ADD  CONSTRAINT [FK_MktGuide_PlanType] FOREIGN KEY([mktguideplantype_id])
REFERENCES [dbo].[MktGuide_PlanType] ([mktguideplantype_id])


GO
ALTER TABLE [dbo].[STUDYCOMPARISON] CHECK CONSTRAINT [FK_MktGuide_PlanType]

