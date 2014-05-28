﻿CREATE NONCLUSTERED INDEX [IX_teamstatus_workcompleted] ON [dbo].[teamstatus_workcompleted]
(
	[SurveyID] ASC,
	[SampleDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]


