ALTER TABLE [dbo].[MM_EmailBlast]  WITH CHECK ADD  CONSTRAINT [FK__MM_EmailB__Email__5ECC629A] FOREIGN KEY([EmailBlast_ID])
REFERENCES [dbo].[MM_EmailBlast_Options] ([EmailBlast_ID])


GO
ALTER TABLE [dbo].[MM_EmailBlast] CHECK CONSTRAINT [FK__MM_EmailB__Email__5ECC629A]

