﻿CREATE NONCLUSTERED INDEX [IDX_SCHEDULEDMAILING_METHDLOGY] ON [dbo].[SCHEDULEDMAILING]
(
	[METHODOLOGY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


