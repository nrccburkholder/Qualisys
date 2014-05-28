ALTER TABLE [dbo].[ClientSUFacilityLookup]  WITH CHECK ADD  CONSTRAINT [FK_CFL_Client] FOREIGN KEY([Client_id])
REFERENCES [dbo].[CLIENT] ([CLIENT_ID])


GO
ALTER TABLE [dbo].[ClientSUFacilityLookup] CHECK CONSTRAINT [FK_CFL_Client]

