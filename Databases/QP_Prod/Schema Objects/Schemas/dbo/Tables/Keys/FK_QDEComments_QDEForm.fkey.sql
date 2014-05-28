ALTER TABLE [dbo].[QDEComments]  WITH CHECK ADD  CONSTRAINT [FK_QDEComments_QDEForm] FOREIGN KEY([Form_id])
REFERENCES [dbo].[QDEForm] ([Form_id])


GO
ALTER TABLE [dbo].[QDEComments] CHECK CONSTRAINT [FK_QDEComments_QDEForm]

