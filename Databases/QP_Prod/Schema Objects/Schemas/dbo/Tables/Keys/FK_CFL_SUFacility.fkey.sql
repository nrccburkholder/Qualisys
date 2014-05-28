ALTER TABLE [dbo].[ClientSUFacilityLookup]  WITH CHECK ADD  CONSTRAINT [FK_CFL_SUFacility] FOREIGN KEY([SUFacility_id])
REFERENCES [dbo].[SUFacility] ([SUFacility_id])


GO
ALTER TABLE [dbo].[ClientSUFacilityLookup] CHECK CONSTRAINT [FK_CFL_SUFacility]

