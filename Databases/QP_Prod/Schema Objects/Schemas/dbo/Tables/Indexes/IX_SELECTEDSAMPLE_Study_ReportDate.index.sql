﻿CREATE NONCLUSTERED INDEX [IX_SELECTEDSAMPLE_Study_ReportDate] ON [dbo].[SELECTEDSAMPLE]
(
	[STUDY_ID] ASC,
	[ReportDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


