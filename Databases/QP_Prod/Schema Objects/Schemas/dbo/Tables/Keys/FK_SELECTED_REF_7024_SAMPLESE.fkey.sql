﻿ALTER TABLE [dbo].[SELECTEDSAMPLE]  WITH CHECK ADD  CONSTRAINT [FK_SELECTED_REF_7024_SAMPLESE] FOREIGN KEY([SAMPLESET_ID])
REFERENCES [dbo].[SAMPLESET] ([SAMPLESET_ID])


GO
ALTER TABLE [dbo].[SELECTEDSAMPLE] CHECK CONSTRAINT [FK_SELECTED_REF_7024_SAMPLESE]
