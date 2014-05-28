ALTER TABLE [dbo].[PaperConfigSheet]  WITH CHECK ADD  CONSTRAINT [FK_PprCnfgSht_PprSz_id] FOREIGN KEY([papersize_id])
REFERENCES [dbo].[PAPERSIZE] ([PAPERSIZE_ID])


GO
ALTER TABLE [dbo].[PaperConfigSheet] CHECK CONSTRAINT [FK_PprCnfgSht_PprSz_id]

