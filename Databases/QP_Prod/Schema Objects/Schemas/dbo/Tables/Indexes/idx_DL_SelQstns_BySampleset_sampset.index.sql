﻿CREATE NONCLUSTERED INDEX [idx_DL_SelQstns_BySampleset_sampset] ON [dbo].[DL_SEL_QSTNS_BySampleSet]
(
	[SampleSet_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


