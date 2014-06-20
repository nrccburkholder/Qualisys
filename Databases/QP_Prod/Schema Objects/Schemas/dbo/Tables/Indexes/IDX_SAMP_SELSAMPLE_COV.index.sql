﻿CREATE NONCLUSTERED INDEX [IDX_SAMP_SELSAMPLE_COV] ON [dbo].[SELECTEDSAMPLE]
(
	[STUDY_ID] ASC,
	[SAMPLEUNIT_ID] ASC,
	[POP_ID] ASC,
	[SAMPLESET_ID] ASC,
	[STRUNITSELECTTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]

