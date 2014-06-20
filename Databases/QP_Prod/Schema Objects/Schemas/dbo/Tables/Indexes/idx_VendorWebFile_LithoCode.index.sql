﻿CREATE NONCLUSTERED INDEX [idx_VendorWebFile_LithoCode] ON [dbo].[VendorWebFile_Data]
(
	[Litho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

