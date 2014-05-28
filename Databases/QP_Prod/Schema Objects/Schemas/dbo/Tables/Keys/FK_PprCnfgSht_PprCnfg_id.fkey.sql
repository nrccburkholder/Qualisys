ALTER TABLE [dbo].[PaperConfigSheet]  WITH CHECK ADD  CONSTRAINT [FK_PprCnfgSht_PprCnfg_id] FOREIGN KEY([paperconfig_id])
REFERENCES [dbo].[PAPERCONFIG] ([PAPERCONFIG_ID])


GO
ALTER TABLE [dbo].[PaperConfigSheet] CHECK CONSTRAINT [FK_PprCnfgSht_PprCnfg_id]

