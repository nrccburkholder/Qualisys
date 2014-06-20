﻿CREATE NONCLUSTERED INDEX [idx_sentmailing_SetNextMailingRecommend] ON [dbo].[SENTMAILING]
(
	[DATMAILED] ASC,
	[PAPERCONFIG_ID] ASC,
	[STRPOSTALBUNDLE] ASC
)
INCLUDE ( 	[SENTMAIL_ID],
	[SCHEDULEDMAILING_ID],
	[METHODOLOGY_ID],
	[INTPAGES],
	[datBundled]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]

