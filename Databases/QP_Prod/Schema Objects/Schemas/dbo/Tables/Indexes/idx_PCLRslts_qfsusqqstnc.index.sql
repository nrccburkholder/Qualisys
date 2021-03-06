﻿CREATE NONCLUSTERED INDEX [idx_PCLRslts_qfsusqqstnc] ON [dbo].[PCLResults]
(
	[QuestionForm_id] ASC,
	[SampleUnit_id] ASC,
	[SelQstns_id] ASC,
	[QstnCore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]


