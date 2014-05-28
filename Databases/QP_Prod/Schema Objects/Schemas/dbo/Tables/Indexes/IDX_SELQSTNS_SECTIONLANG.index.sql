﻿CREATE NONCLUSTERED INDEX [IDX_SELQSTNS_SECTIONLANG] ON [dbo].[SEL_QSTNS]
(
	[SECTION_ID] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]


