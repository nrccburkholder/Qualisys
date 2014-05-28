﻿CREATE NONCLUSTERED INDEX [IDX_DATA_SET_DATAPPLY_DT] ON [dbo].[DATA_SET]
(
	[DATAPPLY_DT] ASC
)
INCLUDE ( 	[DATASET_ID],
	[STUDY_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


