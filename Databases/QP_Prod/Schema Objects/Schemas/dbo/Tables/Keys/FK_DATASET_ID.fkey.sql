﻿ALTER TABLE [dbo].[DATASET_QUEUE]  WITH CHECK ADD  CONSTRAINT [FK_DATASET_ID] FOREIGN KEY([DATASET_ID])
REFERENCES [dbo].[DATA_SET] ([DATASET_ID])


GO
ALTER TABLE [dbo].[DATASET_QUEUE] CHECK CONSTRAINT [FK_DATASET_ID]

