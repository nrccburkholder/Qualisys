﻿CREATE NONCLUSTERED INDEX [IDX_BUSRULE_SURVEY] ON [dbo].[BUSINESSRULE]
(
	[SURVEY_ID] ASC,
	[BUSRULE_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]


