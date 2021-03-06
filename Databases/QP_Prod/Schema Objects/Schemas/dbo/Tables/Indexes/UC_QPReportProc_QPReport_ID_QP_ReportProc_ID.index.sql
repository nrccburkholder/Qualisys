﻿CREATE UNIQUE NONCLUSTERED INDEX [UC_QPReportProc_QPReport_ID_QP_ReportProc_ID] ON [dbo].[QPReportProc]
(
	[QPReport_ID] ASC,
	[QPReportProc_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


