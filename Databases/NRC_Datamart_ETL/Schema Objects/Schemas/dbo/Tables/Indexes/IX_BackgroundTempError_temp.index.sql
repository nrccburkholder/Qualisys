﻿CREATE NONCLUSTERED INDEX [IX_BackgroundTempError_temp] ON [dbo].[BackgroundTempError]
(
	[ExtractFileID] ASC,
	[SAMPLEPOP_ID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


