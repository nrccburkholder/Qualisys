﻿ALTER TABLE [dbo].[SAMPLEUNIT_11242009193814000]  WITH NOCHECK ADD  CONSTRAINT [FK_SampleHierarchy] FOREIGN KEY([REPORTING_HIERARCHY_ID])
REFERENCES [dbo].[REPORTINGHIERARCHY] ([REPORTING_HIERARCHY_ID])


GO
ALTER TABLE [dbo].[SAMPLEUNIT_11242009193814000] CHECK CONSTRAINT [FK_SampleHierarchy]

