ALTER TABLE [dbo].[QPReport]  WITH CHECK ADD  CONSTRAINT [FK_QPReport_QPReportCategory] FOREIGN KEY([QPReportCategory_id])
REFERENCES [dbo].[QPReportCategory] ([QPReportCategory_id])
ON UPDATE CASCADE
ON DELETE CASCADE


GO
ALTER TABLE [dbo].[QPReport] CHECK CONSTRAINT [FK_QPReport_QPReportCategory]

