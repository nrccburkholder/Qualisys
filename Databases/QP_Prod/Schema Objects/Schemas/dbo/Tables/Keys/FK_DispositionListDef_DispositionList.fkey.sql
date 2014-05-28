ALTER TABLE [dbo].[DispositionListDef]  WITH CHECK ADD  CONSTRAINT [FK_DispositionListDef_DispositionList] FOREIGN KEY([DispositionList_id])
REFERENCES [dbo].[DispositionList] ([DispositionList_id])


GO
ALTER TABLE [dbo].[DispositionListDef] CHECK CONSTRAINT [FK_DispositionListDef_DispositionList]

