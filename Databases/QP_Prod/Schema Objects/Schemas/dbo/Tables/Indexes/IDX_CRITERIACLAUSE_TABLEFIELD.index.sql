﻿CREATE NONCLUSTERED INDEX [IDX_CRITERIACLAUSE_TABLEFIELD] ON [dbo].[CRITERIACLAUSE]
(
	[TABLE_ID] ASC,
	[FIELD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]


