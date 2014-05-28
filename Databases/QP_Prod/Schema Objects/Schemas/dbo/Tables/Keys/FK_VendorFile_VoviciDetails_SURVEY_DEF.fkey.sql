ALTER TABLE [dbo].[VendorFile_VoviciDetails]  WITH CHECK ADD  CONSTRAINT [FK_VendorFile_VoviciDetails_SURVEY_DEF] FOREIGN KEY([Survey_ID])
REFERENCES [dbo].[SURVEY_DEF] ([SURVEY_ID])


GO
ALTER TABLE [dbo].[VendorFile_VoviciDetails] CHECK CONSTRAINT [FK_VendorFile_VoviciDetails_SURVEY_DEF]

