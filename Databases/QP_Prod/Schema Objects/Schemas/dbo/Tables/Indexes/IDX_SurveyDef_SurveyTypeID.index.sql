﻿CREATE NONCLUSTERED INDEX [IDX_SurveyDef_SurveyTypeID] ON [dbo].[SURVEY_DEF]
(
	[SurveyType_id] ASC
)
INCLUDE ( 	[SURVEY_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


