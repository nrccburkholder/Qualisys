﻿ALTER TABLE [dbo].[SAMPLEDATASET]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEDA_REF_59320_DATA_SET] FOREIGN KEY([DATASET_ID])
REFERENCES [dbo].[DATA_SET] ([DATASET_ID])


GO
ALTER TABLE [dbo].[SAMPLEDATASET] CHECK CONSTRAINT [FK_SAMPLEDA_REF_59320_DATA_SET]

