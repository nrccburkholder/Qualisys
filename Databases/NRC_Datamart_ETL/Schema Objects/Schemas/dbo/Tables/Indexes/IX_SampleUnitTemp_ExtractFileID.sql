﻿CREATE NONCLUSTERED INDEX [IX_SampleUnitTemp_ExtractFileID] ON [dbo].[SampleUnitTemp]
(
	[ExtractFileID] ASC
)
INCLUDE ( 	[SAMPLESET_ID],
	[SAMPLEUNIT_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO


