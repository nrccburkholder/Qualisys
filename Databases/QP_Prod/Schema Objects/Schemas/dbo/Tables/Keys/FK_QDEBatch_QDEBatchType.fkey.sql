ALTER TABLE [dbo].[QDEBatch]  WITH CHECK ADD  CONSTRAINT [FK_QDEBatch_QDEBatchType] FOREIGN KEY([BatchType_id])
REFERENCES [dbo].[QDEBatchType] ([BatchType_id])


GO
ALTER TABLE [dbo].[QDEBatch] CHECK CONSTRAINT [FK_QDEBatch_QDEBatchType]

