﻿CREATE NONCLUSTERED INDEX [idx_sampleplanWorksheet_Sampleset] ON [dbo].[SamplePlanWorksheet]
(
	[Sampleset_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


