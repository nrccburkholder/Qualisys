﻿CREATE NONCLUSTERED INDEX [IDX_QFORM_SAMPLEPOP] ON [dbo].[QUESTIONFORM]
(
	[SAMPLEPOP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

