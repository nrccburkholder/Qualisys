﻿CREATE NONCLUSTERED INDEX [IDX_METALOOKUP_LTABLELFIELD] ON [dbo].[METALOOKUP]
(
	[NUMLKUPTABLE_ID] ASC,
	[NUMLKUPFIELD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]


