﻿CREATE NONCLUSTERED INDEX [idx_groupedPrint_setnextmailingRecommend] ON [dbo].[GroupedPrint]
(
	[PaperConfig_id] ASC,
	[datBundled] ASC,
	[datPrinted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


