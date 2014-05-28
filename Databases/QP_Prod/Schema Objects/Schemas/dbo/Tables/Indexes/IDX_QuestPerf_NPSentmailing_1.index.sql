﻿CREATE NONCLUSTERED INDEX [IDX_QuestPerf_NPSentmailing_1] ON [dbo].[NPSENTMAILING]
(
	[DATPRINTED] ASC,
	[PAPERCONFIG_ID] ASC,
	[STRPOSTALBUNDLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


