ALTER TABLE [dbo].[SUFacility]  WITH CHECK ADD  CONSTRAINT [FK_SUF_Medicare] FOREIGN KEY([MedicareNumber])
REFERENCES [dbo].[MedicareLookup] ([MedicareNumber])


GO
ALTER TABLE [dbo].[SUFacility] CHECK CONSTRAINT [FK_SUF_Medicare]

