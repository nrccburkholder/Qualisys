﻿CREATE NONCLUSTERED INDEX [idx_mailmeth_meth_survey] ON [dbo].[MAILINGMETHODOLOGY]
(
	[METHODOLOGY_ID] ASC,
	[SURVEY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

