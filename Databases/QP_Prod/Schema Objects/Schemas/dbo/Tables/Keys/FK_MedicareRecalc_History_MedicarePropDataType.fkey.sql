ALTER TABLE [dbo].[MedicareRecalc_History]  WITH CHECK ADD  CONSTRAINT [FK_MedicareRecalc_History_MedicarePropDataType] FOREIGN KEY([MedicarePropDataType_ID])
REFERENCES [dbo].[MedicarePropDataType] ([MedicarePropDataType_ID])


GO
ALTER TABLE [dbo].[MedicareRecalc_History] CHECK CONSTRAINT [FK_MedicareRecalc_History_MedicarePropDataType]

