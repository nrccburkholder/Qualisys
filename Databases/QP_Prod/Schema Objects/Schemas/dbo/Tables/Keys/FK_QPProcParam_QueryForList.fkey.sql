ALTER TABLE [dbo].[QPProcParam]  WITH CHECK ADD  CONSTRAINT [FK_QPProcParam_QueryForList] FOREIGN KEY([QueryForList_id])
REFERENCES [dbo].[QueryForList] ([QueryForList_id])
ON UPDATE CASCADE


GO
ALTER TABLE [dbo].[QPProcParam] CHECK CONSTRAINT [FK_QPProcParam_QueryForList]

