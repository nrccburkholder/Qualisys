﻿ALTER TABLE [dbo].[SAMPLESET]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLESE_REF_7018_SAMPLEPL] FOREIGN KEY([SAMPLEPLAN_ID])
REFERENCES [dbo].[SAMPLEPLAN] ([SAMPLEPLAN_ID])


GO
ALTER TABLE [dbo].[SAMPLESET] CHECK CONSTRAINT [FK_SAMPLESE_REF_7018_SAMPLEPL]

