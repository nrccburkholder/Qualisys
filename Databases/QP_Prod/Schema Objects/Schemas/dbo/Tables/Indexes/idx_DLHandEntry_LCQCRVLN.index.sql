﻿CREATE NONCLUSTERED INDEX [idx_DLHandEntry_LCQCRVLN] ON [dbo].[DL_HandEntry]
(
	[DL_LithoCode_ID] ASC,
	[QstnCore] ASC,
	[ItemNumber] ASC,
	[LineNumber] ASC,
	[HandEntryText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

