﻿CREATE NONCLUSTERED INDEX [NPSENTMAILING0] ON [dbo].[NPSENTMAILING]
(
	[SENTMAIL_ID] ASC,
	[DATPRINTED] ASC,
	[DATMAILED] ASC,
	[PAPERCONFIG_ID] ASC,
	[STRPOSTALBUNDLE] ASC,
	[INTPAGES] ASC,
	[datBundled] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


