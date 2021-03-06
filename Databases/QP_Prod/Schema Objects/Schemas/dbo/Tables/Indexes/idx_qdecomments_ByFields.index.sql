﻿CREATE NONCLUSTERED INDEX [idx_qdecomments_ByFields] ON [dbo].[QDEComments]
(
	[strKeyedBy] ASC,
	[strKeyVerifiedBy] ASC,
	[strCodedBy] ASC,
	[strCodeVerifiedBy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


